//
//  LocationView.swift
//  WeatherForecast
//
//  Created by Ravikanth Thummala on 10/27/23.
//

import SwiftUI
import CoreLocationUI

struct WelcomeView: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Text("Welcome")
                    .bold()
                    .font(.largeTitle)
                
                Text("Weather Forecast")
                    .bold()
                    .font(.title2)
                
                Text("Please share your current location ")
                    .multilineTextAlignment(.center)
                    .padding()
                
                LocationButton(.shareCurrentLocation) {
                    viewModel.requestLocation()
                }
                .cornerRadius(30)
                .symbolVariant(.fill)
                .foregroundColor(.white)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
