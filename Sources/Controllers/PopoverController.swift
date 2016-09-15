//
// Forecast
//
//

import Cocoa

import FlatUIColors
import ForecastIO
import DripIcons

class PopoverController : NSViewController {
    
    @IBOutlet weak var _canvas: NSView!
    @IBOutlet weak var _location: NSTextField!
    @IBOutlet weak var _conditions: NSTextField!
    @IBOutlet weak var _symbol: NSTextField!
    @IBOutlet weak var _temperature: NSTextField!
    @IBOutlet weak var _degree: NSTextField!
    @IBOutlet weak var _forecast: NSStackView!
    
    let formatter = DateFormatter()
    let weatherfont = NSFont.init(name: "dripicons-weather", size: 42)
    
    override func awakeFromNib() {
        weather.publink.subscribe { (model) in self.render() }
        
        formatter.dateFormat = "EEE"
        formatter.timeZone = TimeZone.init(abbreviation: "UTC")
        
        style()
        render()
    }
    
    func render() {
        _location.cell?.title = location.description ?? "Location unknown"
        _conditions.cell?.title = weather.current?.summary ?? ""
        _symbol.cell?.title = weather.current?.icon?.symbol().rawValue ?? DripIcon.moon100.rawValue
        _temperature.cell?.title = weather.temperature(for: weather.current, property: .realfeel) ?? "—"
        
        for (idx, view) in _forecast.subviews.enumerated() {
            fillBlock(view, with: weather.forecast?.data?[idx])
        }
    }
    
    func fillBlock(_ block: NSView, with conditions: DataPoint?) {
        for view in block.subviews {
            guard let view = view as? NSTextField else { continue }
            guard let identifier = view.identifier else { continue }
            
            switch identifier {
            case "day":
                view.cell?.title = conditions == nil ? "---" : formatter.string(from: conditions!.time).uppercased()
            case "symbol":
                view.cell?.title = conditions?.icon?.symbol().rawValue ?? DripIcon.sun.rawValue
                if let symbol = conditions?.icon?.symbol() {
                    switch symbol {
                    case .sun:
                        view.textColor = FlatUI.sunFlower
                    case .moon100:
                        view.textColor = FlatUI.concrete
                    case .clouds, .fog, .cloudsSun, .cloudsMoon:
                        view.textColor = FlatUI.clouds
                    case .rain, .cloudDrizzle:
                        view.textColor = FlatUI.belizeHole
                    case .snow, .wind:
                        view.textColor = FlatUI.concrete
                    default:
                        view.textColor = FlatUI.concrete
                    }
                }
            case "high":
                view.cell?.title = weather.temperature(for: conditions, property: .high) ?? "hi"
            case "low":
                view.cell?.title = weather.temperature(for: conditions, property: .low) ?? "lo"
            default:
                fatalError("invalid identifier in forecast view")
            }
        }
    }
    
    func style() {
        _canvas.backgroundColor = FlatUI.clouds
        _location.textColor = FlatUI.asbestos
        _conditions.textColor = FlatUI.midnightBlue
        
        _symbol.font = weatherfont
        _symbol.textColor = FlatUI.silver
        
        _temperature.textColor = FlatUI.midnightBlue
        _degree.textColor = FlatUI.asbestos
        
        _forecast.backgroundColor = FlatUI.midnightBlue
        for block in _forecast.subviews {
            for view in block.subviews {
                guard let view = view as? NSTextField else { continue }
                guard let identifier = view.identifier else { continue }
                switch identifier {
                    case "day":
                    view.textColor = FlatUI.asbestos
                case "symbol":
                    view.font = weatherfont
                    view.textColor = FlatUI.silver
                case "low":
                    view.textColor = FlatUI.silver
                case "high":
                    view.textColor = FlatUI.clouds
                default:
                    fatalError("invalid identifier in forecast view")
                }
            }
        }
    }

    @IBAction func changeDisplayUnitSystem(sender: AnyObject!) {
        switch weather.unitsystem {
        case UnitTemperature.celsius:
            weather.unitsystem = UnitTemperature.fahrenheit
        case UnitTemperature.fahrenheit:
            weather.unitsystem = UnitTemperature.celsius
        default:
            fatalError()
        }
    }
    
}
