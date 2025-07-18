//
//  WeatherAPIService.swift
//  WeatheriOSApp
//
//  Created by Sunil K on 17/07/25.
//

import Foundation
import SwiftUI

class WeatherAPIService {
    
    enum WeatherURL {
        static let baseURL = "https://api.open-meteo.com"
    }
    
    func fetchWeather(lat: Double, long: Double) async throws -> Result<Weather, Error> {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayString = formatter.string(from: today)
        
        let currentWeather = WeatherURL.baseURL + "/v1/forecast?latitude=\(lat)&longitude=\(long)&current_weather=true&hourly=temperature_2m,weathercode&daily=temperature_2m_max,temperature_2m_min,precipitation_probability_max&timezone=auto&start_date=\(todayString)&end_date=\(todayString)"
        
        guard let url = URL(string:currentWeather) else {
            return (.failure(NSError(domain: "com.weather.urlNil", code: 1, userInfo: nil)))
        }
        
        let (data, urlResponse) = try await URLSession.shared.data(from: url)
        
        guard let response = urlResponse as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
            return .failure(NSError(domain: "com.weather.responseNil", code: 1, userInfo: nil))
        }
        
        guard let weather = try JSONDecoder().decode(Weather.self, from: data) as? Weather else {
            return .failure(NSError(domain: "com.weather.dataNil", code: 1, userInfo: nil))
        }
        return .success(weather)
    }
}
