//
//  BoxOfficeManager.swift
//  BoxOffice
//
//  Created by Dasan & Whales on 2023/08/07.
//

import UIKit

final class BoxOfficeManager {
    private let networkManager: NetworkManageable
    private let imageManager: ImageManager
    //let imageManager = ImageManager(networkManager: networkManager)
    
    init(
        networkManager: NetworkManageable = NetworkManager(requester: DefaultRequester()),
        imageManager: ImageManager = ImageManager()
    ) {
        self.networkManager = networkManager
        self.imageManager = imageManager
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
    }
    
    func fetchMovieImageData(with keyword: String, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        //let imageManager = ImageManager(networkManager: networkManager)
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

                self.imageManager.fetchImage(url: movieImageURL) { result in
                    guard let image = try? result.get() else { return }
                    completion(.success(image))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
}
