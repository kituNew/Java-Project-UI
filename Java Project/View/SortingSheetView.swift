//
//  SortingSheetView.swift
//  Java Project
//
//  Created by Zaitsev Vladislav on 08.06.2025.
//

import SwiftUI

struct SortingSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ViewModelOfVacancies
    //private var shared = SortingSheetView()

    enum SortOption: String, CaseIterable {
        case none = "Не сортировать"
        case byTitle = "По алфавиту"
        case bySalary = "По зарплате"
        case byCompany = "По компании"
        case byCity = "По городу"
        case byLate = "По позднему добавлению"

        func apply(to vacancies: [Vacancy]) -> [Vacancy] {
            switch self {
            case .none:
                return vacancies.sorted { $0.count < $1.count }
            case .byTitle:
                return vacancies.sorted { $0.title < $1.title }
            case .bySalary:
                return vacancies.sorted { (v1, v2) -> Bool in
                    if v1.salary == nil || v2.salary == nil { return false }
                    
                    let s1 = Vacancy.extractSalary(from: v1.salary!)
                    let s2 = Vacancy.extractSalary(from: v2.salary!)
                    
                    if s1 == nil && s2 == nil { return false }
                    if s1 == nil { return false }
                    if s2 == nil { return true }
                    
                    return s1! > s2!
                }
            case .byCity:
                return vacancies.sorted { ($0.city ?? "") > ($1.city ?? "") }
            case .byCompany:
                return vacancies.sorted { ($0.company ?? "") < ($1.company ?? "") }
            case .byLate:
                return vacancies.sorted { $0.count > $1.count }
            }
        }
    }

    @State private var selectedSortOption: SortOption = .none

    var body: some View {
        VStack {
            Picker("Сортировать по", selection: $selectedSortOption) {
                ForEach(SortOption.allCases, id: \.rawValue) {
                    Text($0.rawValue).tag($0)
                }
            }
            .pickerStyle(.menu)

            Button("Применить") {
                viewModel.applySort(option: selectedSortOption)
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
        .padding()
        .navigationTitle("Сортировка")
    }
}
