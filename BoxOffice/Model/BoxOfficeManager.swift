//
//  BoxOfficeManager.swift
//  BoxOffice
//
//  Created by Dasan & Whales on 2023/08/07.
//

import UIKit

final class BoxOfficeManager {
    private let networkManager: NetworkManageable
    
    init(networkManager: NetworkManageable = NetworkManager(requester: DefaultRequester())) {
        self.networkManager = networkManager
    }
    
    func fetchBoxOfficeData(with targetDate: TargetDate, completion: @escaping (Result<[BoxOfficeData]?, Error>) -> Void) {
        let _ = networkManager.fetchData(from: KobisAPI.boxOffice(targetDate: targetDate.formattedWithoutSeparator()).url,
                                 method: .get,
                                 header: nil) { result in
            do {
                let decodedData = try DecodingManager.decodeJSON(type: BoxOffice.self, data: result.get())
                let boxOfficeItems = decodedData.boxOfficeResult.dailyBoxOfficeList
                
                completion(.success(boxOfficeItems))
            } catch {
                completion(.failure(error))
            }
        }
        
        //let networkManager2 = NetworkManager2()
        
//        networkManager2.fetchData(url: KobisAPI.boxOffice(targetDate: targetDate.formattedWithoutSeparator()).url) { result in
//            do {
//                guard let data = try result.get() else { return }
//                let decodedData = try DecodingManager.decodeJSON(type: BoxOffice.self, data: data)
//                let boxOfficeItems = decodedData.boxOfficeResult.dailyBoxOfficeList
//
//                completion(.success(boxOfficeItems))
//            } catch {
//                completion(.failure(error))
//            }
//        }
    }
    
    func fetchMovieData(with movieCode: String, completion: @escaping (Result<MovieInformation?, Error>) -> Void) {
        //let networkManager = NetworkManager()

        let _ = networkManager.fetchData(from: KobisAPI.movie(movieCode: movieCode).url,
                                 method: .get,
                                 header: nil) { result in
            do {
                let decodedData = try DecodingManager.decodeJSON(type: Movie.self, data: result.get())
                let movieInformation = decodedData.movieInformationResult.movieInformation

                completion(.success(movieInformation))
            } catch {
                completion(.failure(error))
            }
        }
        
//        let networkManager2 = NetworkManager2()
//
//        networkManager2.fetchData(url: KobisAPI.movie(movieCode: movieCode).url) { result in
//            do {
//                guard let data = try result.get() else { return }
//                let decodedData = try DecodingManager.decodeJSON(type: Movie.self, data: data)
//                let movieInformation = decodedData.movieInformationResult.movieInformation
//
//                completion(.success(movieInformation))
//            } catch {
//                completion(.failure(error))
//            }
//        }
    }
    
    func fetchMovieImageData(with keyword: String, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        let imageManager = ImageManager(networkManager: networkManager)
        var movieImageURLString: String?

        let kakaoAPI = KakaoAPI.image(keyword: keyword)
        let _ = networkManager.fetchData(from: kakaoAPI.url,
                                 method: .get,
                                 header: kakaoAPI.header) { result in
            do {
                let decodedData = try DecodingManager.decodeJSON(type: MovieImage.self, data: result.get())
                let movieImageItems = decodedData.documents

                movieImageURLString = movieImageItems.first?.imageURL

                guard let movieImageURLString = movieImageURLString,
                      let movieImageURL = URL(string: movieImageURLString) else { return }

                imageManager.fetchImage(url: movieImageURL) { result in
                    guard let image = try? result.get() else { return }
                    completion(.success(image))
                }
            } catch {
                completion(.failure(error))
            }
        }

//        let networkManager = NetworkManager2()
//
//        networkManager.fetchData(urlRequest: KakaoAPI.image(keyword: keyword).urlRequest) { result in
//            do {
//                guard let data = try result.get() else { return }
//                let decodedData = try DecodingManager.decodeJSON(type: MovieImage.self, data: data)
//                let movieImageItems = decodedData.documents
//
//                movieImageURLString = movieImageItems.first?.imageURL
//
//                guard let movieImageURLString = movieImageURLString,
//                      let movieImageURL = URL(string: movieImageURLString) else { return }
//
//                networkManager.fetchImage(url: movieImageURL) { result in
//                    guard let image = try? result.get() else { return }
//
//                    completion(.success(image))
//                }
//            } catch {
//                completion(.failure(error))
//            }
//        }
    }
}
