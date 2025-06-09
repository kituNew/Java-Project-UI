//
//  VacancyView.swift
//  Java Project
//
//  Created by Zaitsev Vladislav on 08.06.2025.
//

import SwiftUI

struct VacancyView: View {
    var vacancy: Vacancy
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(vacancy.title)
                .font(.headline)
            if let company = vacancy.company {
                Text("Компания: \(company)")
                    .foregroundColor(.gray)
            }
            Divider()
        }
    }
}
