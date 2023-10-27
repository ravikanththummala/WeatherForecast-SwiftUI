//
//  WeatherForecastApp.swift
//  WeatherForecast
//
//  Created by Ravikanth Thummala on 10/27/23.
//

import SwiftUI

@main
struct WeatherForecastApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                viewModel: WeatherViewModel(
                    locationManager: LocationManager(),
                    networkManager: Network()
                )
            )
        }
    }
}
