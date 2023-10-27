//
//  ForecastView.swift
//  Weather
//
//  Created by Ravikanth Thummala on 10/27/23.
//

import SwiftUI

struct ForecastView: View {
    var forecastWeather: ForecastedWeatherModel

    @State private var scale = 1.0

    var body: some View {
        let list = forecastWeather.list.dropFirst()
        VStack {
            Spacer()
            VStack(alignment: .leading) {
                Text("Daily Forecast")
                    .bold()
                    .padding(.leading)
                    .padding(.top)
                    .font(.title2)

                List {
                    ForEach(list, id: \.self) {
                        ItemRow(
                            logo: $0.logo,
                            temperature: $0.temperature,
                            date: $0.date
                        )
                    }
                }
                .listStyle(.plain)
            }
            .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.size.height/2.2, alignment: .leading)
            .padding(.bottom, 20)
            .foregroundColor(.black)
            .background(.white)
            .cornerRadius(20, corners: [.topLeft, .topRight])
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}
