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

struct NetworkManager2 {
    func fetchData(url: URL?, completion: @escaping (Result<Data?, NetworkError>) -> Void) {
        guard let url = url else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
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
        
        task.resume()
        // Task가 완료 후 completion handler가 실행된다.
    }
    
    func fetchData(urlRequest: URLRequest?, completion: @escaping (Result<Data?, NetworkError>) -> Void) {
        guard let urlRequest = urlRequest else { return }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if error != nil {
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
        
        task.resume()
    }
    
    func fetchImage(url: URL?, completion: @escaping (Result<UIImage?, NetworkError>) -> Void) {
        fetchData(url: url) { result in
            switch result {
            case .success(let data):
                guard let data = data,
                      let image = UIImage(data: data) else { return }
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
