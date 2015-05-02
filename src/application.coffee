# # Markup Reader

return if document.doctype

# Quickly clear the document's contents to prevent a *flash* of raw content.
document.documentElement.innerHTML = ''
text = ''
url = location.href

# TODO: Improve, ie. options = ...; JSON.parse merge options, localStorage.options if ...?
options = if localStorage.options? then JSON.parse localStorage.options else
  syntaxHighlight: true


# ------------------------------------------------------------------------------

# ## Angular

app = angular.module 'app', [
  'interfaces'
  'duScroll'
  'ngResource'
  'ui.bootstrap'
  'ui.select'
]

app.factory '_', ($window) ->
  if typeof $window._ is 'undefined' then null else $window._

# TODO: determine why this doesn't run when the document is first loaded
app.directive 'tableOfContents', (_, $document) ->
  restrict:'A',
  require:'?ngModel'
  link: (scope, elm, attrs, ngModel) ->
    updateSections = ->
      scope.sections = []
      stack = [ scope.sections ]
      angular.forEach $(':header'), (e) ->

        while e.tagName[1] > stack.length
          _.last(stack).push []
          stack.push(_.last(_.last(stack)))

        while stack.length > e.tagName[1]
          stack.pop()

        _.last(stack).push
          level: e.tagName[1]
          label: angular.element(e).text()
          element: e

    # avoid memoryleaks from dom references
    scope.$on '$destroy', ->
      scope.sections = []

    # scroll to one of the sections
    scope.scrollTo = (sections) ->
      # TODO: determine how to use `sections.element` directly instead
      # of `document.getElementById(sections.element.id)`
      # TODO: try to determine offset automatically
      $document.scrollToElementAnimated document.getElementById(sections.element.id), 70

    # when the html updates we update the sections
    ngModel.$render = updateSections
    updateSections()


app.config (uiSelectConfig) ->
  uiSelectConfig.theme = 'bootstrap'


# ## manifestService
#
# Retrieves the *Application Manifest* data from the `bower.json` file using
# the AngularJS *`$resource`* RESTful object.
app.service 'manifestService', ($resource) ->
  manifestResource = $resource chrome.extension.getURL 'manifest.json'
  assetsResource = $resource chrome.extension.getURL 'assets/assets.json'

  @getManifest = ->
    manifestResource.get()

  @getAssets = ->
    assetsResource.query()

  @

app.run (_) ->
  db = _.load()

  if not db
    db =
      syntaxHighlight: []

    _.insert db.syntaxHighlight,
        id: 'markdown'
        highlight: true
        style:
          id: 'sunburst'
          name: 'Sunburst'
    _.save db


app.controller 'appController', (
    $rootScope,
    $scope,
    $location,
    $http,
    $timeout,
    $document,
    $window
    $modal,
    _,
    manifestService,
    markdown,
  ) ->
    db = _.load()
    style = _.get db.syntaxHighlight, 'markdown'

    $scope.syntaxHighlight = style

    $scope.manifest = manifestService.getManifest()
    $scope.timeout = 333

    converter = new $window.Markdown.Converter
    $window.Markdown.Extra.init converter,
      blockRenderer: (new SyntaxHighlighter.highlightjs).render
      extensions: [
        'fenced_code_gfm'
        'tables'
        'def_list'
        'attr_list'
        'footnotes'
        'smartypants'
        # 'newlines'
        'strikethrough'
      ]

    isLocalFile = false
    isLocalFile = /^file:\/\//i.test url

    # This will be triggered when the tab's visibility changes.
    $document.on 'visibilitychange', (event) ->
      $scope.timeout = if event.target.hidden then 6667 else 333
      if not event.target.hidden
        $scope.$emit 'document', dirty: false

    $document.on 'scroll', ->
      console.log "Document scrolled to #{$document.scrollLeft()} #{$document.scrollTop()}"

    $rootScope.$on 'duScrollspy:becameActive', ($event, $element) ->
      console.dir $element

    $scope.$on 'document', (event, message)->
      if message.dirty
        int = new markdown syntaxHighlight: true, message.text, {}, converter
        $scope.body = int.getHtml()
        $scope.title = int.getTitle()
        $scope.meta = int.getMeta()
        $scope.outline = int.getOutline()

      if isLocalFile
        $timeout ->
          $http method: 'GET', url: "#{url}?rnd='#{new Date().getTime()}"
              .success (data, status, headers, config) ->
                data = data
                    .replace /(href|src)="\/([^"]*)"/g,
                             "$1=\"#{chrome.extension.getURL '$2'}\""
                $scope.$emit 'document', text: data, dirty: data isnt message.text
              .error (data, status, headers, config) ->
                null
        , $scope.timeout

    $scope.$emit 'document', text: text, dirty: true


    # ### openAbout: Open About Modal
    $scope.openAbout = ->

      # Open the About modal
      modalInstance = $modal.open
        templateUrl: chrome.extension.getURL 'assets/templates/about.tpl.html'
        controller: 'aboutController'

    # ### openAbout: Open Options Modal
    $scope.openOptions = ->

      # Open the Options modal
      modalInstance = $modal.open
        templateUrl: chrome.extension.getURL 'assets/templates/options.tpl.html'
        controller: 'optionsController'

      modalInstance.result.then (db) ->
        console.dir db
        $scope.syntaxHighlight = _.get db.syntaxHighlight, 'markdown'


