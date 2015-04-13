
unescape = (value) ->
  value.replace /&amp;/gm, '&'
      .replace /&lt;/gm, '<'
      .replace /&gt;/gm, '>'

# Create a namespace to export our public methods.
SyntaxHighlighter = exports? and exports or @SyntaxHighlighter = {}

class SyntaxHighlighter.highlightjs
  @_styles = [
    { name: 'Arta', id: 'arta' }
    { name: 'Ascetic', id: 'ascetic' }
    { name: 'Brown Paper', id: 'brown_paper' }
    { name: 'Dark', id: 'dark' }
    { name: 'Default', id: 'default' }
    { name: 'Far', id: 'far' }
    { name: 'GitHub', id: 'github' }
    { name: 'GoogleCode', id: 'googlecode' }
    { name: 'Idea', id: 'idea' }
    { name: 'IR Black', id: 'ir_black' }
    { name: 'Magula', id: 'magula' }
    { name: 'Monokai', id: 'monokai' }
    { name: 'Pojoaque', id: 'pojoaque' }
    { name: 'Rainbow', id: 'rainbow' }
    { name: 'School Book', id: 'school_book' }
    { name: 'Solarized Dark', id: 'solarized_dark' }
    { name: 'Solarized Light', id: 'solarized_light' }
    { name: 'Sunburst', id: 'sunburst' }
    { name: 'Tomorrow', id: 'tomorrow' }
    { name: 'Tomorrow-Night-Blue', id: 'tomorrow-night-blue' }
    { name: 'Tomorrow-Night-Bright', id: 'tomorrow-night-bright' }
    { name: 'Tomorrow-Night', id: 'tomorrow-night' }
    { name: 'Tomorrow-Night-Eighties', id: 'tomorrow-night-eighties' }
    { name: 'VS', id: 'vs' }
    { name: 'Xcode', id: 'xcode' }
    { name: 'Zenburn', id: 'zenburn' }
  ]

  @getStyles: =>
    @_styles

  constructor: (@aliases) ->

    if not @aliases
      @aliases =
        brainfuck: "\\b(bf)$"
        cpp: "\\b(c|h|cpp|hpp)$"
        coffeescript: "\\b(coffee)$"
        handlebars: "\\b(hb)$"
        markdown: "\\b(md|mdown|mkd|mkdn|mdtext|mdtxt|txt|text|README)$"
        perl: "\\b(pl)$"
        python: "\\b(py)$"
        ruby: "\\b(rb)$"
        lisp: "\\b(scm|sl|scheme)$"
        bash: "\\b(sh|shell|ksh|tsh|csh|vb)$"

  highlight: (text, language='', continuation) =>

    if language
      for syntax, regexp of @aliases
        if RegExp(regexp).test language
          language = syntax
          break

      try
        hljs.highlight language, text, true, continuation
      catch e
        console.log e
        hljs.highlightAuto text
    else
      hljs.highlightAuto text

  render: (text, language='', continuation) =>
    hl = @highlight text, language, continuation
    """<pre class="hljs"><code class="language-#{hl.language}">#{hl.value.replace /&amp;/g, '&'}</code></pre>"""
