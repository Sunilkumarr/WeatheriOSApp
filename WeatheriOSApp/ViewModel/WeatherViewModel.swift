//
//  WeatherViewModel.swift
//  WeatheriOSApp
//
//  Created by Sunil K on 17/07/25.
//

import Foundation
import SwiftUI

class WeatherViewModel: ObservableObject {
    @Published var time: String = ""
    @Published var temperature: String = ""
    @Published var windspeed: String = ""
    @Published var winddirection: String = ""
    @Published var weathercode: Int = 0
    @Published var hourly: [HourlyForecast] = []
    @Published var min: String = ""
    @Published var max: String = ""
    
    var weatherAPIService = WeatherAPIService()
    
    func fetchWeather(lat: Double, long: Double) async {
        do {
            let weather = try await weatherAPIService.fetchWeather(lat: lat, long: long)
            switch weather {
            case .success(let weather):
                let currentWeather = weather.current_weather
                let currentWeatherUnits = weather.current_weather_units
                DispatchQueue.main.async {
                    self.time = currentWeather.time
                    self.temperature = String(currentWeather.temperature) + currentWeatherUnits.temperature
                    self.windspeed = String(currentWeather.windspeed) + currentWeatherUnits.windspeed
                    self.winddirection = String(currentWeather.winddirection) + currentWeatherUnits.winddirection
                    self.weathercode = currentWeather.weathercode
                    if let max = weather.daily.temperature_2m_max.first {
                        self.max = String(max) + currentWeatherUnits.temperature
                    }
                    if let min = weather.daily.temperature_2m_min.first {
                        self.min = String(min) + currentWeatherUnits.temperature
                    }
                    
                    let hourly = weather.hourly
                    let times = hourly.time
                    let temps = hourly.temperature_2m
                    let codes = hourly.weathercode
                    let inputFormatter = DateFormatter()
                    inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
                    inputFormatter.locale = Locale(identifier: "en_US_POSIX")
                    
                    let outputFormatter = DateFormatter()
                    outputFormatter.dateFormat = "ha"
                    let now = Date()
                    let twentyFourHoursLater = Calendar.current.date(byAdding: .hour, value: 24, to: now)!
                    
                    var hourlyForecastArray: [HourlyForecast] = []
                    
                    for index in 0..<times.count {
                        let timeString = times[index]
                        let weatherCode = codes[index]
                        
                        guard let forecastDate = inputFormatter.date(from: timeString) else {
                            continue
                        }
                        
                        if forecastDate >= now && forecastDate <= twentyFourHoursLater {
                            let hourString = outputFormatter.string(from: forecastDate)
                            let temp = String(temps[index]) + currentWeatherUnits.temperature
                            let weatherInfo = WeatherView.weatherInfo(for: weatherCode)
                            let forecast = HourlyForecast(hour: hourString, temperature: temp, weatherInfo: weatherInfo)
                            hourlyForecastArray.append(forecast)
                        }
                    }
                    self.hourly = hourlyForecastArray
                    let weatherInfo = WeatherView.weatherInfo(for: self.weathercode)
                    let forecast = HourlyForecast(hour: "Now", temperature: self.temperature, weatherInfo: weatherInfo)
                    self.hourly.insert(forecast, at: 0)
                }
            case .failure( let err):
                print("Error in fetch weather :", err.localizedDescription)
            default:
                print("Called default")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
