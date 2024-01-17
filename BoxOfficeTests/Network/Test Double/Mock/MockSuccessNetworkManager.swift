//
//  MockSuccessNetworkManager.swift
//  DecodingManagerTests
//
//  Created by Dasan on 2024/01/09.
//

import XCTest
@testable import BoxOffice

final class MockSuccessNetworkManager: NetworkManageable {
    var requester: Requestable
    
    private var url: URL?
    private var method: HTTPMethod?
    private var header: [HTTPHeader]?
    private var callCount: Int = 0
    
    private var data: Data
    private var delay: DispatchTime
    
    init(data: Data = Data(), delay: DispatchTime = .now(), requester: Requestable = DummyRequester()) {
        self.requester = requester
        self.data = data
        self.delay = delay
    }
    
    func fetchData(from url: URL?, method: HTTPMethod, header: [HTTPHeader]?, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        self.url = url
        self.method = method
        self.header = header
        self.callCount += 1
        
        DispatchQueue.global().asyncAfter(deadline: delay) {
            completion(.success(self.data))
        }
        
        return nil
    }
    
    func verify(url: URL?, method: HTTPMethod, header: [HTTPHeader]?, callCount: Int = 1) {
        XCTAssertEqual(self.url, url)
        XCTAssertEqual(self.method, method)
        XCTAssertEqual(self.header, header)
        XCTAssertEqual(self.callCount, callCount)
    }
}
