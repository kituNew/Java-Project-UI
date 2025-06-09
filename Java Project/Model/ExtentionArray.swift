//
//  ExtentionArray.swift
//  Java Project
//
//  Created by Zaitsev Vladislav on 08.06.2025.
//

import Foundation

extension Array where Element == Vacancy {
    func removingDuplicates() -> [Vacancy] {
        var seen = Set<String>()
        return filter { vacancy in
            guard !vacancy.link.isEmpty else { return false }

            let components = vacancy.link.split(separator: "/")
            guard let lastComponent = components.last,
                  lastComponent.rangeOfCharacter(from: .letters) == nil else {
                // Если последняя часть содержит буквы — не используем её
                return false
            }

            let linkIdentifier = String(lastComponent)

            if seen.contains(linkIdentifier) {
                return false
            } else {
                seen.insert(linkIdentifier)
                return true
            }
        }
    }
}
