//
//  NetworkManagerTests.swift
//  DecodingManagerTests
//
//  Created by Dasan on 2024/01/05.
//

import XCTest
@testable import BoxOffice

final class NetworkManagerTests: XCTestCase {
    private var networkManager: NetworkManager!
    
    func testSuccess() {
        let expectation = XCTestExpectation(description: "requestSuccess")
        var resultData: Data?
        
        networkManager = NetworkManager(requester: SuccessRequester())
        networkManager.fetchData(from: URL(string: "success"),
                                 method: .get,
                                 header: nil) { result in
            switch result {
            case .success(let data):
                resultData = data
                expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(resultData)
    }
    
    func testFailureWithRequestFailed() {
        failureCase(description: "requestFailed",
                    requester: RequestFailedRequester(),
                    networkError: .requestFailed)
    }
    
    func testFailureWithInvalidResponse() {
        failureCase(description: "invalidResponse",
                    requester: InvalidResponseRequester(),
                    networkError: .invalidResponse)
    }
    
    func testFailureWithInvalidStateCode() {
        failureCase(description: "invalidResponse",
                    requester: InvalidStateCodeRequester(),
                    networkError: .invalidResponse)
    }
    
    func testFailureWithNoData() {
        failureCase(description: "noData",
                    requester: NoDataRequester(),
                    networkError: .noData)
    }
    
    func testFailureWithInvalidURL() {
        failureCase(description: "invalidURL",
                    requester: SuccessRequester(),
                    path: "",
                    networkError: .invalidURL)
    }
    
    private func failureCase(description: String, requester: Requestable, path: String = "failure", networkError: NetworkError, time: TimeInterval = 0) {
        let expectation = XCTestExpectation(description: description)
        
        networkManager = NetworkManager(requester: requester)
        networkManager.fetchData(from: URL(string: path),
                                 method: .get,
                                 header: nil) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, networkError)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
