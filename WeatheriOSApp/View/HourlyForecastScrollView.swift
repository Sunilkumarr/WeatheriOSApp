//
//  HourlyForecastScrollView.swift
//  WeatheriOSApp
//
//  Created by Sunil kumar on 17/07/25.
//

import SwiftUI
import Foundation

struct HourlyForecastScrollView: View {
    let hourlyData: [HourlyForecast]
    
    var body: some View {
        if hourlyData.isEmpty {
            Text("No hourly data")
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(hourlyData) { forecast in
                        HourlyCellView(forecast: forecast)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
