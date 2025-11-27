//
//  NetworkAPIService.swift
//  Pokedex
//
//  Created by Manuel Bajos Rivera on 27/10/25.
//
import Foundation
import Alamofire


enum AppConfig {
    static let apiKey: String = "wzlGa5trNSldhp8OAGgjKw==f8oV6rOvyLH5YNAz"
    static let baseURL = "https://api.api-ninjas.com/v1/covid19"
}

struct CovidService {
    static let shared = CovidService()

    func getCountryData(country: String, date: String) async throws -> [CovidData] {
        guard var url = URLComponents(string: AppConfig.baseURL) else {
            throw URLError(.badURL)
        }

        url.queryItems = [
            URLQueryItem(name: "country", value: country),
            URLQueryItem(name: "date", value: date)
        ]
        var request = URLRequest(url: url.url!)
        request.httpMethod = "GET"
        request.addValue(AppConfig.apiKey, forHTTPHeaderField: "X-Api-Key")

        let (data, _) = try await URLSession.shared.data(for: request)
        let decoded = try JSONDecoder().decode([CovidData].self, from: data)
        return decoded
    }
}
