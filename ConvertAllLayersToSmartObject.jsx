// Generated by CoffeeScript 1.9.1
(function() {
  var convertToSmartObject, main, setup;

  setup = function() {
    preferences.rulerUnits = Units.PIXELS;
    if (app.documents.length === 0) {
      alert('cannot access document');
      return false;
    }
    return true;
  };

  convertToSmartObject = function(root) {
    var i, j, layer, layerSet, len, len1, ref, ref1, results;
    ref = root.artLayers;
    for (i = 0, len = ref.length; i < len; i++) {
      layer = ref[i];
      if (layer.kind === LayerKind.TEXT || !layer.visible) {
        continue;
      }
      layer.allLocked = false;
      app.activeDocument.activeLayer = layer;
      executeAction(app.stringIDToTypeID('newPlacedLayer'), new ActionDescriptor(), DialogModes.NO);
    }
    ref1 = root.layerSets;
    results = [];
    for (j = 0, len1 = ref1.length; j < len1; j++) {
      layerSet = ref1[j];
      if (layerSet.visible) {
        results.push(convertToSmartObject(layerSet));
      } else {
        results.push(void 0);
      }
    }
    return results;
  };

  main = function() {
    var copiedDoc;
    copiedDoc = app.activeDocument.duplicate(activeDocument.name.slice(0, -4) + '.converted.psd');
    return convertToSmartObject(copiedDoc);
  };

  if (setup()) {
    main();
  }

}).call(this);
