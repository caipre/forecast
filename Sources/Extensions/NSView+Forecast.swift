//
//  Forecast
//
//

import Cocoa

extension NSView {

    var backgroundColor: NSColor? {
        get {
            guard let backgroundColor = self.layer?.backgroundColor else { return nil }
            return NSColor(cgColor: backgroundColor)
        }

        set {
            guard let color = newValue else {
                self.layer?.backgroundColor = NSColor.clear.cgColor
                return
            }

            self.wantsLayer = true
            self.layer?.backgroundColor = color.cgColor
        }
    }

    convenience init(backgroundColor: NSColor) {
        self.init()
        self.backgroundColor = backgroundColor
    }
}
