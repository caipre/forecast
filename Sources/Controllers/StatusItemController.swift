//
// Forecast
//
//


import Cocoa

class StatusItemController : NSViewController {
    
    @IBOutlet weak var _popover: NSPopover!

    var statusitem: NSStatusItem!
    
    override func awakeFromNib() {
        weather.publink.subscribe { (model) in self.render() }
        
        statusitem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
        statusitem.button?.title = " — "
        statusitem.button?.target = self
        statusitem.button?.action = #selector(StatusItemController.toggle)
    }
    
    func render() {
        if let val = weather.temperature(for: weather.current, property: .realfeel) {
            statusitem.button?.title = "\(val) \(weather.unitsystem.symbol)"
        } else {
            statusitem.button?.title = " — "
        }
    }
    
    func toggle(sender: AnyObject!) {
        assert(sender is NSStatusBarButton)
        if _popover.isShown {
            _popover.performClose(sender)
        } else {
            guard let button = sender as? NSStatusBarButton else { return }
            _popover.show(relativeTo: button.frame, of: button, preferredEdge: .minY)
            location.startUpdating()
        }
    }
    
}
