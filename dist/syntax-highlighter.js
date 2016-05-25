// Generated by CoffeeScript 1.10.0
(function() {
  var SyntaxHighlighter, unescape,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  unescape = function(value) {
    return value.replace(/&amp;/gm, '&').replace(/&lt;/gm, '<').replace(/&gt;/gm, '>');
  };

  SyntaxHighlighter = (typeof exports !== "undefined" && exports !== null) && exports || (this.SyntaxHighlighter = {});

  SyntaxHighlighter.highlightjs = (function() {
    highlightjs._styles = [
      {
        name: 'Arta',
        id: 'arta'
      }, {
        name: 'Ascetic',
        id: 'ascetic'
      }, {
        name: 'Brown Paper',
        id: 'brown_paper'
      }, {
        name: 'Dark',
        id: 'dark'
      }, {
        name: 'Default',
        id: 'default'
      }, {
        name: 'Far',
        id: 'far'
      }, {
        name: 'GitHub',
        id: 'github'
      }, {
        name: 'GoogleCode',
        id: 'googlecode'
      }, {
        name: 'Idea',
        id: 'idea'
      }, {
        name: 'IR Black',
        id: 'ir_black'
      }, {
        name: 'Magula',
        id: 'magula'
      }, {
        name: 'Monokai',
        id: 'monokai'
      }, {
        name: 'Pojoaque',
        id: 'pojoaque'
      }, {
        name: 'Rainbow',
        id: 'rainbow'
      }, {
        name: 'School Book',
        id: 'school_book'
      }, {
        name: 'Solarized Dark',
        id: 'solarized_dark'
      }, {
        name: 'Solarized Light',
        id: 'solarized_light'
      }, {
        name: 'Sunburst',
        id: 'sunburst'
      }, {
        name: 'Tomorrow',
        id: 'tomorrow'
      }, {
        name: 'Tomorrow-Night-Blue',
        id: 'tomorrow-night-blue'
      }, {
        name: 'Tomorrow-Night-Bright',
        id: 'tomorrow-night-bright'
      }, {
        name: 'Tomorrow-Night',
        id: 'tomorrow-night'
      }, {
        name: 'Tomorrow-Night-Eighties',
        id: 'tomorrow-night-eighties'
      }, {
        name: 'VS',
        id: 'vs'
      }, {
        name: 'Xcode',
        id: 'xcode'
      }, {
        name: 'Zenburn',
        id: 'zenburn'
      }
    ];

    highlightjs.getStyles = function() {
      return highlightjs._styles;
    };

    function highlightjs(aliases) {
      this.aliases = aliases;
      this.render = bind(this.render, this);
      this.highlight = bind(this.highlight, this);
      if (!this.aliases) {
        this.aliases = {
          brainfuck: "\\b(bf)$",
          cpp: "\\b(c|h|cpp|hpp)$",
          coffeescript: "\\b(coffee)$",
          handlebars: "\\b(hb)$",
          markdown: "\\b(md|mdown|mkd|mkdn|mdtext|mdtxt|txt|text|README)$",
          perl: "\\b(pl)$",
          python: "\\b(py)$",
          ruby: "\\b(rb)$",
          lisp: "\\b(scm|sl|scheme)$",
          bash: "\\b(sh|shell|ksh|tsh|csh|vb)$"
        };
      }
    }

    highlightjs.prototype.highlight = function(text, language, continuation) {
      var e, error, ref, regexp, syntax;
      if (language == null) {
        language = '';
      }
      if (language) {
        ref = this.aliases;
        for (syntax in ref) {
          regexp = ref[syntax];
          if (RegExp(regexp).test(language)) {
            language = syntax;
            break;
          }
        }
        try {
          return hljs.highlight(language, text, true, continuation);
        } catch (error) {
          e = error;
          console.log(e);
          return hljs.highlightAuto(text);
        }
      } else {
        return hljs.highlightAuto(text);
      }
    };

    highlightjs.prototype.render = function(text, language, continuation) {
      var hl;
      if (language == null) {
        language = '';
      }
      hl = this.highlight(text, language, continuation);
      return "<pre class=\"hljs\"><code class=\"language-" + hl.language + "\">" + (hl.value.replace(/&amp;/g, '&')) + "</code></pre>";
    };

    return highlightjs;

  })();

}).call(this);
