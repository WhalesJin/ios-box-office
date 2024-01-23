//
//  BoxOfficeManagerTests.swift
//  DecodingManagerTests
//
//  Created by Dasan on 2024/01/09.
//

import XCTest
@testable import BoxOffice

//MockSuccessNetworkManager으로 테스트하는 것과 Requester 테스트하는 것의 차이

final class BoxOfficeManagerTests: XCTestCase {
    private var boxOfficeManager: BoxOfficeManager!
    
    func testFetchBoxOfficeData() {
        let dataAsset: NSDataAsset = NSDataAsset(name: "box_office_sample")!

        let networkManager = NetworkManager(requester: SuccessRequester(data: dataAsset.data))
        //let networkManager = MockSuccessNetworkManager(data: dataAsset.data)
        //let networkManager = MockSuccessNetworkManager(requester: SuccessRequester(data: dataAsset.data)
        boxOfficeManager = BoxOfficeManager(networkManager: networkManager)

        let expectation = "경관의 피"
        
        boxOfficeManager.fetchBoxOfficeData(with: TargetDate(dayFromNow: 0)) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data!.first?.movieName, expectation)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testFetchBoxOfficeDataFailure() {
        let dataAsset: NSDataAsset = NSDataAsset(name: "movie_Info_sample")! //다른 타입의 JSON
        let networkManager = NetworkManager(requester: SuccessRequester(data: dataAsset.data))
        boxOfficeManager = BoxOfficeManager(networkManager: networkManager)

        boxOfficeManager.fetchBoxOfficeData(with: TargetDate(dayFromNow: 0)) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error as! DataError, DataError.failedDecoding)
            }
        }
    }
    
    func testFetchMovieData() {
        let dataAsset: NSDataAsset = NSDataAsset(name: "movie_Info_sample")!
        let networkManager = NetworkManager(requester: SuccessRequester(data: dataAsset.data))
        boxOfficeManager = BoxOfficeManager(networkManager: networkManager)

        let expectation = "이병헌"

        boxOfficeManager.fetchMovieData(with: "123456"){ result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data!.actors.first?.personName, expectation)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testFetchMovieDataFailure() {
        let dataAsset: NSDataAsset = NSDataAsset(name: "box_office_sample")!
        let networkManager = NetworkManager(requester: SuccessRequester(data: dataAsset.data))
        boxOfficeManager = BoxOfficeManager(networkManager: networkManager)

        boxOfficeManager.fetchMovieData(with: "movieCode") { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error as! DataError, DataError.failedDecoding)
            }
        }
    }

    func testFetchMovieImageData() {
        //let expectation = XCTestExpectation(description: "fetchMovieImage")
        let dataAsset: NSDataAsset = NSDataAsset(name: "movie_image_sample")!
        let image = UIImage(named: "movie_sample_image")
        let imageData: Data = image!.jpegData(compressionQuality: 1)!
        
        let networkManager = NetworkManager(requester: SuccessRequester(data: dataAsset.data))
        boxOfficeManager = BoxOfficeManager(networkManager: networkManager,
                                            imageManager: ImageManager(networkManager: NetworkManager(requester: SuccessRequester(data: imageData)))
                                            )
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
        let dataAsset: NSDataAsset = NSDataAsset(name: "box_office_sample")!
        //let dataAsset: NSDataAsset = NSDataAsset(name: "movie_image_sample")!
        
        let networkManager = NetworkManager(requester: SuccessRequester(data: dataAsset.data))
        boxOfficeManager = BoxOfficeManager(networkManager: networkManager)
        
        boxOfficeManager.fetchMovieImageData(with: "keyword") { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error as! DataError, DataError.failedDecoding)
            }
        }
    }
}
