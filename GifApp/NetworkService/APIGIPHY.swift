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
    
    public func getGif(isPagging: Bool, searchFilter: SearchFilter, complition: @escaping ((Result<Any, NetworkError>) -> Void)) {
        makeDataTask(urlRequest: makeURLRequest(isPagging: isPagging, searchFilter: searchFilter), type: GIPHYModel.self, complitionHandler: complition)
    }
}

private extension APIGIPHYRequest {
    
    func makeURLRequest(isPagging: Bool, searchFilter: SearchFilter) -> URLRequest? {
        guard let url = makeURL(isPagging: isPagging, searchFilter: searchFilter) else { return nil }
        let urlRequest = URLRequest(url: url)
        return urlRequest
    }
    
    func makeURL(isPagging: Bool, searchFilter: SearchFilter) -> URL? {
        if isPagging {
            APIGIPHY.offset += APIGIPHY.limit
        }
        let urlString = "\(APIGIPHY.baseURL)\(APIGIPHY(theme: searchFilter.word).path)"
        let url = URL(string: urlString)
        return url
    }
    

}



