//
//  Vacancy.swift
//  Java Project
//
//  Created by Zaitsev Vladislav on 08.06.2025.
//

import Foundation

struct Vacancy: Hashable, Codable, Equatable, Identifiable {
    let title: String
    let company: String?
    let city: String?
    let salary: String?
    let description: String
    let requirements: String?
    let publishDate: String?
    let link: String
    var id: String {
        return link
    }
    var count: Int
    
    static func extractSalary(from salaryString: String) -> Double? {
        let lowercased = salaryString.lowercased()
        let isDollar = salaryString.contains("$") || lowercased.contains("доллар") || lowercased.contains("usd")
        let isEuro = salaryString.contains("€") || lowercased.contains("евро") || lowercased.contains("eur")
        let isRubles = !isDollar && !isEuro
        
        var numbers = extractNumbersWithSeparators(from: salaryString)
        
        if isRubles && numbers.isEmpty {
            numbers = extractNumbersByCombining(from: salaryString)
        }
        
        guard !numbers.isEmpty else { return nil }
        
        let dollarRate = 78.5
        let euroRate = 85.2
        
        let average = numbers.reduce(0, +) / Double(numbers.count)
        
        if isDollar {
            return average * dollarRate
        } else if isEuro {
            return average * euroRate
        }
        
        return average
    }

    static func extractNumbersWithSeparators(from string: String) -> [Double] {
        let cleaned = string
            .replacingOccurrences(of: ",", with: ".")
            .replacingOccurrences(of: " ", with: " ")
        
        let pattern = "(?:^|\\s)(\\d{1,3}(?:[\\s.]?\\d{3})*(?:\\.\\d+)?)(?=\\s|$)"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return [] }
        
        let matches = regex.matches(in: cleaned, range: NSRange(cleaned.startIndex..., in: cleaned))
        
        return matches.compactMap { match in
            guard let range = Range(match.range(at: 1), in: cleaned) else { return nil }
            let numberString = String(cleaned[range])
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: ".", with: "")
            return Double(numberString)
        }
    }

    static func extractNumbersByCombining(from string: String) -> [Double] {
        let allDigits = string
            .replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        let pattern = "\\d{3,6}"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return [] }
        
        let matches = regex.matches(in: allDigits, range: NSRange(allDigits.startIndex..., in: allDigits))
        
        return matches.compactMap { match in
            guard let range = Range(match.range, in: allDigits) else { return nil }
            return Double(String(allDigits[range]))
        }
    }
}
