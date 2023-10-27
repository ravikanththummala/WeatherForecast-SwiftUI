//
//  Network.swift
//  WeatherForecast
//
//  Created by Ravikanth Thummala on 10/27/23.
//

import Foundation
import CoreLocation
import Combine

protocol NetworkType {
    func getData<T: Decodable>(urlpoint: URLpoint, type: T.Type) -> Future<T, Error>
}

enum URLpoint {
    case geoLocation(_ city: String)
    case currentWeather(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees)
    case forecast(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees, _ days: Int)
}

extension URLpoint {
    var params: String {
        switch self {
        case .geoLocation(let city):
            return "/geo/1.0/direct?q=\(city)&limit=1"
        case .currentWeather(let latitude, let longitude):
            return "/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=metric"
        case .forecast(let latitude, let longitude, let days):
            return "/data/2.5/forecast/daily?lat=\(latitude)&lon=\(longitude)&cnt=\(days)&units=metric"
        }
    }
}


private enum Constants {
    static let baseURL = "https://api.openweathermap.org"
    static let apiKey: String = "&appid=8bf352fcd95e743683b4dcf992a6e46e"
}

final class Network: NetworkType {
    
    private var cancellable = Set<AnyCancellable>()

    func getData<T: Decodable>(urlpoint: URLpoint, type: T.Type) -> Future<T, Error> {
        return Future<T, Error> { [weak self] promise in
            guard let self = self, let url = URL(string: Constants.baseURL.appending(urlpoint.params).appending(Constants.apiKey)) else {
                return promise(.failure(NetworkError.invalidURL))
            }
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.responseError
                    }
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkError.unknown))
                        }
                    }
                }, receiveValue: { promise(.success($0)) })
                .store(in: &self.cancellable)
        }
    }
}

enum NetworkError: Error {
    case locationError
    case invalidURL
    case responseError
    case unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .locationError:
            return "Entered city weather is not available"
        case .invalidURL:
            return "Invalid url"
        case .responseError:
            return "Unexpected status code"
        case .unknown:
            return "Unknown Error"
        }
    }
}
