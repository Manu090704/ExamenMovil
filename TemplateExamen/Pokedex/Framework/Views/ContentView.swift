import SwiftUI
import Charts

struct ContentView: View {
    @StateObject private var vm = CovidViewModel()

    @State private var selectedCountry = "Canada"
    let countries = ["Canada", "Argentina", "Colombia", "Peru", "Chile"]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {

                    Text("📊 COVID-19 Dashboard")
                        .font(.largeTitle.bold())
                        .padding(.top)

                    // SELECTOR PAÍS
                    VStack(alignment: .leading, spacing: 6) {
                        Text("País")
                            .font(.headline)

                        Picker("País", selection: $selectedCountry) {
                            ForEach(countries, id: \.self) { c in
                                Text(c)
                            }
                        }
                        .pickerStyle(.menu)
                        .onChange(of: selectedCountry) { new in
                            Task { await vm.fetch(country: new) }
                        }
                    }

                    // LOADING
                    if vm.isLoading {
                        ProgressView("Cargando datos…")
                            .padding(.top)
                    }

                    // ERROR
                    if let err = vm.errorMessage {
                        Text(err)
                            .foregroundColor(.red)
                        Button("Reintentar") {
                            Task { await vm.fetch(country: selectedCountry) }
                        }
                        .buttonStyle(.borderedProminent)
                    }

                    // ---- SI HAY DATOS ----
                    if vm.covid != nil {

                        // SELECTOR DE FECHA
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(vm.availableDates, id: \.self) { date in
                                    Text(date)
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 14)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(vm.selectedDate == date
                                                      ? Color.blue.opacity(0.25)
                                                      : Color.gray.opacity(0.1))
                                        )
                                        .onTapGesture {
                                            vm.selectedDate = date
                                        }
                                }
                            }
                            .padding(.bottom)
                        }

                        // GRAFICA BONITA
                        Chart(vm.chartData, id: \.date) { item in
                            AreaMark(
                                x: .value("Fecha", item.date),
                                y: .value("Casos Totales", item.total)
                            )
                            .foregroundStyle(
                                .linearGradient(
                                    colors: [.blue.opacity(0.4), .clear],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )

                            LineMark(
                                x: .value("Fecha", item.date),
                                y: .value("Casos Totales", item.total)
                            )
                            .interpolationMethod(.catmullRom) // curva suave
                            .lineStyle(.init(lineWidth: 3))
                            .foregroundStyle(.blue)

                            PointMark(
                                x: .value("Fecha", item.date),
                                y: .value("Casos Totales", item.total)
                            )
                            .symbolSize(40)
                            .foregroundStyle(.blue)
                        }
                        .frame(height: 320)
                        .padding(.horizontal)

                        // TARJETA DE DATOS
                        if let date = vm.selectedDate,
                           let day = vm.covid?.cases[date] {

                            VStack(alignment: .leading, spacing: 10) {
                                Text("📅 \(date)")
                                    .font(.headline)
                                Text("🦠 Casos totales: \(day.total ?? 0)")
                                Text("📈 Casos nuevos: \(day.new ?? 0)")
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                    }

                    Spacer(minLength: 30)
                }
                .padding()
            }
            .navigationTitle("COVID Stats")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await vm.fetch(country: selectedCountry)
            }
        }
    }
}
