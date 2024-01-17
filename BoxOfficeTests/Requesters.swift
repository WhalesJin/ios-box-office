//
//  Requesters.swift
//  DecodingManagerTests
//
//  Created by Dasan on 2024/01/12.
//

import XCTest
@testable import BoxOffice

final class SuccessRequester: Requestable {
    private let data: Data
    
    init(data: Data = Data()) {
        self.data = data
    }
    
    func dataTask(with urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(
            data,
            HTTPURLResponse(url: urlRequest.url!,
                            statusCode: 200,
                            httpVersion: nil,
                            headerFields: nil),
            nil)
        return URLSession.shared.dataTask(with: urlRequest)
    }
}

final class RequestFailedRequester: Requestable {
    func dataTask(with urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(nil, nil, NetworkError.requestFailed)
        return URLSession.shared.dataTask(with: urlRequest)
    }
}

final class InvalidResponseRequester: Requestable {
    func dataTask(with urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(nil, URLResponse(), nil) // HTTPURLResponse 이면 에러 안남
        return URLSession.shared.dataTask(with: urlRequest)
    }
}

final class InvalidStateCodeRequester: Requestable {
    func dataTask(with urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(nil,
                          HTTPURLResponse(
                            url: urlRequest.url!,
                            statusCode: 400,
                            httpVersion: nil,
                            headerFields: nil),
                          nil)
        return URLSession.shared.dataTask(with: urlRequest)
    }
}

final class NoDataRequester: Requestable {
    func dataTask(with urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(nil,
                          HTTPURLResponse(
                            url: urlRequest.url!,
                            statusCode: 200,
                            httpVersion: nil,
                            headerFields: nil),
                          nil)
        return URLSession.shared.dataTask(with: urlRequest)
    }
}
