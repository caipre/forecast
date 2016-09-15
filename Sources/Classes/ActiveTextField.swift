//
// Forecast
//
//

import Cocoa

@IBDesignable
class ActiveTextField : NSTextField {
    override func mouseUp(with event: NSEvent) {
        guard target != nil else { return }
        guard action != nil else { return }
        target!.performSelector(onMainThread: action!, with: nil, waitUntilDone: true)
    }
}
