//
//  APIRoutes.swift
//  Founders
//
//  Created by Владимир Мацнев on 18.03.2025.
//

import Foundation

struct APIRoutes {
    let baseURL = URL(string: "http://localhost:8080")
    let getVacancies: String = "/api/vacancies/"
    let getAndUpdateVacancies: String = "/api/vacancies/update/"
}
