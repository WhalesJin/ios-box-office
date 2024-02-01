//
//  BoxOfficeManagerTests.swift
//  DecodingManagerTests
//
//  Created by Dasan on 2024/01/09.
//

import XCTest
@testable import BoxOffice

final class BoxOfficeManagerTests: XCTestCase {
    private var boxOfficeManager: BoxOfficeManager!
    
    func testFetchBoxOfficeData() {
        let expectation = XCTestExpectation(description: "fetchBoxOffice")
        let dataAsset: NSDataAsset = NSDataAsset(name: "box_office_sample")!

        let networkManager = NetworkManager(requester: SuccessRequester(data: dataAsset.data))
        //let networkManager = MockSuccessNetworkManager(data: dataAsset.data)
        boxOfficeManager = BoxOfficeManager(networkManager: networkManager)

        let expectationMovieName = "경관의 피"
        
        boxOfficeManager.fetchBoxOfficeData(with: TargetDate(dayFromNow: 0)) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data!.first?.movieName, expectationMovieName)
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testFetchBoxOfficeDataFailure() {
        let expectation = XCTestExpectation(description: "fetchBoxOfficeFailure")
        let dataAsset: NSDataAsset = NSDataAsset(name: "movie_Info_sample")! //다른 타입의 JSON
        let networkManager = NetworkManager(requester: SuccessRequester(data: dataAsset.data))
        //let networkManager = MockSuccessNetworkManager(data: dataAsset.data)
        boxOfficeManager = BoxOfficeManager(networkManager: networkManager)

        boxOfficeManager.fetchBoxOfficeData(with: TargetDate(dayFromNow: 0)) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error as! DataError, DataError.failedDecoding)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testFetchMovieData() {
        let expectation = XCTestExpectation(description: "fetchMovieData")
        let dataAsset: NSDataAsset = NSDataAsset(name: "movie_Info_sample")!
        let networkManager = NetworkManager(requester: SuccessRequester(data: dataAsset.data))
        //let networkManager = MockSuccessNetworkManager(data: dataAsset.data)
        boxOfficeManager = BoxOfficeManager(networkManager: networkManager)

        let expectationPersonName = "이병헌"

        boxOfficeManager.fetchMovieData(with: "123456"){ result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data!.actors.first?.personName, expectationPersonName)
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testFetchMovieDataFailure() {
        let expectation = XCTestExpectation(description: "fetchMovieDataFailure")
        let dataAsset: NSDataAsset = NSDataAsset(name: "box_office_sample")!
        let networkManager = NetworkManager(requester: SuccessRequester(data: dataAsset.data))
        //let networkManager = MockSuccessNetworkManager(data: dataAsset.data)
        boxOfficeManager = BoxOfficeManager(networkManager: networkManager)

        boxOfficeManager.fetchMovieData(with: "movieCode") { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error as! DataError, DataError.failedDecoding)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testFetchMovieImageData() {
        let expectation = XCTestExpectation(description: "fetchMovieImageData")
        let dataAsset: NSDataAsset = NSDataAsset(name: "movie_image_sample")!
        let networkManager = NetworkManager(requester: SuccessRequester(data: dataAsset.data))
        //let networkManager = MockSuccessNetworkManager(data: dataAsset.data)
        boxOfficeManager = BoxOfficeManager(networkManager: networkManager)

        let expectationImageURL = URL(string: "https://www.imageUrl.com")

        boxOfficeManager.fetchMovieImageData(with: "keyword") { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data!, expectationImageURL)
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testFetchMovieImageDataFailure() {
        let expectation = XCTestExpectation(description: "fetchMovieImageDataFailure")
        let dataAsset: NSDataAsset = NSDataAsset(name: "box_office_sample")!
        let networkManager = NetworkManager(requester: SuccessRequester(data: dataAsset.data))
        //let networkManager = MockSuccessNetworkManager(data: dataAsset.data)
        boxOfficeManager = BoxOfficeManager(networkManager: networkManager)
        
        boxOfficeManager.fetchMovieImageData(with: "keyword") { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error as! DataError, DataError.failedDecoding)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testFetchMovieImageData2() {
        let expectation = XCTestExpectation(description: "fetchMovieImageData2")
        let dataAsset: NSDataAsset = NSDataAsset(name: "movie_image_sample2")!
        let networkManager = NetworkManager(requester: SuccessRequester(data: dataAsset.data))
        //let networkManager = MockSuccessNetworkManager(data: dataAsset.data)
        boxOfficeManager = BoxOfficeManager(networkManager: networkManager)

        let expectationImageURL = URL(string: "http://file.koreafilm.or.kr/thm/02/00/03/19/tn_DPF010393.JPG")

        boxOfficeManager.fetchMovieImageData2(with: ("title", "englishTitle")) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data!, expectationImageURL)
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testFetchMovieImageDataFailure2() {
        let expectation = XCTestExpectation(description: "fetchMovieImageDataFailure2")
        let dataAsset: NSDataAsset = NSDataAsset(name: "box_office_sample")!
        let networkManager = NetworkManager(requester: SuccessRequester(data: dataAsset.data))
        //let networkManager = MockSuccessNetworkManager(data: dataAsset.data)
        boxOfficeManager = BoxOfficeManager(networkManager: networkManager)
        
        boxOfficeManager.fetchMovieImageData2(with: ("title", "englishTitle")) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error as! DataError, DataError.failedDecoding)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.5)
    }
}
