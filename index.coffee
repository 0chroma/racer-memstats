sizeof = require 'object-sizeof'
_ = require 'lodash'

Model = {
  getFieldSizes: (model) ->
    Model._mapCollections(model, (collection) ->
      Collection.getFieldSizes collection
    ).reduce FieldSizes.merge, {}

  getCollectionSizes: (model) ->
    _.zipObject Model._mapCollections model, (collection, name) ->
      [name, Collection.getSize(collection)]

  getDocumentSizes: (model) ->
   _.merge.apply null, Model._mapCollections model, Collection.getDocumentSizes

  getSize: (model) ->
    _.sum _.values Model.getCollectionSizes(model)
  
  _mapCollections: (model, fn) ->
    Model._getCollectionList(model).map (collectionName) -> fn model.get(collectionName), collectionName

  _getCollectionList: (model) ->
    collections = Object.keys model.collections
    isChar = /[a-zA-Z]/
    _.filter collections, (collection) ->
      c = collection.charAt(0)
      isChar.test(c)
}

Collection = {
  getDocumentSizes: (collection) ->
    _.mapValues collection, Document.getSize
  getFieldSizes: (collection) ->
    docs = _.values(collection) #get array of docs
    docs.map(Document.getFieldSizes).reduce FieldSizes.merge, {} #map to field sizes, and reduce them to one obj
  getSize: (collection) ->
    docSizes = Collection.getDocumentSizes(collection) #get docSizes as {id: size}
    _.sum _.values docSizes #sum the values of docSizes
}

Document = {
  getSize: (doc) ->
    sizes = Document.getFieldSizes(doc)
    _.sum _.values sizes
  getFieldSizes: (doc) ->
    fieldSizes = _.pairs(doc).map (val) -> [val[0], FieldValue.getSize(val)]
    _.zipObject fieldSizes
}

FieldSizes = {
  merge: (fieldSizesA, fieldSizesB) ->
    _.merge fieldSizesA, fieldSizesB, (a, b) ->
      (a || 0) + (b || 0)
}

FieldValue = {
  #FieldValue is a tuple in the form of [field, value]
  getSize: (fieldvalue) ->
    # the field string itself probably shouldn't be taken into account
    # since v8 should optimize for that case. Gzip compression on the
    # server end would also likely mitigate the impact when sending it
    # through the network.
    #TODO: ask nate if share documents have the class optimization applied to them
    sizeof fieldvalue[1]
}

module.exports = window.racerMemStats = {Model, Collection, Document, _, sizeof}
