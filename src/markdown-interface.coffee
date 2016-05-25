# Interface = exports? and exports or @Interface = {}

# injector = angular.injector ['myApp']
# _ = injector.get 'lodash'

angular.module 'interfaces', ['ngLodash']

.service 'markdown', ($window, lodash) ->

  class Markdown
    constructor: (@options, @data=null, @meta={}, @converter) ->
      @textOffset = 0
      @html = null
      @outline = []
      if not @converter
        @converter = new $window.Markdown.Converter
        $window.Markdown.Extra.init @converter

      # Now that everything is set up, we can try to parse any data recieved.
      @setData(@data) if @data

    getData: ->
      @data

    setData: (@data) ->
      @textOffset = 0
      @parseMeta()
      @renderHtml()
      @

    getText: ->
      @data[@textOffset...]

    parseSyntaxFromUrl: (url) ->
      entities = url.split '.'
      if entities.length > 2 then entities[entities.length-2] else null

    parseMeta: ->
      results = @data.match /(^(-{3,})?[\s\S]*?)^(?:\2|\.{3,})?$/m
      if results isnt null and results[0] isnt @data
        try
          meta = YAML.parse results[1]
          for key, value of meta
            if key is null or value is null
              meta = {}
              break
          @meta = lodash.merge @meta, meta

          @textOffset = results[0].length if Object.keys(@meta).length isnt 0

        catch e
          @meta = {}

      @meta.Title = unescape(location.href).replace /^.*[\\\/]/, '' if not @meta.Title?
      if not @meta.Syntax?
        @meta.Syntax = if @meta.Filename?
          @meta.Filename
            .replace /^.*?(\..*?)$/, '$1'
        else
          unescape(location.href)
            .replace ///^.*?\/([^/]+)$///, '$1'
            .replace /\.(?:lit(.*?))$/i, '$1.md'
            .replace /\.(?:md|mdown|mkdown|markdown)$/i, ''
            .replace /^[^.]*\./, ''
        console.log @meta.Syntax
      @

    renderHtml: ->
      @html = @converter.makeHtml @getText()

      idCounters = {}

      @html = @html.replace ///<h([1-6])(?:\s+id="(.+?)")?>(.*?)</h\1>///g, (match, level, id, text) =>
        # Generate an id according to these rules:
        # <http://johnmacfarlane.net/pandoc/README.html#extension-auto_identifiers>
        #
        #   - Remove all formatting, links, etc.
        #   - Remove all footnotes.
        #   - Remove all punctuation, except underscores, hyphens, and periods.
        #   - Replace all spaces and newlines with hyphens.
        #   - Convert all alphabetic characters to lowercase.
        #   - Remove everything up to the first letter (identifiers may not
        #     begin with a number or punctuation mark).
        #   - If nothing is left after this, use the identifier section.
        #
        # These rules should, in most cases, allow one to determine the
        # identifier from the header text. The exception is when several
        # headers have the same text; in this case, the first will get an
        # identifier as described above; the second will get the same
        # identifier with -1 appended; the third with -2; and so on.

        # Transform the header text to generate the id.
        if not id?
          id = text.toLowerCase()
              .replace(/(\[.*?\])|(\(.*?\))/g, '')
              .replace(/[–— \n]/g, '-')
              .replace(/[^-_.0-9a-z]/g, '')
              .replace(/^[^a-z]+/, '')
              .replace(/^$/, 'section')

        # If the id is already recorded in the idCounters increment the counter
        # and append a dash and the new value as a suffix on the id.
        if idCounters[id]?
          idCounters[id] += 1
          id += "-#{idCounters[id]}"
        else
          idCounters[id] = 0

        """<h#{level} id="#{id}">#{text}</h#{level}>"""

      # Syntax highlighting
      if @options.syntaxHighlight? and @meta.Syntax?
        highlighter = new SyntaxHighlighter.highlightjs

        hl = top: undefined
        @html = @html.replace ///<pre><code>([\s\S]*?)</code></pre>///gm, (match, code) =>
            hl = highlighter.highlight(code, @meta.Syntax, hl.top)
            """<pre class="hljs"><code class="language-#{hl.language}">#{hl.value.replace /&amp;/g, '&'}</code></pre>"""

      @html

    getTitle: ->
      @meta.Title if @meta.Title?

    getHtml: ->
      @html

    getMeta: ->
      @meta

    getOutline: ->
      @outline.join ''

    Markdown
