//
//  HourlyCellView.swift
//  WeatheriOSApp
//
//  Created by Sunil kumar on 17/07/25.
//
import SwiftUI
import Foundation

struct HourlyCellView: View {
    let forecast: HourlyForecast
    var body: some View {
        VStack(spacing: 8) {
            Text(forecast.hour)
                .font(.caption)
            let weatherInfo = forecast.weatherInfo
            TimelineView(.animation) { context in
                let scale = 1 + 0.1 * sin(context.date.timeIntervalSinceReferenceDate)
                Image(systemName: weatherInfo.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.orange)
                    .scaleEffect(scale)
            }
            Text(weatherInfo.description)
                .font(.footnote)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(forecast.temperature)
                .font(.footnote)
        }
        .frame(width: 100)
        .padding(.vertical, 10)
        .cornerRadius(10)
    }
}
