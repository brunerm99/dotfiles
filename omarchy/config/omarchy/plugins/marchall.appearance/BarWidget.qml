import QtQuick
import Quickshell
import Quickshell.Io
import qs.Ui

// One-click switch between the Workbench light and dark themes. Omarchy's
// theme pipeline fans this out to the shell, terminals, editors, browsers,
// GTK, and supported command-line apps.
BarWidget {
  id: root
  moduleName: "marchall.appearance"

  readonly property string themeNamePath: Quickshell.env("HOME") + "/.local/state/omarchy/current/theme.name"
  property string currentTheme: ""
  readonly property bool lightMode: currentTheme === "workbench-light"
  readonly property string targetTheme: lightMode ? "workbench-dark" : "workbench-light"
  readonly property string targetLabel: lightMode ? "Workbench Dark" : "Workbench Light"

  function toggleTheme() {
    if (themeProcess.running) return
    // The Workbench palettes intentionally ship without wallpapers. Keep the
    // user's current background instead of asking Omarchy to find one here.
    themeProcess.command = ["env", "OMARCHY_THEME_SKIP_BACKGROUND=1", "omarchy", "theme", "set", targetTheme]
    themeProcess.running = true
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  FileView {
    id: themeNameFile
    path: root.themeNamePath
    watchChanges: true
    printErrors: false
    onLoaded: root.currentTheme = String(text() || "").trim()
    onFileChanged: reload()
  }

  Process {
    id: themeProcess
    onExited: themeNameFile.reload()
  }

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.lightMode ? "☾" : "☀"
    dimmed: themeProcess.running
    interactive: !themeProcess.running
    tooltipText: themeProcess.running ? "Switching Workbench theme…" : "Switch to " + root.targetLabel
    onPressed: function(button) {
      if (button === Qt.LeftButton) root.toggleTheme()
    }
  }
}
