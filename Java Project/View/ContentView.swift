//
//  ContentView.swift
//  Java Project
//
//  Created by Zaitsev Vladislav on 08.06.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModelOfVacancies()
    @State private var searchText = ""
    @FocusState private var isFocused: Bool
    @State private var isSortingPresented = false
    @State private var isFilterPresented = false
    @State private var isExportPresented = false
    
    var body: some View {
        VStack {
            TextField("Поиск вакансий", text: $searchText)
                .padding(8)
                .focused($isFocused)
                .onSubmit {
                    viewModel.isLoading = true
                    if searchText == "" {
                        viewModel.getVacancies()
                    } else {
                        viewModel.filterVacancies(query: searchText)
                    }
                    isFocused = false
                }
                .padding(.horizontal)
            
            if viewModel.isLoading {
                ProgressView()
                Spacer()
            } else {
                NavigationSplitView {
                    List(viewModel.vacancies, id: \.link) { vacancy in
                        NavigationLink(value: vacancy) {
                            VacancyView(vacancy: vacancy)
                                .id(vacancy.link)
                        }
                    }
                    .navigationDestination(for: Vacancy.self) { vacancy in
                        VacancyDetails(vacancy: vacancy)
                            .id(vacancy.link)
                    }
                    .listStyle(.plain)
                } detail: {
                    Text("Выберите вакансию из списка")
                        .font(.title)
                        .padding()
                }
                .navigationSplitViewStyle(.prominentDetail)
            }
        }
        .padding()
        .navigationTitle("Вакансии")
        .onAppear {
            viewModel.getVacancies()
            isFocused = false
            Timer.scheduledTimer(withTimeInterval: 30*60, repeats: true) { timer in
                viewModel.filterVacancies(query: searchText)
            }
        }
        .toolbar {
            ToolbarItem {
                HStack {
                    Text("Cредняя зарплата: \(viewModel.ststistic)")
                    
                    Button(action: {
                        isSortingPresented = true
                    }) {
                        Image(systemName: "arrow.up.arrow.down")
                            .foregroundColor(.blue)
                        Text("Сортировать")
                    }
                    .sheet(isPresented: $isSortingPresented) {
                        SortingSheetView(viewModel: viewModel)
                    }

                    Button(action: {
                        isFilterPresented = true
                    }) {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(.blue)
                        Text("Фильтры")
                    }
                    .sheet(isPresented: $isFilterPresented) {
                        FilterSheetView(viewModel: viewModel)
                    }
                    
                    //ExportView(viewModel: viewModel)
                }
            }
        }
    }
}
