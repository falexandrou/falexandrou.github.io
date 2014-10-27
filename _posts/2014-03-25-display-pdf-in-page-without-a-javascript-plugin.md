---
layout: post
title: Display PDF in-page without a javascript plugin
header-img: "img/home-bg.jpg"
---


There are cases where a PDF file is more than a download link and you need to display it inline inside your page. Recently I’ve stumbled upon a conversation where somebody was looking for a good jQuery plugin that displays PDF files. One of the suggestions was the amazing pdf.js which is developed by the Mozilla foundation and it’s pretty much a full blown PDF viewer in your browser.

If you need a really lightweight solution and you don’t mind if the users with browsers that don’t support PDF viewing, don’t view the document, here’s a snippet you may use

```javascript
/**
 * When browser supports inline pdfs
 * There is no need to append a large jquery plugin that displays them inline.
 *
 * You can actually use an iframe (and style it appropriately)
 * or a link whenever inline PDF viewing is not supported
 *
 * This function is fairly simple and it's only for demo purposes
 */
function appendPdf(id, url) {
    var $el = $('#'+id);
    // Check whether the browser supports displaying pdf files inline (ie. without downloading them)
    if (navigator && navigator.mimeTypes && navigator.mimeTypes['application/pdf']) {
        // You may add extra attributes (eg. to allow transparency) or style the iframe
        $el.html('<iframe src="'+url+'"></iframe>');
    } else {
        $el.html('<a href="'+url+'">Download file</a>');
    }
 }

 ```

What we do here is check if the browser has a plugin for a certain mime type (the check

```javascript
navigator.mimeTypes['application/pdf']
```

will return undefined if the browser doesn’t have a plugin for that mime type). If the browser does support PDF, we append a simple iframe that can be styled and sized accordingly, or append a link to download the file if the browser doesn’t have a handler for PDFs.

As you can see, it’s a fairly simple solution and significantly lighter than any javascript component.
