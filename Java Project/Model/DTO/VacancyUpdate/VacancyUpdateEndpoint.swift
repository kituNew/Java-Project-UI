//
//  VacancyUpdateEndpoint.swift
//  SiriusYoungCon
//
//  Created by Владимир Мацнев on 27.03.2025.
//

import Foundation

struct VacancyUpdateEndpoint: Endpoint {
    var baseURL = APIRoutes().baseURL

    var path = APIRoutes().getAndUpdateVacancies

    var method = HTTPMethod.get

    var headers: [String: String]?

}
