//
//  VacancyDetails.swift
//  Java Project
//
//  Created by Zaitsev Vladislav on 08.06.2025.
//

import SwiftUI

struct VacancyDetails: View {
    let vacancy: Vacancy

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(vacancy.title)
                    .font(.title)
                    .bold()
                
                if let salary = vacancy.salary, !salary.isEmpty {
                    Text("Зарплата: \(salary)")
                        .font(.headline)
                        .bold()
                }

                if let company = vacancy.company, !company.isEmpty {
                    Text("Компания: \(company)")
                        .foregroundColor(.gray)
                }

                if let city = vacancy.city, !city.isEmpty {
                    Text("Город: \(city)")
                        .foregroundColor(.secondary)
                }

                Divider()

                Text("Описание:")
                    .font(.headline)
                
                Text(vacancy.description)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)

                if let requirements = vacancy.requirements, !requirements.isEmpty {
                    Text("Требования:")
                        .font(.headline)
                    Text(requirements)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }

                if let url = URL(string: vacancy.link) {
                    Link("Открыть вакансию в браузере", destination: url)
                        .padding(.top)
                }
                
                if let date = vacancy.publishDate {
                    if date != "" {
                        Text("Дата публикации: \(date)")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
        }
    }
}
