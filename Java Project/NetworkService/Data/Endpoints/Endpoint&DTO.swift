//
//  Endpoint&DTO.swift
//  Founders
//
//  Created by Владимир Мацнев on 18.03.2025.
//


import Foundation

protocol Endpoint {
    var baseURL: URL? { get }
    var path: String { get }
    var method: String { get }
    var headers: [String: String]? { get }
}

protocol RequestDTO: Encodable {}
protocol ResponseDTO: Decodable {}
