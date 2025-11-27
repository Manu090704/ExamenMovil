//
//  PerfilView.swift
//  Pokedex
//
//  Created by Manuel Bajos Rivera on 26/11/25.
//

import SwiftUI
import Charts
import FlowStacks

struct CovidCompareView: View {
    @StateObject var vm = CovidCompareViewModel()

    let countries = ["Canada", "Argentina", "Colombia", "Peru", "Chile", "Ecuador"]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {

                    Text("📊 COVID Comparativa")
                        .font(.largeTitle.bold())
                        .padding(.top)

                    // 🔹 Selector País 1
                    VStack(alignment: .leading) {
                        Text("País A")
                            .font(.headline)

                        Picker("País A", selection: $vm.selectedCountryA) {
                            ForEach(countries, id: \.self) { c in
                                Text(c)
                            }
                        }
                        .pickerStyle(.menu)
                        .onChange(of: vm.selectedCountryA) { _ in
                            Task { await vm.fetchBoth() }
                        }
                    }

                    // 🔹 Selector País 2
                    VStack(alignment: .leading) {
                        Text("País B")
                            .font(.headline)

                        Picker("País B", selection: $vm.selectedCountryB) {
                            ForEach(countries, id: \.self) { c in
                                Text(c)
                            }
                        }
                        .pickerStyle(.menu)
                        .onChange(of: vm.selectedCountryB) { _ in
                            Task { await vm.fetchBoth() }
                        }
                    }

                    if vm.isLoading {
                        ProgressView("Cargando...")
                            .padding()
                    }

                    if let err = vm.errorMessage {
                        Text(err)
                            .foregroundColor(.red)
                    }

                    if !vm.chartData.isEmpty {

                        // 📈 Gráfica comparativa
                        Chart(vm.chartData) { point in

                            // Linea País A
                            if let v = point.totalA {
                                LineMark(
                                    x: .value("Fecha", point.date),
                                    y: .value("A", v)
                                )
                                .foregroundStyle(.blue)
                                .interpolationMethod(.catmullRom)
                            }

                            // Linea País B
                            if let v = point.totalB {
                                LineMark(
                                    x: .value("Fecha", point.date),
                                    y: .value("B", v)
                                )
                                .foregroundStyle(.red)
                                .interpolationMethod(.catmullRom)
                            }
                        }
                        .frame(height: 300)

                        // Leyenda
                        HStack(spacing: 16) {
                            Label(vm.selectedCountryA, systemImage: "circle.fill")
                                .foregroundColor(.blue)
                            Label(vm.selectedCountryB, systemImage: "circle.fill")
                                .foregroundColor(.red)
                        }
                        .font(.headline)
                        .padding(.top)
                    }

                    Spacer(minLength: 30)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await vm.fetchBoth()
            }
        }
    }
}

#Preview {
    CovidCompareView()
}
