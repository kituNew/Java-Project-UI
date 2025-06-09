//
//  VacancyResponseDTO.swift
//  SiriusYoungCon
//
//  Created by Владимир Мацнев on 26.03.2025.
//

import Foundation

struct VacancyResponseDTO: ResponseDTO {
    let title: String
    let company: String?
    let city: String?
    let salary: String?
    let description: String
    let requirements: String?
    let publishDate: String?
    let link: String
}
