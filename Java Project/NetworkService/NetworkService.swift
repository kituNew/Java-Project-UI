//
//  FoundersNetworkService.swift
//  Founders
//
//  Created by Владимир Мацнев on 18.03.2025.
//

import Foundation

final class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    func request<Request: Encodable, Response: Decodable>(
        endpoint: Endpoint,
        requestDTO: Request,
        multipartBuilder: ((MultipartFormData) -> Void)? = nil,
        expectsMultipartResponse: Bool = false
    ) async throws -> Response {
        
        guard let baseURL = endpoint.baseURL else {
            throw NetworkError.internalError
        }
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path = endpoint.path
        
        guard let url = urlComponents?.url else {
            throw NetworkError.internalError
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method
        
        if let headers = endpoint.headers {
            for (key, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if endpoint.method != HTTPMethod.get {
            if let builder = multipartBuilder {
                let multipartFormData = MultipartFormData()
                builder(multipartFormData)
                urlRequest.setValue(multipartFormData.contentType(), forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = multipartFormData.finish()
            } else {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = try JSONEncoder().encode(requestDTO)
            }
        }
        
//        let url1 = URL(string: "http://localhost:8080/api/vacancies/")!
//
//        var request = URLRequest(url: url1)
//        request.httpMethod = "GET"
        
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknownError
        }
        
        let statusCode = httpResponse.statusCode
        
        if !(200...299).contains(statusCode) {
            throw NetworkError.invalidServerResponseCode(statusCode)
        }
        
        if expectsMultipartResponse {
            guard let contentType = httpResponse.allHeaderFields["Content-Type"] as? String,
                  contentType.contains("multipart/form-data"),
                  let boundary = MultipartResponseParser.extractBoundary(from: contentType)
            else {
                throw NetworkError.invalidMultipartResponse
            }
            
            let parts = try MultipartResponseParser.parse(data: data, boundary: boundary)
            
            if let multipartResponse = parts as? Response {
                return multipartResponse
            } else {
                throw NetworkError.parsingMultipartError
            }
        }
        
        let responseDTO = try JSONDecoder().decode(Response.self, from: data)
        return responseDTO
    }
}
