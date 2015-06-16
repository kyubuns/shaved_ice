setup = ->
  preferences.rulerUnits = Units.PIXELS

  if app.documents.length == 0
    alert('cannot access document')
    return false

  return true

convertToSmartObject = (root) ->
  for layer in root.artLayers
    continue if layer.kind == LayerKind.TEXT
    layer.allLocked = false
    app.activeDocument.activeLayer = layer
    executeAction(app.stringIDToTypeID('newPlacedLayer'), new ActionDescriptor(), DialogModes.NO)
  for layerSet in root.layerSets
    convertToSmartObject(layerSet)

main = ->
  copiedDoc = app.activeDocument.duplicate(activeDocument.name[..-5] + '.converted.psd')
  convertToSmartObject(copiedDoc)

if setup()
  main()
