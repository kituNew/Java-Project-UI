//
//  MultipartPart.swift
//  Founders
//
//  Created by Владимир Мацнев on 18.03.2025.
//


import Foundation

struct MultipartPart {
    let headers: [String: String]
    let body: Data
}