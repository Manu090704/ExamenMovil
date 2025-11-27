import Foundation
import SwiftUI
import Combine

@MainActor
final class CovidViewModel: ObservableObject {
    // -------- UI State --------
    @Published var covid: CovidData?
    @Published var selectedCountry: String = "Canada"
    @Published var selectedDate: String?
    @Published var isLoading = false
    @Published var errorMessage: String?

    // -------- Dependencies --------
    private let repo = CovidCasesRepository.shared
    private let local = LocalService.shared


    // ---------- DATES VÁLIDAS ----------
    /// Solo fechas que tienen datos reales
    var availableDates: [String] {
        guard let data = covid else { return [] }

        return data.cases
            .filter { day in
                (day.value.total ?? 0) > 0 || (day.value.new ?? 0) > 0
            }
            .map { $0.key }
            .sorted()
    }

    // ---------- DATA PARA GRÁFICA ----------
    /// Total y casos nuevos por día
    var chartData: [(date: String, total: Int, new: Int)] {
        guard let data = covid else { return [] }

        return data.cases
            .filter { ($0.value.total ?? 0) > 0 || ($0.value.new ?? 0) > 0 }
            .sorted { $0.key < $1.key }
            .map {
                (
                    date: $0.key,
                    total: $0.value.total ?? 0,
                    new: $0.value.new ?? 0
                )
            }
    }

    // ====================================================================
    // MARK: ---- API ----
    // ====================================================================

    /// Llama COVID API y restaura fecha desde cache si existe
    func fetch(country: String, restoringDate: String? = nil) async {
        isLoading = true
        errorMessage = nil

        do {
            let response = try await repo.getCovidCases(country: country, date: "")
            covid = response.first

            // Guarda el país seleccionado
            local.saveLastCountry(country)

            // Determina fechas
            let validDates = availableDates

            // Restaura fecha si era válida
            if let cacheDate = restoringDate, validDates.contains(cacheDate) {
                selectedDate = cacheDate
            } else {
                selectedDate = validDates.first
            }

        } catch {
            errorMessage = "No se pudieron obtener datos del país."
        }

        isLoading = false
    }

    // ====================================================================
    // MARK: ---- CACHE ----
    // ====================================================================

    /// Carga estado desde cache al abrir app
    func loadLastSelection() async {
        let cachedCountry = local.getLastCountry()
        let cachedDate = local.getLastDate()

        if let savedCountry = cachedCountry {
            selectedCountry = savedCountry
            await fetch(country: savedCountry, restoringDate: cachedDate)
        } else {
            await fetch(country: selectedCountry)
        }
    }

    /// Cuando el usuario selecciona una fecha en UI
    func updateSelectedDate(_ newDate: String) {
        selectedDate = newDate
        local.saveLastDate(newDate)
    }
}
