//
//  BoxOfficeManagerTests.swift
//  DecodingManagerTests
//
//  Created by Dasan on 2024/01/09.
//

import XCTest
@testable import BoxOffice

final class BoxOfficeManagerTests: XCTestCase {
    private var boxOfficeManager: StubBoxOfficeManager!
    
    func testFetchBoxOfficeData() {
        let dataAsset: NSDataAsset = NSDataAsset(name: "box_office_sample")!
        let networkManager = MockSuccessNetworkManager(requester: SuccessRequester(data: dataAsset.data))
        boxOfficeManager = StubBoxOfficeManager(networkManager: networkManager)
        
        let expectation = "경관의 피"
        
        boxOfficeManager.fetchBoxOfficeData(with: "targetDate") { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data!.first?.movieName, expectation)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testFetchBoxOfficeDataFailure() {
        let networkManager = MockFailureNetworkManager(error: .noData)
        boxOfficeManager = StubBoxOfficeManager(networkManager: networkManager)

        boxOfficeManager.fetchBoxOfficeData(with: "targetDate") { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error as! NetworkError, NetworkError.noData)
            }
        }
    }
    
    func testFetchMovieData() {
        let dataAsset: NSDataAsset = NSDataAsset(name: "movie_Info_sample")!
        let networkManager = MockSuccessNetworkManager(requester: SuccessRequester(data: dataAsset.data))
        boxOfficeManager = StubBoxOfficeManager(networkManager: networkManager)

        let expectation = "이병헌"
        
        boxOfficeManager.fetchMovieData(with: "movieCode") { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data!.actors.first?.personName, expectation)
            case .failure:
                XCTFail()
            }
        }
    }

    func testFetchMovieDataFailure() {
        let networkManager = MockFailureNetworkManager(error: .noData)
        boxOfficeManager = StubBoxOfficeManager(networkManager: networkManager)

        boxOfficeManager.fetchMovieData(with: "movieCode") { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error as! NetworkError, NetworkError.noData)
            }
        }
    }

    func testFetchMovieImageData() {
        let dataAsset: NSDataAsset = NSDataAsset(name: "movie_image_sample")!
        let networkManager = MockSuccessNetworkManager(requester: SuccessRequester(data: dataAsset.data))
        boxOfficeManager = StubBoxOfficeManager(networkManager: networkManager)

        boxOfficeManager.fetchMovieImageData(with: "keyword") { result in
            switch result {
            case .success(let image):
                XCTAssertNotNil(image)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testFetchMovieImageDataFailure() {
        let networkManager = MockFailureNetworkManager(error: .noData)
        boxOfficeManager = StubBoxOfficeManager(networkManager: networkManager)
        
        boxOfficeManager.fetchMovieImageData(with: "keyword") { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error as! NetworkError, NetworkError.noData)
            }
        }
    }
}
