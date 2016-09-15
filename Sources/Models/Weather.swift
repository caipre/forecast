//
// Forecast
//
//

import Foundation
import CoreLocation

import Publinks
import ForecastIO
import SwiftyTimer

class Weather {
    
    let publink = Publink<Weather>()

    static let FORECASTIO_API_KEY = ""
    let apiclient: ForecastIO.APIClient
    
    var current: ForecastIO.DataPoint?
    var forecast: ForecastIO.DataBlock?
    var unitsystem = UnitTemperature.celsius {
        didSet {
            publink.publish(self)
        }
    }
    
    init() {
        self.apiclient = ForecastIO.APIClient.init(apiKey: Weather.FORECASTIO_API_KEY)
        self.apiclient.units = ForecastIO.Units.SI
        location.publink.subscribe { (location) in self.requestData() }
        Timer.every(15.minutes, self.requestData)
    }
    
    func temperature(for datapoint: DataPoint?, property: ApparantTemperature) -> String? {
        let val: Float?
        switch property {
        case .realfeel:
            val = datapoint?.apparentTemperature
        case .high:
            val = datapoint?.apparentTemperatureMax
        case .low:
            val = datapoint?.apparentTemperatureMin
        }
        guard val != nil else { return nil }
        let temperature = weather.temperature(from: val!)
        return "\(Int(temperature.value.rounded()))"
    }
    
    func temperature(from value: Float) -> Measurement<UnitTemperature> {
        let temperature = Measurement<UnitTemperature>(value: Double(value), unit: UnitTemperature.celsius)
        return temperature.converted(to: unitsystem)
    }
    
    func requestData() {
        guard let (lat, lon) = location.coordinates else { return }
        apiclient.getForecast(latitude: lat, longitude: lon) {
            (forecast, error) in
            guard error == nil else { return }
            self.current = forecast?.currently
            self.forecast = forecast?.daily
            self.publink.publish(self)
        }
    }
    
    enum ApparantTemperature {
        case realfeel, high, low
    }
    
}
