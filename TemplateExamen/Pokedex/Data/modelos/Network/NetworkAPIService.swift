//
//  NetworkAPIService.swift
//  Pokedex
//
//  Created by Manuel Bajos Rivera on 27/10/25.
//
import Foundation
import Alamofire

class NetworkAPIService {
    static let shared = NetworkAPIService()
    
    func getPokedex(url: URL, limit: Int) async -> Pokedex?{
        let parameters : Parameters = ["limit": limit]
        
        let taskRequest = AF.request(url, method: .get, parameters: parameters).validate()
        let response = await taskRequest.serializingData().response
        
        switch response.result {
        case .success(let data):
            do {
                return try JSONDecoder().decode(Pokedex.self, from: data)
            } catch{
                return nil
            }
        case let .failure(error):
            debugPrint(error.localizedDescription)
            return nil
        }
    }
    
    func getPokemonInfo(url: URL) async -> Perfil?{
        
        let taskRequest = AF.request(url, method: .get).validate()
        let response = await taskRequest.serializingData().response
        
        switch response.result {
        case .success(let data):
            do {
                return try JSONDecoder().decode(Perfil.self, from: data)
            } catch{
                return nil
            }
        case let .failure(error):
            debugPrint(error.localizedDescription)
            return nil
        }
    }
}
