{WorkspaceView} = require 'atom'

describe "sorting lines", ->
  [activationPromise, editor, editorView] = []

  sortLines = (callback) ->
    editorView.trigger "sparkline:spark"
    waitsForPromise -> activationPromise
    runs(callback)

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    atom.workspaceView.openSync()

    editorView = atom.workspaceView.getActiveView()
    editor = editorView.getEditor()

    activationPromise = atom.packages.activatePackage('sparkline')

  describe "when no lines are selected", ->
    it "sparks all lines in file", ->
      editor.setText """
      1,
      2,
      3
      """
      editor.setCursorBufferPosition([0, 0])

      sortLines ->
        expect(editor.getText()).toBe "▁▃▇"

  describe "when a line is selected", ->
    it "sorts the selected lines", ->
      editor.setText """
        1,2,3
        dummy data
      """
      editor.setSelectedBufferRange([[0,0], [0, 5]])

      sortLines ->
        expect(editor.getText()).toBe """
          ▁▃▇
          dummy data
        """
