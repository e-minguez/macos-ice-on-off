import Cocoa
import CoreGraphics

func hasExternalMonitor() -> Bool {
    var count: UInt32 = 0
    CGGetActiveDisplayList(0, nil, &count)
    var displays = [CGDirectDisplayID](repeating: 0, count: Int(count))
    CGGetActiveDisplayList(count, &displays, &count)
    return displays.contains { !CGDisplayIsBuiltin($0) }
}

func syncIce() {
    if hasExternalMonitor() {
        let running = NSRunningApplication
            .runningApplications(withBundleIdentifier: "com.jordanbaird.Ice")
        if !running.isEmpty {
            running.forEach { $0.terminate() }
        }
    } else {
        let isRunning = !NSRunningApplication
            .runningApplications(withBundleIdentifier: "com.jordanbaird.Ice")
            .isEmpty
        if !isRunning {
            NSWorkspace.shared.open(URL(fileURLWithPath: "/Applications/Ice.app"))
        }
    }
}

CGDisplayRegisterReconfigurationCallback({ _, _, _ in
    // Wait briefly for the system to settle after a display change
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { syncIce() }
}, nil)

syncIce()          // apply correct state immediately on startup
RunLoop.main.run() // sleep until next display event
