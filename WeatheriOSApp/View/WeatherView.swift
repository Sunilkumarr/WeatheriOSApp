//
//  WeatherView.swift
//  WeatheriOSApp
//
//  Created by Sunil K on 17/07/25.
//

import SwiftUI

struct WeatherView: View {
    @StateObject var weatherViewMode = WeatherViewModel ()
    @StateObject var locationManager = LocationManager()
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    if locationManager.equatableLocation == nil {
                        VStack {
                            Spacer()
                            Text("Getting location...")
                            Spacer()
                        }
                        .frame(minHeight: geometry.size.height)
                        .frame(maxWidth: .infinity)
                    } else {
                        if weatherViewMode.temperature.isEmpty {
                            VStack {
                                Spacer()
                                Text("Loading weather...")
                                Spacer()
                            }
                            .frame(minHeight: geometry.size.height)
                            .frame(maxWidth: .infinity)
                        } else {
                            VStack(spacing: 5) {
                                if let city = locationManager.cityName {
                                    Text(city).font(.largeTitle)
                                }
                                let weatherInfo = WeatherView.weatherInfo(for: weatherViewMode.weathercode)
                                TimelineView(.animation) { context in
                                    let scale = 1 + 0.1 * sin(context.date.timeIntervalSinceReferenceDate)
                                    Image(systemName: weatherInfo.iconName)
                                        .renderingMode(.template)
                                        .foregroundColor(.orange)
                                        .font(.system(size: 60))
                                        .scaleEffect(scale)
                                }
                                Text(weatherViewMode.temperature).font(.largeTitle)
                                Text(weatherInfo.description)
                                Text("Wind Speed: \(weatherViewMode.windspeed)")
                                Text("Wind Direction: \(weatherViewMode.winddirection)")
                                Text("Max: \(weatherViewMode.max)")
                                Text("Min: \(weatherViewMode.min)")
                                
                                HourlyForecastScrollView(hourlyData: weatherViewMode.hourly)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .navigationTitle("Weather")
            .onAppear() {
                locationManager.startUpdatingLocation()
            }
            .onChange(of: locationManager.equatableLocation) {
                print("Location received: \(String(describing: locationManager.equatableLocation))")
                if let latitude = locationManager.equatableLocation?.lat, let longitude = locationManager.equatableLocation?.lon {
                    Task {
                        await weatherViewMode.fetchWeather(lat: latitude, long: longitude)
                    }
                }
            }
        }
    }
    
    
    static func weatherInfo(for code: Int) -> WeatherInfo {
        switch code {
        case 0:
            return WeatherInfo(iconName: "sun.max.fill", description: "Clear Sky")
        case 1, 2:
            return WeatherInfo(iconName: "cloud.sun.fill", description: "Partly Cloudy")
        case 3:
            return WeatherInfo(iconName: "cloud.fill", description: "Overcast")
        case 45, 48:
            return WeatherInfo(iconName: "cloud.fog.fill", description: "Fog")
        case 51, 53, 55:
            return WeatherInfo(iconName: "cloud.drizzle.fill", description: "Drizzle")
        case 56, 57:
            return WeatherInfo(iconName: "cloud.sleet.fill", description: "Freezing Drizzle")
        case 61, 63, 65:
            return WeatherInfo(iconName: "cloud.rain.fill", description: "Rain")
        case 66, 67:
            return WeatherInfo(iconName: "cloud.sleet.fill", description: "Freezing Rain")
        case 71, 73, 75:
            return WeatherInfo(iconName: "cloud.snow.fill", description: "Snowfall")
        case 77:
            return WeatherInfo(iconName: "snowflake", description: "Snow Grains")
        case 80, 81, 82:
            return WeatherInfo(iconName: "cloud.heavyrain.fill", description: "Rain Showers")
        case 85, 86:
            return WeatherInfo(iconName: "cloud.snow.fill", description: "Snow Showers")
        case 95:
            return WeatherInfo(iconName: "cloud.bolt.fill", description: "Thunderstorm")
        case 96, 99:
            return WeatherInfo(iconName: "cloud.bolt.rain.fill", description: "Thunderstorm with Hail")
        default:
            return WeatherInfo(iconName: "questionmark.circle.fill", description: "Unknown Weather")
        }
    }
}

#Preview {
    WeatherView()
}
