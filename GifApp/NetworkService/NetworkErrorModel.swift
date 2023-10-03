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
    case invalidData
    case invalidStatusCode(Int)
    case unknownError(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL error"
        case .missedHTTPURLResponse:
            return "Missed HTTPURLResponse error"
        case .jsonParsingFailure:
            return "JSON parsing failure error"
        case .invalidData:
            return "Invalid data error"
        case .invalidStatusCode(let code):
            return "Invalid status code error: \(code)"
        case .unknownError(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}
