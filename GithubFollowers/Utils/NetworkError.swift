//
//  NetworkError.swift
//  GithubFollowers
//
//  Created by Mustafa Kemal Gökçe on 7.02.2024.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidUrl
    case invalidData
    case badResponse
    case unauthorized
    case notFound
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "The URL is invalid."
        case .invalidData:
            return "The received data is invalid."
        case .badResponse:
            return "The server responded with an unexpected error."
        case .unauthorized:
            return "You are not authorized to access this resource."
        case .notFound:
            return "The requested resource was not found."
        case .serverError(let message):
            return message
        }
    }
}
