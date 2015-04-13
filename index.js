var sizeof = require('object-sizeof');
var _ = require('lodash');

var memStats;

(function(){
  /*
   * Measure memory breakdown of a model with this function
   * options:
   *   - options.collection: specify this to measure how much memory each field in a given collection uses
   *   - options.field: specify this to measure how much memory a given field uses across all collections
   *   - if you specify neither, you'll get a breakdown of memory usage by collection
   */
  memStats = function(model, options){
    var collections = filterCollectionList(Object.keys(model.get()));

    if(options && options.collection){
      var collection = model.get(options.collection);
      console.log(breakdownByField(collection));
    }else if(options && options.field){
      console.log(breakdownByField(model, options.field, collections));
    }else{
      console.log(breakdownByCollection(model, collections));
    }
  }

  function breakdownByField(collection){
    var fieldTotals = {}
    _.values(collection).forEach(function(doc){
      Object.keys(doc).forEach(function(key){
        if(!fieldTotals[key])
          fieldTotals[key] = 0;
        // the field string itself probably shouldn't be taken into account
        // since v8 should optimize for that case. Gzip compression on the
        // server end would also likely mitigate the impact when sending it
        // through the network.
        //TODO: ask nate if share documents have the class optimization applied to them
        fieldTotals[key] = sizeof(doc[key]);
      });
    });
    return fieldTotals;
  }

  function breakdownByField(model, field, collections){
    var finalBreakdown = {};
    collections.forEach(function(collection){
      var breakdown = breakdownByField(model.get(collection));
      var total = breakdown[field] || 0;
      finalBreakdown[collection] = total;
    });
    return finalBreakdown;
  }

  function breakdownByCollection(model, collections){
    var finalBreakdown = {};
    collections.forEach(function(collection){
      var breakdown = breakdownByField(model.get(collection));
      var total = _.values(breakdown).reduce(function(a, b){ return a + b; }, 0);
      finalBreakdown[collection] = total;
    });
    return finalBreakdown;
  }

  function filterCollectionList(collections){
    var isChar = /[a-zA-Z]/
    return _.filter(collections, function(collection){
      var c = collection.charAt(0);
      return isChar.test(c);
    });
  }

})();

module.exports = window.racerMemStats = memStats;
