//
//  ForecastedWeatherModel.swift
//  WeatherForecast
//
//  Created by Ravikanth Thummala on 10/27/23.
//

import Foundation

struct ForecastedWeatherModel: Codable {
    var list: [DaysResponse]
}

struct DaysResponse: Codable, Hashable {
    var dt: Int
    var temp: Temperature
    var weather: [WeatherResponse]
}

extension DaysResponse {
    var logo: String {
        "https://openweathermap.org/img/wn/\(weather[0].icon)@2x.png"
    }
    var temperature: String {
        "\(temp.min.roundDouble())\("°C") to \(temp.max.roundDouble())\("°C")"
    }
    var date: String {
        "\(Date(timeIntervalSince1970: TimeInterval(dt)).formatted(.dateTime.month().day().year()))"
    }
}

struct Temperature: Codable, Hashable {
    var min: Double
    var max: Double
}


extension Double {
    func roundDouble() -> String {
        return String(format: "%.0f", self)
    }
}
