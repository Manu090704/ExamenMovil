//
//  PokemonInfoRequirement.swift
//  Pokedex
//
//  Created by Manuel Bajos Rivera on 02/11/25.
//

import Foundation

protocol CovidCasesRequirementProtocol {
    func getCovidCases(country:String, date:String) async throws-> [CovidData]
}

class CovidCasesRequirement: CovidCasesRequirementProtocol {
    static let shared: CovidCasesRequirement = CovidCasesRequirement()
    let dataRepository : CovidCasesRepository

    init(dataRepository: CovidCasesRepository = CovidCasesRepository.shared) {
        self.dataRepository = dataRepository
    }
    
    func getCovidCases(country:String, date:String) async throws -> [CovidData]{
        return try  await dataRepository.getCovidCases(country:country, date:date)
    }
}

