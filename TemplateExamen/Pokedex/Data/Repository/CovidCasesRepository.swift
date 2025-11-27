import Foundation

protocol CovidCaseProtocol {
    //https://api.api-ninjas.com/v1/covid19?country=canada&date=2025/20 chechar fecha
    func getCovidCases(country: String, date: String) async throws -> [CovidData]
    
}

class CovidCasesRepository: CovidCaseProtocol {
    let nservice: CovidService
    static let shared = CovidCasesRepository()
    
    init(nservice: CovidService = CovidService.shared) {
        self.nservice = nservice
    }
    
    func getCovidCases(country: String, date: String) async throws-> [CovidData]{
        return try await nservice.getCountryData(country: country, date: date)
    }
}
    

