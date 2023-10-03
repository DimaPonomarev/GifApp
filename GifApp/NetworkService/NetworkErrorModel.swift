//
//  NetworkErrorModel.swift
//  GifApp
//
//  Created by Дмитрий Пономарев on 03.10.2023.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case missedHTTPURLResponse
    case jsonParsingFailure
    case invalidStatusCode(Int)
    case canceledResponse
    case unknownError
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL error"
        case .missedHTTPURLResponse:
            return "Missed HTTPURLResponse error, check your connection"
        case .jsonParsingFailure:
            return "JSON parsing failure error"
        case .invalidStatusCode(let code):
            return "Invalid status code error: \(code)"
        case .canceledResponse:
            return "Response canceled"
        case .unknownError:
            return "Unknown error"
            
            
        }
    }
}
