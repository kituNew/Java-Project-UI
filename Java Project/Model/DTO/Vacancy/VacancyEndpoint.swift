//
//  VacancyEndpoint.swift
//  SiriusYoungCon
//
//  Created by Владимир Мацнев on 27.03.2025.
//

import Foundation

struct VacancyEndpoint: Endpoint {
    var baseURL = APIRoutes().baseURL

    var path = APIRoutes().getVacancies

    var method = HTTPMethod.get

    var headers: [String: String]?

}
