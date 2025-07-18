//
//  WeatherModels.swift
//  WeatheriOSApp
//
//  Created by Sunil kumar on 18/07/25.
//

import Foundation

struct HourlyData : Codable {
    var time:[String]
    var temperature_2m: [Double]
    var weathercode: [Int]
}

struct CurrentWeatherUnits : Codable {
    var time: String
    var interval: String
    var temperature: String
    var windspeed: String
    var winddirection: String
    var is_day: String
    var weathercode: String
}

struct CurrentWeather: Codable {
    var time: String
    var interval: Int
    var temperature: Double
    var windspeed: Double
    var winddirection: Int
    var is_day: Int
    var weathercode: Int
}

struct Weather: Codable {
    var latitude: Float
    var longitude: Float
    var current_weather: CurrentWeather
    var current_weather_units: CurrentWeatherUnits
    var hourly: HourlyData
    var daily: Daily
}

struct Daily: Codable {
    var temperature_2m_max: [Double]
    var temperature_2m_min: [Double]
    var precipitation_probability_max: [Double]
}

struct WeatherInfo {
    var iconName: String
    var description: String
}

struct HourlyForecast: Identifiable {
    let id = UUID()
    let hour: String
    let temperature: String
    let weatherInfo: WeatherInfo
}
