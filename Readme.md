Racer Memstats
==============

Easy memory statistics for racer stores. Mostly to be used as a rough basis for what parts to optimize for, since different JS implementations optimize memory usage for different cases so the number isn't the source of truth for how much memory may be in use.

Usage
-----

 - Make the browser.js file with `make`
 - Require racer-memstats in the page (not recommended to be used in prod)
 - Call `racerPerfStats(model)` (where `model` is a reference to your model)
   - `racerPerfStats(model)` will give you memory breakdown by collection
   - `racerPerfStats(model, {field: 'fieldName'})` will give you memory breakdown by collection for a given field
   - `racerPerfStats(model, {collection: 'collectionName'})` will give you memory breakdown by field for a given collection
