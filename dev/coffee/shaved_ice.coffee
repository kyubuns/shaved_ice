setup = ->
  preferences.rulerUnits = Units.PIXELS

  if app.documents.length == 0
    alert('cannot access document')
    return false

  return true

rasterize = (root) ->
  for layer in root.artLayers
    continue if layer.kind == LayerKind.TEXT || !layer.visible
    layer.allLocked = false
    app.activeDocument.activeLayer = layer
    executeAction(app.stringIDToTypeID('newPlacedLayer'), new ActionDescriptor(), DialogModes.NO)

  for layer in root.artLayers
    continue if layer.kind == LayerKind.TEXT || !layer.visible
    layer.rasterize(RasterizeType.ENTIRELAYER)

  for layerSet in root.layerSets
    rasterize(layerSet) if layerSet.visible


main = ->
  docName = activeDocument.name[..-5] + '.converted.psd'
  docName = docName.replace(/original.converted.psd/g, "psd")
  docPath = app.activeDocument.path
  copiedDoc = app.activeDocument.duplicate(docName)
  rasterize(copiedDoc)
  copiedDoc.saveAs(File(docPath + '/' + docName))

if setup()
  main()
