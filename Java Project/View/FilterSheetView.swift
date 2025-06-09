//
//  FilterSheetView.swift
//  Java Project
//
//  Created by Zaitsev Vladislav on 08.06.2025.
//

import SwiftUI

struct FilterSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ViewModelOfVacancies

    var body: some View {
        Form {
            Section(header: Text("Город")) {
                TextField("", text: $viewModel.filterCity)
            }

            Section(header: Text("Компания")) {
                TextField("", text: $viewModel.filterCompany)
            }

            Section {
                Toggle("Только с зарплатой", isOn: $viewModel.onlyWithSalary)
            }

            HStack {
                Button("Применить фильтры") {
                    viewModel.applyCombinedFilter(city: viewModel.filterCity, company: viewModel.filterCompany, onlyWithSalary: viewModel.onlyWithSalary)
                    presentationMode.wrappedValue.dismiss()
                }
                
                Button("Сбросить фильтры") {
                    viewModel.getVacancies()
                    viewModel.filterCity = ""
                    viewModel.filterCompany = ""
                    viewModel.onlyWithSalary = false
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .navigationTitle("Фильтры")
    }
}
