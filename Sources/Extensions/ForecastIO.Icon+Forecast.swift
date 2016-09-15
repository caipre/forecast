//
// Forecast
//
//

import ForecastIO
import DripIcons

extension Icon {
    func symbol() -> DripIcon {
        switch self {
        case .ClearDay:
            return .sun
        case .ClearNight:
            return .moon100
        case .Cloudy:
            return .clouds
        case .Fog:
            return .fog
        case .PartlyCloudyDay:
            return .cloudsSun
        case .PartlyCloudyNight:
            return .cloudsMoon
        case .Rain:
            return .rain
        case .Sleet:
            return .cloudDrizzle
        case .Snow:
            return .snow
        case .Wind:
            return .wind
        }
    }
}
