import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Io
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "omarchy.workspaces"

  function workspaceById(id) {
    var values = Hyprland.workspaces.values
    for (var i = 0; i < values.length; i++) {
      if (values[i].id === id) return values[i]
    }

    return null
  }

  function workspaceIds() {
    var ids = []
    var values = Hyprland.workspaces.values

    for (var i = 0; i < values.length; i++) {
      var id = values[i].id
      var focused = Hyprland.focusedWorkspace !== null && Hyprland.focusedWorkspace.id === id
      if (id > 0 && (values[i].toplevels.values.length > 0 || focused) && ids.indexOf(id) === -1) ids.push(id)
    }

    ids.sort(function(left, right) { return left - right })
    return ids
  }

  function focusWorkspace(id) {
    if (!root.bar) return
    root.bar.run("hyprctl dispatch " + Util.shellQuote("hl.dsp.focus({ workspace = \"" + id + "\" })"))
  }

  function cycleStack(message) {
    if (!root.bar || !root.stacked) return
    root.bar.run("hyprctl dispatch " + Util.shellQuote("hl.dsp.layout(\"" + message + "\")"))
  }

  function refreshStackState() {
    if (stackStateProcess.running) {
      stackRefreshPending = true
      return
    }

    stackRefreshPending = false
    stackStateProcess.running = true
  }

  property bool stacked: false
  property bool stackRefreshPending: false
  readonly property real trailingGap: root.vertical ? 0 : Style.spaceReal(1.5)

  implicitWidth: grid.implicitWidth + trailingGap
  implicitHeight: grid.implicitHeight

  Component.onCompleted: stackRefreshTimer.start()

  Timer {
    id: stackRefreshTimer
    interval: 75
    repeat: false
    onTriggered: root.refreshStackState()
  }

  Process {
    id: stackStateProcess
    command: ["hyprctl", "-j", "activeworkspace"]
    onRunningChanged: {
      if (!running && root.stackRefreshPending) Qt.callLater(root.refreshStackState)
    }
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        try {
          var state = JSON.parse(text || "{}")
          root.stacked = String(state.tiledLayout || "") === "monocle"
        } catch (e) {}
      }
    }
  }

  Connections {
    target: Hyprland
    function onFocusedWorkspaceChanged() { stackRefreshTimer.restart() }
    function onRawEvent(event) {
      if (!event || !event.name) return
      var name = String(event.name)
      if (name === "activewindowv2" || name === "workspacev2"
          || name === "focusedmon" || name === "openwindow"
          || name === "closewindow" || name === "configreloaded") {
        stackRefreshTimer.restart()
      }
    }
  }

  GridLayout {
    id: grid
    anchors.fill: parent
    anchors.rightMargin: root.trailingGap
    columns: root.vertical ? 1 : Math.max(1, root.workspaceIds().length + (root.stacked ? 2 : 0))
    columnSpacing: root.vertical ? 0 : Style.space(1)
    rowSpacing: root.vertical ? Style.space(2) : 0

    Repeater {
      model: root.workspaceIds()

      WidgetButton {
        required property int modelData

        readonly property var workspace: root.workspaceById(modelData)
        readonly property bool occupied: workspace !== null && workspace.toplevels.values.length > 0
        readonly property bool focused: Hyprland.focusedWorkspace !== null && Hyprland.focusedWorkspace.id === modelData

        bar: root.bar
        text: focused ? "\uDB85\uDCFB" : (modelData === 10 ? "0" : String(modelData))
        opacity: occupied || focused ? 1 : 0.5
        horizontalMargin: 6
        verticalPadding: 6
        fixedWidth: root.vertical ? root.barSize : Style.space(20)
        fixedHeight: root.barSize
        onPressed: function() { root.focusWorkspace(modelData) }
      }
    }

    WidgetButton {
      bar: root.bar
      visible: root.stacked
      text: "↑"
      fontSize: Style.font.title
      horizontalMargin: 6
      verticalPadding: 6
      fixedWidth: root.vertical ? root.barSize : Style.space(20)
      fixedHeight: root.barSize
      tooltipText: "Previous stacked window"
      onPressed: function(button) {
        if (button === Qt.LeftButton) root.cycleStack("cycleprev")
      }
    }

    WidgetButton {
      bar: root.bar
      visible: root.stacked
      text: "↓"
      fontSize: Style.font.title
      horizontalMargin: 6
      verticalPadding: 6
      fixedWidth: root.vertical ? root.barSize : Style.space(20)
      fixedHeight: root.barSize
      tooltipText: "Next stacked window"
      onPressed: function(button) {
        if (button === Qt.LeftButton) root.cycleStack("cyclenext")
      }
    }
  }
}
