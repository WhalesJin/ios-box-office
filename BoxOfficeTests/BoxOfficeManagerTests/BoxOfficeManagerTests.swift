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
        let expectation = XCTestExpectation(description: "fetchBoxOfficeData")
        let dataAsset: NSDataAsset = NSDataAsset(name: "BoxOffice_JSON_sample")!

        let networkManager = NetworkManager(requester: SuccessRequester(data: dataAsset.data))
        //let networkManager = MockSuccessNetworkManager(data: dataAsset.data)
        boxOfficeManager = BoxOfficeManager(networkManager: networkManager)

        let expectationMovieName = "경관의 피"
        
        boxOfficeManager.fetchDailyBoxOfficeList(with: TargetDate(dayFromNow: 0)) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data.first?.movieName, expectationMovieName)
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testFetchBoxOfficeDataFailure() {
        let expectation = XCTestExpectation(description: "fetchBoxOfficeDataFailure")
        let dataAsset: NSDataAsset = NSDataAsset(name: "Movie_JSON_sample")! //다른 타입의 JSON
        let networkManager = NetworkManager(requester: SuccessRequester(data: dataAsset.data))
        //let networkManager = MockSuccessNetworkManager(data: dataAsset.data)
        boxOfficeManager = BoxOfficeManager(networkManager: networkManager)

        boxOfficeManager.fetchDailyBoxOfficeList(with: TargetDate(dayFromNow: 0)) { result in
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
        let dataAsset: NSDataAsset = NSDataAsset(name: "Movie_JSON_sample")!
        let networkManager = NetworkManager(requester: SuccessRequester(data: dataAsset.data))
        //let networkManager = MockSuccessNetworkManager(data: dataAsset.data)
        boxOfficeManager = BoxOfficeManager(networkManager: networkManager)

        let expectationPersonName = "이병헌"

        boxOfficeManager.fetchMovieData(with: "123456"){ result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data.actors.first?.personName, expectationPersonName)
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testFetchMovieDataFailure() {
        let expectation = XCTestExpectation(description: "fetchMovieDataFailure")
        let dataAsset: NSDataAsset = NSDataAsset(name: "BoxOffice_JSON_sample")!
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
        let dataAsset: NSDataAsset = NSDataAsset(name: "MovieImage_JSON_sample")!
        let networkManager = NetworkManager(requester: SuccessRequester(data: dataAsset.data))
        //let networkManager = MockSuccessNetworkManager(data: dataAsset.data)
        boxOfficeManager = BoxOfficeManager(networkManager: networkManager)

        let expectationImageURL = URL(string: "https://www.imageUrl.com")

        boxOfficeManager.fetchMovieImageUrl(with: "keyword") { result in
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
        let dataAsset: NSDataAsset = NSDataAsset(name: "BoxOffice_JSON_sample")!
        let networkManager = NetworkManager(requester: SuccessRequester(data: dataAsset.data))
        //let networkManager = MockSuccessNetworkManager(data: dataAsset.data)
        boxOfficeManager = BoxOfficeManager(networkManager: networkManager)
        
        boxOfficeManager.fetchMovieImageUrl(with: "keyword") { result in
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
    
    // 결과값이 1개일 때
    func testFetchKoreaFilmFirstMovieData_결과값이1개일때() {
        let expectation = XCTestExpectation(description: "fetchKoreaFilmFirstMovieData_result1")
        let dataAsset: NSDataAsset = NSDataAsset(name: "KMDbMovieData_JSON_sample")!
        let networkManager = NetworkManager(requester: SuccessRequester(data: dataAsset.data))
        //let networkManager = MockSuccessNetworkManager(data: dataAsset.data)
        boxOfficeManager = BoxOfficeManager(networkManager: networkManager)

        let expectationImageURL = URL(string: "http://file.koreafilm.or.kr/thm/02/00/03/19/tn_DPF010393.JPG")
        let expectationPlot = "“우린 답을 찾을 거야, 늘 그랬듯이”세계 각국의 정부와 경제가 완전히 붕괴된 미래가 다가온다.  지난 20세기에 범한 잘못이 전 세계적인 식량 부족을 불러왔고, NASA도 해체되었다.  이때 시공간에 불가사의한 틈이 열리고, 남은 자들에게는 이 곳을 탐험해 인류를 구해야 하는 임무가 지워진다.  사랑하는 가족들을 뒤로 한 채 인류라는 더 큰 가족을 위해, 그들은 이제 희망을 찾아 우주로 간다.  그리고 우린 답을 찾을 것이다. 늘 그랬듯이…"

        boxOfficeManager.fetchKoreaFilmFirstMovieData(with: ("title", "englishTitle")) { result in
            switch result {
            case .success(let data):
                if let movieUrl = data.url,
                   let moviePlot = data.plot
                {
                    XCTAssertEqual(movieUrl, expectationImageURL)
                    XCTAssertEqual(moviePlot, expectationPlot)
                    expectation.fulfill()
                }
            case .failure:
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    // 결과값이 2개 이상일 때
    func testFetchKoreaFilmFirstMovieData_결과값이2개이상일때() {
        let expectation = XCTestExpectation(description: "fetchKoreaFilmFirstMovieData_result2")
        let dataAsset: NSDataAsset = NSDataAsset(name: "KMDbMovieData_JSON_sample2")!
        let networkManager = NetworkManager(requester: SuccessRequester(data: dataAsset.data))
        //let networkManager = MockSuccessNetworkManager(data: dataAsset.data)
        boxOfficeManager = BoxOfficeManager(networkManager: networkManager)

        let expectationImageURL = URL(string: "http://file.koreafilm.or.kr/thm/02/99/17/75/tn_DPF025632.jpg")
        let expectationPlot = "귀살대에 입대한 탄지로는 매일 소녀가 실종된다고 하는 마을로 향한다.혈귀의 냄새는 나지만 그 모습을 찾을 수 없는 가운데, 새로운 소녀에게 혈귀의 손이 다가온다.그다음으로 탄지로가 방문한 곳은 아사쿠사.화려한 도시와 즐비한 상점에 당황하는 탄지로는 그곳에서 혈귀의 냄새를 찾아낸다.그 냄새는 인간을 혈귀로 바꿀 수 있는 유일한 존재이자 탄지로의 숙적이기도 한 키부츠지 무잔의 것이었다.이윽고 탄지로의 앞에 타마요와 유시로가 나타나는데…"
        
        boxOfficeManager.fetchKoreaFilmFirstMovieData(with: ("title", "englishTitle")) { result in
            switch result {
            case .success(let data):
                if let movieUrl = data.url,
                   let moviePlot = data.plot
                {
                    XCTAssertEqual(movieUrl, expectationImageURL)
                    XCTAssertEqual(moviePlot, expectationPlot)
                    expectation.fulfill()
                }
            case .failure:
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    
    func testFetchKoreaFilmFirstMovieDataFailure() {
        let expectation = XCTestExpectation(description: "fetchKoreaFilmFirstMovieDataFailure")
        let dataAsset: NSDataAsset = NSDataAsset(name: "BoxOffice_JSON_sample")!
        let networkManager = NetworkManager(requester: SuccessRequester(data: dataAsset.data))
        //let networkManager = MockSuccessNetworkManager(data: dataAsset.data)
        boxOfficeManager = BoxOfficeManager(networkManager: networkManager)
        
        boxOfficeManager.fetchKoreaFilmFirstMovieData(with: ("title", "englishTitle")) { result in
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
    
    func testFetchKoreaFilmSecondMovieData() {
        let expectation = XCTestExpectation(description: "fetchKoreaFilmSecondMovieData")
        let dataAsset: NSDataAsset = NSDataAsset(name: "KMDbMovieData_JSON_sample2")!
        let networkManager = NetworkManager(requester: SuccessRequester(data: dataAsset.data))
        //let networkManager = MockSuccessNetworkManager(data: dataAsset.data)
        boxOfficeManager = BoxOfficeManager(networkManager: networkManager)

        let expectationImageURL = URL(string: "http://file.koreafilm.or.kr/thm/02/99/17/75/tn_DPF025632.jpg")
        let expectationPlot = "귀살대에 입대한 탄지로는 매일 소녀가 실종된다고 하는 마을로 향한다.혈귀의 냄새는 나지만 그 모습을 찾을 수 없는 가운데, 새로운 소녀에게 혈귀의 손이 다가온다.그다음으로 탄지로가 방문한 곳은 아사쿠사.화려한 도시와 즐비한 상점에 당황하는 탄지로는 그곳에서 혈귀의 냄새를 찾아낸다.그 냄새는 인간을 혈귀로 바꿀 수 있는 유일한 존재이자 탄지로의 숙적이기도 한 키부츠지 무잔의 것이었다.이윽고 탄지로의 앞에 타마요와 유시로가 나타나는데…"

        boxOfficeManager.fetchKoreaFilmFirstMovieData(with: ("title", "englishTitle")) { result in
            switch result {
            case .success(let data):
                if let movieUrl = data.url,
                   let moviePlot = data.plot
                {
                    XCTAssertEqual(movieUrl, expectationImageURL)
                    XCTAssertEqual(moviePlot, expectationPlot)
                    expectation.fulfill()
                }
            case .failure:
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testFetchKoreaFilmSecondMovieDataFailure() {
        let expectation = XCTestExpectation(description: "fetchKoreaFilmSecondMovieDataFailure")
        let dataAsset: NSDataAsset = NSDataAsset(name: "BoxOffice_JSON_sample")!
        let networkManager = NetworkManager(requester: SuccessRequester(data: dataAsset.data))
        //let networkManager = MockSuccessNetworkManager(data: dataAsset.data)
        boxOfficeManager = BoxOfficeManager(networkManager: networkManager)
        
        boxOfficeManager.fetchKoreaFilmFirstMovieData(with: ("title", "englishTitle")) { result in
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
