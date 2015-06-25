// Generated by CoffeeScript 1.9.1
(function() {
  var base, base1, main, rasterize, setup;

  if ((base = String.prototype).startsWith == null) {
    base.startsWith = function(s) {
      return this.slice(0, s.length) === s;
    };
  }

  if ((base1 = String.prototype).endsWith == null) {
    base1.endsWith = function(s) {
      return s === '' || this.slice(-s.length) === s;
    };
  }

  setup = function() {
    preferences.rulerUnits = Units.PIXELS;
    if (app.documents.length === 0) {
      alert('cannot access document');
      return false;
    }
    return true;
  };

  rasterize = function(root) {
    var deleteLayerSets, deleteLayers, i, j, k, l, layer, layerSet, len, len1, len2, len3, len4, len5, len6, m, n, o, ref, ref1, ref2, ref3, ref4, results;
    deleteLayers = [];
    ref = root.artLayers;
    for (i = 0, len = ref.length; i < len; i++) {
      layer = ref[i];
      if (!layer.visible || layer.name.startsWith('#')) {
        deleteLayers.push(layer);
      }
    }
    for (j = 0, len1 = deleteLayers.length; j < len1; j++) {
      layer = deleteLayers[j];
      layer.remove();
    }
    deleteLayerSets = [];
    ref1 = root.layerSets;
    for (k = 0, len2 = ref1.length; k < len2; k++) {
      layerSet = ref1[k];
      if (!layerSet.visible || layerSet.name.startsWith('#')) {
        deleteLayerSets.push(layerSet);
      }
    }
    for (l = 0, len3 = deleteLayerSets.length; l < len3; l++) {
      layer = deleteLayerSets[l];
      layer.remove();
    }
    ref2 = root.artLayers;
    for (m = 0, len4 = ref2.length; m < len4; m++) {
      layer = ref2[m];
      if (layer.kind === LayerKind.TEXT) {
        continue;
      }
      layer.allLocked = false;
      app.activeDocument.activeLayer = layer;
      executeAction(app.stringIDToTypeID('newPlacedLayer'), new ActionDescriptor(), DialogModes.NO);
    }
    ref3 = root.artLayers;
    for (n = 0, len5 = ref3.length; n < len5; n++) {
      layer = ref3[n];
      if (layer.kind === LayerKind.TEXT) {
        continue;
      }
      layer.rasterize(RasterizeType.ENTIRELAYER);
    }
    ref4 = root.layerSets;
    results = [];
    for (o = 0, len6 = ref4.length; o < len6; o++) {
      layerSet = ref4[o];
      results.push(rasterize(layerSet));
    }
    return results;
  };

  main = function() {
    var copiedDoc, docName, docPath;
    docName = activeDocument.name.slice(0, -4) + '.converted.psd';
    docName = docName.replace(/original.converted.psd/g, "psd");
    docPath = app.activeDocument.path;
    copiedDoc = app.activeDocument.duplicate(docName);
    rasterize(copiedDoc);
    return copiedDoc.saveAs(File(docPath + '/' + docName));
  };

  if (setup()) {
    main();
  }

}).call(this);
