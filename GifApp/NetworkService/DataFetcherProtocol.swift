//
//  NetworkService.swift
//  GifApp
//
//  Created by Дмитрий Пономарев on 02.10.2023.
//

import Foundation

enum Result<ParsedModel, NetworkError> {
    case succes(result: ParsedModel)
    case failure(error: NetworkError)
}

protocol DataFetcherProtocol {
    
    func makeDataTask(urlRequest: URLRequest?, type: Decodable.Type, complitionHandler: @escaping(Result<Any, NetworkError>) -> Void)
}

extension DataFetcherProtocol {
    
    //  MARK: - In this block getting URLRequest and URLSessionDataTask to make response(no matter which model will come)
    
    func makeDataTask(urlRequest: URLRequest?, type: Decodable.Type, complitionHandler: @escaping(Result<Any, NetworkError>) -> Void) {
        
        guard let urlRequest else {
            complitionHandler(.failure(error: .invalidURL))
            return
        }
        
        let task = JSONDataTask(type: type, request: urlRequest) { (data, response, error)  in
            if let error {
                complitionHandler(.failure(error: error))
            } else if let data {
                complitionHandler(.succes(result: data))
            }
        }
        task.resume()
    }
    
    //  MARK: - In this block making data, response, error from network and JSONDecoder
    
    private func JSONDataTask(type: Decodable.Type, request: URLRequest, complition: @escaping (Any?, HTTPURLResponse?, NetworkError?) -> Void) -> URLSessionDataTask {
        
        let dataTask = URLSession.shared.dataTask(with: request) {  data, response, error in
            
            DispatchQueue.global().async {
                guard let HTTPResponse = response as? HTTPURLResponse else {
                    complition(nil, nil, NetworkError.missedHTTPURLResponse)
                    return
                }
                if error != nil {
                    complition(nil, HTTPResponse, NetworkError.invalidStatusCode(HTTPResponse.statusCode))
                } else if let data {
                    switch HTTPResponse.statusCode {
                    case 200:
                        let json = self.decodeJson(type: type, from: data)
                        if json != nil {
                            complition(json, HTTPResponse, nil)
                        } else {
                            complition(nil, HTTPResponse, NetworkError.jsonParsingFailure)
                        }
                    default:
                        complition(nil, HTTPResponse, NetworkError.invalidStatusCode(HTTPResponse.statusCode))
                    }
                }
            }
        }
        return dataTask
    }
    
    //  MARK: - in this block parsing JSONData
    
    private func decodeJson<T: Decodable>(type: T.Type, from data: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data else { return nil }
        do {
            return try decoder.decode(type.self, from: data)
        } catch {
            return nil
        }
    }
}
