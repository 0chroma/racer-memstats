Racer Memstats
==============

Easy memory statistics for racer stores. Mostly to be used as a rough basis for what parts to optimize for, since different JS implementations optimize memory usage for different cases so the number isn't the source of truth for how much memory may be in use.

Injecting into the page
-----------------------

```html
<script src="https://hflw.github.io/racer-memstats/browser.js"></script>
```

```javascript
(function(){ var s = document.createElement('script'); s.src='https://hflw.github.io/racer-memstats/browser.js'; document.head.appendChild(s);})();
```

Usage
-----

 - Make the browser.js file with `make`
 - Require racer-memstats in the page (not recommended to be used in prod)
 - `racerms.Model.getCollectionSizes(model)` will give you memory breakdown by collection
 - `racerms.Model.getFieldSizes(model)` will give you memory breakdown by collection for a field (useful for fields common to all documents)
 - `racerms.Model.getDocumentSizes(model)` will give you memory breakdown by document
 - `racerms.Collection.getFieldSizes(model.get('collectionName'))` will give you memory breakdown by field for a given collection
 - `racerms.Collection.getDocumentSizes(model.get('collectionName'))` will give you memory breakdown by document for a given collection
 - `racerms.Format.table(resultsObj)` will format the results in a nice table for you
