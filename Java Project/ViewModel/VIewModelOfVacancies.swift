//
//  VIewModelOfVacancies.swift
//  Java Project
//
//  Created by Zaitsev Vladislav on 08.06.2025.
//

import SwiftUI

@MainActor
class ViewModelOfVacancies: ObservableObject {
    
    @Published var vacancies: [Vacancy] = [] {
        didSet {
            var c = 0
            var s: Double = 0
            for i in vacancies {
                if i.salary != "" && i.salary != nil {
                    c += 1
                    s += Vacancy.extractSalary(from: i.salary!) ?? 0
                }
            }
            ststistic = Int(s / Double(c))
        }
    }
    @Published var isLoading: Bool = false
    @Published var ststistic: Int = 0
    
    @Published var filterCity = ""
    @Published var filterCompany = ""
    @Published var onlyWithSalary = false
    
    private var counter: Int = 0
    
    func getVacancies() {
        Task {
            do {
                vacancies = try await fetchVacancies()
                vacancies = vacancies.filter { $0.title != "" }
                vacancies = vacancies.removingDuplicates()
                isLoading = false
            } catch {
                vacancies = []
            }
        }
    }
    
    func fetchVacancies() async throws -> [Vacancy] {
        let vacancyEndpoint = VacancyEndpoint()
        let vacancyRequest = VacancyRequest()

        let vacancyResponses: [VacancyResponseDTO] = try await NetworkService.shared.request(
            endpoint: vacancyEndpoint,
            requestDTO: vacancyRequest
        )

        let mappedVacancies = vacancyResponses.map { dto -> Vacancy in
            counter += 1
            return Vacancy(title: dto.title, company: dto.company, city: dto.city, salary: dto.salary, description: dto.description, requirements: dto.requirements, publishDate: dto.publishDate, link: dto.link, count: counter)
        }
        return mappedVacancies
    }
    
    func filterVacancies(query searchText: String) {
        Task {
            do {
                vacancies = try await fetchUpdateVacancies(searchText)
                vacancies = vacancies.filter { $0.title != "" }
                vacancies = vacancies.removingDuplicates()
                isLoading = false
                print(vacancies.count)
            } catch {
                vacancies = []
            }
        }
    }
    
    func fetchUpdateVacancies(_ searchText: String) async throws -> [Vacancy] {
        var vacancyEndpoint = VacancyUpdateEndpoint()
        vacancyEndpoint.path.append("\(searchText)/")
        print(vacancyEndpoint.path)
        let vacancyRequest = VacancyRequest()

        let vacancyResponses: [VacancyResponseDTO] = try await NetworkService.shared.request(
            endpoint: vacancyEndpoint,
            requestDTO: vacancyRequest
        )

        let mappedVacancies = vacancyResponses.map { dto -> Vacancy in
            counter += 1
            return Vacancy(title: dto.title, company: dto.company, city: dto.city, salary: dto.salary, description: dto.description, requirements: dto.requirements, publishDate: dto.publishDate, link: dto.link, count: counter)
        }
        return mappedVacancies
    }
    
    func applySort(option: SortingSheetView.SortOption) {
        vacancies = option.apply(to: vacancies)
    }
    
    func applyCombinedFilter(city: String, company: String, onlyWithSalary: Bool) {
        var result = vacancies

        if !city.isEmpty {
            let lowercasedCity = city.lowercased()
            result = result.filter { $0.city?.lowercased().contains(lowercasedCity) ?? false }
        }

        if !company.isEmpty {
            let lowercasedCompany = company.lowercased()
            result = result.filter { $0.company?.lowercased().contains(lowercasedCompany) ?? false }
        }

        if onlyWithSalary {
            result = result.filter { $0.salary != nil && !$0.salary!.isEmpty }
        }

        vacancies = result
    }
}
