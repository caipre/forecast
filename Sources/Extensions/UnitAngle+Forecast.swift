//
//  Forecast
//
//

import Foundation

extension UnitAngle {
    enum Bearing: String {
        case north = "N", east = "E", south = "S", west = "W"
        case northEast = "NE", southEast = "SE", southWest = "SW", northWest = "NW"
    }
}

extension Measurement where UnitType: UnitAngle {
    var bearing: UnitAngle.Bearing {
        get {
            switch value.truncatingRemainder(dividingBy: 360) {
            case   0.0..<22.5:  return .north
            case  22.5..<67.5:  return .northEast
            case  67.5..<112.5: return .east
            case 112.5..<157.5: return .southEast
            case 157.5..<202.5: return .south
            case 202.5..<247.5: return .southWest
            case 247.5..<292.5: return .west
            case 292.5..<337.5: return .northWest
            case 337.5...360:   return .north
            default:
                fatalError()
            }
        }
    }
}
