//
//  ApiServiceProtocol.swift
//  NY Times Articles
//
//  Created by Zuhaib Imtiaz on 7/1/22.
//

import Foundation
import Combine

enum APIError: Error,Equatable {
    
    case requestFailed(description: String)
    case jsonConversionFailure(description: String)
    case invalidData
    case responseUnsuccessful(description: String)
    case jsonParsingFailure
    case noInternet
    case failedSerialization
    case none
    
    var customDescription: String {
        switch self {
        case let .requestFailed(description): return "Request Failed error -> \(description)"
        case .invalidData: return "Invalid Data error)"
        case let .responseUnsuccessful(description): return "Response Unsuccessful error -> \(description)"
        case .jsonParsingFailure: return "JSON Parsing Failure error)"
        case let .jsonConversionFailure(description): return "JSON Conversion Failure -> \(description)"
        case .noInternet: return "No internet connection"
        case .failedSerialization: return "serialization print for debug failed."
        case .none: return ""
        }
    }
}

protocol ApiServiceProtocol {
    func fetch<T: Decodable>(type: T.Type, with request: URLRequest) async throws -> T
}

extension ApiServiceProtocol {
    
    func fetch<T: Decodable>(type: T.Type, with request: URLRequest) async throws -> T {
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.requestFailed(description: ApiErrorLocalizationKeyEnum.invalidDataApiErrorKey.rawValue)
        }
        guard httpResponse.statusCode == 200 else {
            throw APIError.responseUnsuccessful(description: "\(httpResponse.statusCode)")
        }
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw APIError.jsonConversionFailure(description: error.localizedDescription)
        }
    }
}

