//
//  NetworkManager.swift
//  BoxOffice
//
//  Created by Dasan & Whales on 2023/07/27.
//

import UIKit

final class NetworkManager: NetworkManageable {
    var requester: Requestable
    
    init(requester: Requestable = DefaultRequester()) {
        self.requester = requester
    }
    
    @discardableResult
    func fetchData(from url: URL?, method: HTTPMethod, header: [HTTPHeader]?, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        guard let urlRequest = makeURLRequest(url: url, method: method, headers: header) else {
            completion(.failure(.invalidURL))
            return nil
        }
        
        let dataTask = requester.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(.failure(NetworkError.requestFailed))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.invalidResponse))
                
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                
                return
            }
            
            completion(.success(data))
        }
        
        dataTask.resume()
        
        return dataTask
    }
    
    private func makeURLRequest(url: URL?, method: HTTPMethod, headers: [HTTPHeader]?) -> URLRequest? {
        guard let url = url else { return nil }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        headers?.forEach {
            $0.header.forEach { field, value in
                urlRequest.addValue(value, forHTTPHeaderField: field)
            }
        }
        return urlRequest
    }
}

final class DefaultRequester: Requestable {
    func dataTask(with urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: urlRequest, completionHandler: completionHandler)
    }
}
