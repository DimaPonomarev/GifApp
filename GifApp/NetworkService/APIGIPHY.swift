//
//  APIGIPHY.swift
//  GifApp
//
//  Created by Дмитрий Пономарев on 02.10.2023.
//

import Foundation

struct  APIGIPHY {
    static let baseURL = "https://api.giphy.com/"
    private let apiKey = "AY1Vd8OtgwcCyGmToDzoRtrIyaQF96tW"
    private var theme: String
    static var limit = 10
    static var offset = 0
    let path: String
    
    init(theme: String) {
        self.theme = theme
        self.path = "v1/gifs/search?api_key=\(self.apiKey)&q=\(theme)&limit=\(APIGIPHY.limit)&offset=\(APIGIPHY.offset)&rating=g&lang=en&bundle=messaging_non_clips"
    }
}

struct SearchFilter  {
    let word: String
}

final class APIGIPHYRequest: DataFetcherProtocol {
    
    func getGIF(isPagging: Bool, searchFilter: SearchFilter, complition: @escaping ((Result<Any, NetworkError>) -> Void)) {
        changingOffsetIfNeeded(isPagging: isPagging)
        makeDataTask(urlRequest: makeURLRequest(searchFilter: searchFilter), type: GIPHYModel.self, complitionHandler: complition)
    }
}

private extension APIGIPHYRequest {
    
    func makeURLRequest(searchFilter: SearchFilter) -> URLRequest? {
        guard let url = makeURL(searchFilter: searchFilter) else { return nil }
        return URLRequest(url: url)
    }
    
    func makeURL(searchFilter: SearchFilter) -> URL? {
        URL(string: "\(APIGIPHY.baseURL)\(APIGIPHY(theme: searchFilter.word).path)")
    }
    
    func changingOffsetIfNeeded(isPagging: Bool) {
        if isPagging {
            APIGIPHY.offset += APIGIPHY.limit
        } else {
            APIGIPHY.limit = 10
            APIGIPHY.offset = 0
        }
    }
}



