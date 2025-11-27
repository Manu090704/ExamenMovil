import Foundation
import SwiftUI
import Combine

@MainActor
final class CovidViewModel: ObservableObject {
    @Published var covid: CovidData?
    @Published var selectedDate: String?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let repo = CovidCasesRepository.shared

    /// Solo fechas donde **sí hay información**
    var availableDates: [String] {
        guard let data = covid else { return [] }

        return data.cases
            .filter { ($0.value.total ?? 0) > 0 || ($0.value.new ?? 0) > 0 } // 💥 solo días con datos reales
            .map { $0.key }
            .sorted()
    }

    /// Datos para gráfica
    var chartData: [(date: String, total: Int, new: Int)] {
        guard let data = covid else { return [] }

        return data.cases
            .filter { ($0.value.total ?? 0) > 0 || ($0.value.new ?? 0) > 0 } // 💥 importante
            .sorted { $0.key < $1.key }
            .compactMap {
                (date: $0.key,
                 total: $0.value.total ?? 0,
                 new: $0.value.new ?? 0)
            }
    }

    func fetch(country: String) async {
        isLoading = true
        errorMessage = nil

        do {
            var list = try await repo.getCovidCases(country: country, date: "")
            covid = list.first
            selectedDate = availableDates.first
        } catch {
            errorMessage = "No se pudieron obtener datos del país."
        }

        isLoading = false
    }
}
