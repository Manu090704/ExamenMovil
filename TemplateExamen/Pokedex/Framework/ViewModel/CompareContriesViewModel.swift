//
//  PerfilViewModel.swift
//  Pokedex
//
//  Created by Manuel Bajos Rivera on 26/11/25.
//

import SwiftUI
import Combine
import Foundation

@MainActor
final class CovidCompareViewModel: ObservableObject {

    @Published var countryA: CovidData?
    @Published var countryB: CovidData?

    @Published var selectedCountryA = "Canada"
    @Published var selectedCountryB = "Argentina"

    @Published var isLoading = false
    @Published var errorMessage: String?

    private let repo = CovidCasesRepository.shared

    /// Fechas válidas para la comparación
    var mergedDates: [String] {
        let datesA = countryA?.cases.compactMap { ($0.value.total ?? 0) > 0 ? $0.key : nil } ?? []
        let datesB = countryB?.cases.compactMap { ($0.value.total ?? 0) > 0 ? $0.key : nil } ?? []
        return Array(Set(datesA + datesB)).sorted()
    }

    struct ChartPoint: Identifiable {
        let id = UUID()
        let date: String
        let totalA: Int?
        let totalB: Int?
    }

    /// Datos comparativos para la gráfica
    var chartData: [ChartPoint] {
        mergedDates.map { date in
            ChartPoint(
                date: date,
                totalA: countryA?.cases[date]?.total,
                totalB: countryB?.cases[date]?.total
            )
        }
    }

    func fetchBoth() async {
        isLoading = true
        errorMessage = nil

        do {
            async let dataA = repo.getCovidCases(country: selectedCountryA, date: "")
            async let dataB = repo.getCovidCases(country: selectedCountryB, date: "")

            countryA = try await dataA.first
            countryB = try await dataB.first

        } catch {
            errorMessage = "No fue posible cargar datos."
        }

        isLoading = false
    }
}
