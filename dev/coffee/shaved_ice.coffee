String::startsWith ?= (s) -> @[...s.length] is s
String::endsWith   ?= (s) -> s is '' or @[-s.length..] is s

setup = ->
  preferences.rulerUnits = Units.PIXELS

  if app.documents.length == 0
    alert('cannot access document')
    return false

  return true


deleteEmptyLayers = (root) ->
  deleteLayers = []
  for layer in root.artLayers
    if !layer.visible || layer.name.startsWith('#')
      deleteLayers.push layer

  for layer in deleteLayers
    layer.remove()


deleteEmptyLayerSets = (root) ->
  deleteLayerSets = []
  for layerSet in root.layerSets
    if !layerSet.visible || layerSet.name.startsWith('#')
      deleteLayerSets.push layerSet

  for layer in deleteLayerSets
    layer.remove()


convertToSmartObject = (layer) ->
  layer.allLocked = false
  app.activeDocument.activeLayer = layer
  executeAction(app.stringIDToTypeID('newPlacedLayer'), new ActionDescriptor(), DialogModes.NO)


rasterize = (root) ->
  deleteEmptyLayers(root)
  deleteEmptyLayerSets(root)

  for layer in root.artLayers
    continue if layer.kind != LayerKind.TEXT
    text = layer.textItem
    fontSize = text.size
    before_bounds = layer.bounds
    text.verticalScale = 100.0
    text.horizontalScale = 100.0
    text.size = fontSize
    after_bounds = layer.bounds
    w_scale = (before_bounds[2] - before_bounds[0]) / (after_bounds[2] - after_bounds[0])
    h_scale = (before_bounds[3] - before_bounds[1]) / (after_bounds[3] - after_bounds[1])
    layer.resize(w_scale * 100, h_scale * 100)

    after_bounds = layer.bounds
    layer.translate(before_bounds[0] - after_bounds[0], before_bounds[1] - after_bounds[1])

  for layer in root.artLayers
    continue if layer.kind == LayerKind.TEXT
    convertToSmartObject(layer)

  for layer in root.artLayers
    continue if layer.kind == LayerKind.TEXT
    layer.rasterize(RasterizeType.ENTIRELAYER)

  for layerSet in root.layerSets
    rasterize(layerSet)


main = ->
  docName = activeDocument.name[..-5] + '.converted.psd'
  docName = docName.replace(/original.converted.psd/g, "psd")
  docPath = app.activeDocument.path
  copiedDoc = app.activeDocument.duplicate(docName)
  rasterize(copiedDoc)
  copiedDoc.saveAs(File(docPath + '/' + docName))

if setup()
  main()
