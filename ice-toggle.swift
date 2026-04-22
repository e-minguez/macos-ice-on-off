import Cocoa

func hasExternalMonitor() -> Bool {
    var count: UInt32 = 0
    CGGetActiveDisplayList(0, nil, &count)
    var displays = [CGDirectDisplayID](repeating: 0, count: Int(count))
    CGGetActiveDisplayList(count, &displays, &count)
    return displays.contains { CGDisplayIsBuiltin($0) == 0 }
}

@discardableResult
func shell(_ args: String...) -> Int32 {
    let task = Process()
    task.executableURL = URL(fileURLWithPath: args[0])
    task.arguments = Array(args.dropFirst())
    task.standardOutput = FileHandle.nullDevice
    task.standardError = FileHandle.nullDevice
    try? task.run()
    task.waitUntilExit()
    return task.terminationStatus
}

func iceIsRunning() -> Bool {
    shell("/usr/bin/pgrep", "-x", "Ice") == 0
}

func syncIce() {
    if hasExternalMonitor() {
        if iceIsRunning() {
            shell("/usr/bin/osascript", "-e", "tell application \"Ice\" to quit")
        }
    } else {
        if !iceIsRunning() {
            shell("/usr/bin/open", "-a", "Ice")
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NotificationCenter.default.addObserver(
            forName: NSApplication.didChangeScreenParametersNotification,
            object: nil,
            queue: .main
        ) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { syncIce() }
        }
        syncIce()
    }
}

let app = NSApplication.shared
app.setActivationPolicy(.prohibited)
let delegate = AppDelegate()
app.delegate = delegate
app.run()
