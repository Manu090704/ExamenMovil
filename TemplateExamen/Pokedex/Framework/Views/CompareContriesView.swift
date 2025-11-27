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

                    Text("📊 Comparativa COVID")
                        .font(.largeTitle.bold())
                        .padding(.top)

                    // -------------- País A ----------------
                    VStack(alignment: .leading, spacing: 6) {
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

                    // -------------- País B ----------------
                    VStack(alignment: .leading, spacing: 6) {
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

                    // LOADING
                    if vm.isLoading {
                        ProgressView("Cargando datos…")
                            .padding(.top)
                    }

                    // ERROR
                    if let err = vm.errorMessage {
                        Text(err).foregroundColor(.red)
                    }

                    // ====== GRAFICA 1: País A ======
                    if let data = vm.countryA {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("📈 \(vm.selectedCountryA)")
                                .font(.headline)

                            Chart(vm.chartData, id: \.date) { point in
                                if let v = point.totalA {
                                    AreaMark(
                                        x: .value("Fecha", point.date),
                                        y: .value("Casos", v)
                                    )
                                    .foregroundStyle(
                                        .linearGradient(
                                            colors: [.blue.opacity(0.3), .clear],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )

                                    LineMark(
                                        x: .value("Fecha", point.date),
                                        y: .value("Casos", v)
                                    )
                                    .interpolationMethod(.catmullRom)
                                    .foregroundStyle(.blue)
                                    .lineStyle(.init(lineWidth: 3))

                                    PointMark(
                                        x: .value("Fecha", point.date),
                                        y: .value("Casos", v)
                                    )
                                    .symbolSize(30)
                                    .foregroundStyle(.blue)
                                }
                            }
                            .frame(height: 260)
                        }
                    }

                    // ====== GRAFICA 2: País B ======
                    if let data = vm.countryB {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("📈 \(vm.selectedCountryB)")
                                .font(.headline)

                            Chart(vm.chartData, id: \.date) { point in
                                if let v = point.totalB {
                                    AreaMark(
                                        x: .value("Fecha", point.date),
                                        y: .value("Casos", v)
                                    )
                                    .foregroundStyle(
                                        .linearGradient(
                                            colors: [.red.opacity(0.3), .clear],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )

                                    LineMark(
                                        x: .value("Fecha", point.date),
                                        y: .value("Casos", v)
                                    )
                                    .interpolationMethod(.catmullRom)
                                    .foregroundStyle(.red)
                                    .lineStyle(.init(lineWidth: 3))

                                    PointMark(
                                        x: .value("Fecha", point.date),
                                        y: .value("Casos", v)
                                    )
                                    .symbolSize(30)
                                    .foregroundStyle(.red)
                                }
                            }
                            .frame(height: 260)
                        }
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