# ## app.aboutController
#
# *app.navbarController* provides data and handlers for the About modal
# dialog.
app.controller 'aboutController',
  ($scope, $modalInstance, manifestService) ->

    # The About modal needs information about the app, so load the application
    # manifest, and component information.
    $scope.manifest = manifestService.getManifest()
    $scope.assets = manifestService.getAssets()

    $scope.close = (result) ->
      $modalInstance.close result


# ## app.optionsController
#
# *app.optionsController* provides data and handlers for the Options modal
# dialog.
app.controller 'optionsController', ($scope, $modalInstance, _) ->
  db = _.load()
  style = _.get db.syntaxHighlight, 'markdown'

  $scope.syntaxHighlight = style

  $scope.syntaxHighlightStyle = {}
  $scope.syntaxHighlightStyles = SyntaxHighlighter.highlightjs.getStyles()

  $scope.close = (result) ->
    $modalInstance.close result

  $scope.save = (style) ->
    _.save db
    $modalInstance.close db

# ------------------------------------------------------------------------------

# # Filters

# ## trustAsHtml Filter
# Convert the content into trusted HTML, to then be rendered with the
# `ng-bind-html` attribute.
#
# Example:
#
# ```html
#
# <div ng-bind-html="content | trustAsHtml"></div>
#
# ```
app.filter 'trustAsHtml',
  ($sce) ->
    (content) ->
      $sce.trustAsHtml content

# ## Markdown Filter
# Create a new sanitising *Markdown* filter called *`markdown`*.
# The filter is based on the *[Marked]* Markdown parser and compiler module.
#
# [Marked]: https://github.com/chjj/marked
app.filter 'markdown',
  ($sce) ->
    (data) ->
      # Leave early if the data isn't a string
      return if typeof data isnt 'string'

      # Return the converted text, after informing the *Strict Contextual
      # Escaping* service the Html is trusted and is safe to be displayed via
      # the *ng-bind-html* directive.
      converter = new Markdown.Converter
      Markdown.Extra.init converter,
          extensions: [
            'fenced_code_gfm'
            'tables'
            'def_list'
            'attr_list'
            'footnotes'
            'smartypants'
            # 'newlines'
            'strikethrough'
          ]
      $sce.trustAsHtml converter.makeHtml data

# ------------------------------------------------------------------------------

# # Bootstrapping

injector = angular.injector ['ng']
$http = injector.get '$http'

$http method: 'GET', url: chrome.extension.getURL('assets/application.html')
    .success (data, status, headers, config) ->
      text = document.documentElement.textContent
      document.open 'text/html', 'replace'
      document.write data.replace /(href|src)="\/([^"]*)"/g,
          "$1=\"#{chrome.extension.getURL '$2'}\""
      document.close()

      # Copied from async version
      # syntaxHighlightLink = new StylesheetLink angular.element('#syntax-highlight-link')
      # syntaxHighlightLink.setStyle(self.options.syntaxHighlightStyle) if self.options.syntaxHighlight?

      angular.bootstrap document, ['app']

    .error (data, status, headers, config) ->
