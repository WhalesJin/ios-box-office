//
//  MockFailureNetworkManager.swift
//  DecodingManagerTests
//
//  Created by Dasan on 2024/01/09.
//

import XCTest
@testable import BoxOffice

final class MockFailureNetworkManager: NetworkManageable {
    var requester: Requestable
    
    private var url: URL?
    private var method: HTTPMethod?
    private var header: [HTTPHeader]?
    private var callCount: Int = 0
    
    private var error: NetworkError
    
    init(error: NetworkError = .noData) {
        requester = DummyRequester()
        self.error = error
    }
    
    func fetchData(from url: URL?, method: HTTPMethod, header: [HTTPHeader]?, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        self.url = url
        self.method = method
        self.header = header
        self.callCount += 1
        
        completion(.failure(error))
        
        return nil
    }
    
    func verify(url: URL?, method: HTTPMethod, header: [HTTPHeader]?, callCount: Int = 1) {
        XCTAssertEqual(self.url, url)
        XCTAssertEqual(self.method, method)
        XCTAssertEqual(self.header, header)
        XCTAssertEqual(self.callCount, callCount)
    }
}
