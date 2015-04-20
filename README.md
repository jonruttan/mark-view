Title:    MarkView  
Keywords: [ #MarkView, #ChromeApp, #Markdown, #SyntaxHighlight ]  
Author:   "[Jon Ruttan](jonruttan@gmail.com)"  
Date:     2013-09-28  
Revision: 4 (2015-04-17)  
License:  "[GPL-3.0](http://www.gnu.org/licenses/gpl-3.0-standalone.html)"  

# MarkView

**MarkView** is a [Markup Language] viewing extension which renders [Markdown] files on [Google Chrome] and [Chromium] based browsers. MarkView *watches* local files for updates and redisplays the content when the file's contents have changed.

[Markup Language]: http://en.wikipedia.org/wiki/Markup_language
[Markdown]: http://daringfireball.net/projects/markdown/
[Google]: http://www.google.com
[Google Chrome]: https://www.google.com/intl/en/chrome/browser/
[Chromium]: http://www.chromium.org/Home

## Features:

  1. Preview [Markdown] files.
  2. Auto reload local file when file change is detected.
  3. Code fence syntax highlighting.
  4. Automatic *Table of Contents*.

## Compile

```bash
coffee --watch --compile --output dist src/*
```

## Install

  1. Download the MarkView files from [GitHub](https://github.com/jonruttan/mark-view).
  2. Install the dependencies:
    - `cd mark-view`
    - `bower install`
  3. Install the plugin (as a developer):
    1. Select *Tools ▸ Extensions*, or use the following link to open Chrome's [Extensions pane](chrome://extensions/).
    2. Check the box beside *`Developer mode`* on the *Extensions* pane.
    3. Press the *`Load unpacked extension...`* button, and select the directory the MarkView files are in.
  4. Open Chrome's [Extensions pane](chrome://extensions/), and ensure the *`Allow access to file URLs`* checkbox is enabled.
  5. Open or drag a `markdown` file to Chrome.

## Resources

  - <https://developer.chrome.com/apps/angular_framework>
  - <https://developer.chrome.com/extensions/content_scripts>
  - [Bower](http://bower.io/)

### Code

  - [pagedown](https://github.com/jonruttan/pagedown)
    - [pagedown](https://code.google.com/p/pagedown/)
  - [pagedown-extra](https://github.com/jmcmanus/pagedown-extra)
  - [highlight.js](http://softwaremaniacs.org/soft/highlight/en/)
  - [prettify](http://code.google.com/p/google-code-prettify/)
  - [GitHub](https://github.com/)

### Images

- [The Markdown Mark](http://dcurt.is/the-markdown-mark)

## History

MarkView is based on [MarkdownReader](https://chrome.google.com/webstore/detail/markdown-reader/gpoigdifkoadgajcincpilkjmejcaanc) by [Yanis Wang](yanis.wang@gmail.com).

## License

MarkView is released under the [GPL-3.0](http://www.gnu.org/licenses/gpl-3.0-standalone.html) license. See LICENSE.md.
