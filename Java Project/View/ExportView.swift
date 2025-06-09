//
//  ExportView.swift
//  Java Project
//
//  Created by Zaitsev Vladislav on 08.06.2025.
//

import SwiftUI
import Foundation
import UniformTypeIdentifiers
import AppKit

struct ExportView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ViewModelOfVacancies
    
    var body: some View {
        Menu {
            Button("Экспорт в JSON") {
                export(.json)
            }
            Button("Экспорт в CSV") {
                export(.csv)
            }
            Button("Экспорт в HTML") {
                export(.html)
            }
        } label: {
            Label("", systemImage: "square.and.arrow.up")
                .padding(10)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
    
    private func export(_ format: ExportFormat) {
        guard !viewModel.vacancies.isEmpty else { return }

        let exporter = VacancyExporter()
        let data: Data?

        switch format {
        case .json:
            data = exporter.exportToJSON(viewModel.vacancies)
        case .csv:
            data = Data(exporter.exportToCSV(viewModel.vacancies).utf8)
        case .html:
            data = Data(exporter.exportToHTML(viewModel.vacancies).utf8)
        }

        if let data = data {
            saveFile(data: data, format: format)
        }
    }

    private func saveFile(data: Data, format: ExportFormat) {
        let defaultFileName = "vacancies.\(format.rawValue)"
        
        DispatchQueue.main.async {
            let savePanel = NSSavePanel()
            savePanel.nameFieldStringValue = defaultFileName
            
            if NSApplication.shared.runModal(for: savePanel) == .OK, let url = savePanel.url {
                do {
                    try data.write(to: url)
                } catch {
                    print("Ошибка сохранения: $error.localizedDescription)")
                }
            }
        }
    }
}

enum ExportFormat: String {
    case json = "json"
    case csv = "csv"
    case html = "html"

    var contentType: UTType {
        switch self {
        case .json:
            return .json
        case .csv:
            return .plainText
        case .html:
            return .html
        }
    }
}

