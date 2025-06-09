//
//  VacancyExporter.swift
//  Java Project
//
//  Created by Zaitsev Vladislav on 09.06.2025.
//

import Foundation

class VacancyExporter {
    func exportToJSON(_ vacancies: [Vacancy]) -> Data? {
        return try? JSONEncoder().encode(vacancies)
    }

    func exportToCSV(_ vacancies: [Vacancy]) -> String {
        var csv = "Title,Company,City,Salary,Description,Requirements,Link\n"

        for vacancy in vacancies {
            let line = """
            "\(vacancy.title.replacingOccurrences(of: "\"", with: "\"\""))",\
            "\(vacancy.company?.replacingOccurrences(of: "\"", with: "\"\"") ?? "")",\
            "\(vacancy.city ?? "")",\
            "\(vacancy.salary ?? "")",\
            "\(vacancy.description.replacingOccurrences(of: "\"", with: "\"\""))",\
            "\(vacancy.requirements?.replacingOccurrences(of: "\"", with: "\"\"") ?? "")",\
            "\(vacancy.link)"
            """
        
            csv += line + "\n"
        }

        return csv
    }

    func exportToHTML(_ vacancies: [Vacancy]) -> String {
        var html = """
        <html>
        <head><title>Вакансии</title></head>
        <body>
        <h1>Список вакансий</h1>
        <table border="1" cellpadding="8" cellspacing="0">
        <tr><th>Название</th><th>Компания</th><th>Город</th><th>Зарплата</th><th>Описание</th><th>Требования</th><th>Ссылка</th></tr>
        """

        for vacancy in vacancies {
            html += """
            <tr>
                <td>\(vacancy.title)</td>
                <td>\(vacancy.company ?? "-")</td>
                <td>\(vacancy.city ?? "-")</td>
                <td>\(vacancy.salary ?? "-")</td>
                <td>\(vacancy.description.prefix(50))...</td>
                <td>\(vacancy.requirements ?? "-")</td>
                <td><a href="\(vacancy.link)">Ссылка</a></td>
            </tr>
            """
        }

        html += "</table></body></html>"
        return html
    }
}
