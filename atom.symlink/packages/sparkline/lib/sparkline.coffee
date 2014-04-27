RangeFinder = require './range-finder'
bars = ['▁', '▂', '▃', '▅', '▆', '▇']

module.exports =
  activate: ->
    atom.workspaceView.command 'sparkline:spark', '.editor', ->
      generateSparkline atom.workspaceView.getActivePaneItem()

generateSparkline = (editor) ->
  nums = []
  ranges = RangeFinder.rangesFor editor
  ranges.forEach (range) ->
    line = editor.getTextInBufferRange range
    lineNums = line.replace(/\s/g, '').split(',')
    nums = nums.concat lineNums

  min = Math.min.apply(Math, nums)
  max = (Math.max.apply(Math, nums) - min) / (bars.length - 1)
  if isNaN min or isNaN max then return

  results = []
  push = (num) ->
    if not isNaN num then results.push bars[parseInt((num - min) / max)]

  push i for i in nums when i isnt ''
  editor.setTextInBufferRange ranges[ranges.length - 1], results.join ''
