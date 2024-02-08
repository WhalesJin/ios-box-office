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
    }
    
    func fetchMovieData(with movieCode: String, completion: @escaping (Result<MovieInformation?, Error>) -> Void) {
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
    
    func fetchMovieImageData(with keyword: String, completion: @escaping (Result<URL?, Error>) -> Void) {
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

                completion(.success(movieImageURL))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func fetchMovieImageData2(with keyword: (String, String), completion: @escaping (Result<URL?, Error>) -> Void) {
        let koreafilmAPI = KoreafilmAPI.movie(title: keyword.0, englishTitle: keyword.1)
        let _ = networkManager.fetchData(from: koreafilmAPI.url,
                                 method: .get,
                                 header: nil) { result in
            do {
                let decodedData = try DecodingManager.decodeJSON(type: KMDbMovieImage.self, data: result.get())
                var movieData = decodedData.data.first
                
                movieData?.result.sort(by: { a, b in
                    a.productionYear > b.productionYear
                })
                
                if let movieResult = movieData?.result,
                   let moviePosterURLs = movieResult.first?.posters,
                   let movieImageURLString = moviePosterURLs.split(separator: "|").first,
                   let movieImageURL = URL(string: String(movieImageURLString)) {
                    completion(.success(movieImageURL))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func fetchMovieImageData3(with keyword: String, completion: @escaping (Result<URL?, Error>) -> Void) {
        let koreafilmAPI = KoreafilmAPI.movie(title: keyword, englishTitle: nil)
        let _ = networkManager.fetchData(from: koreafilmAPI.url,
                                 method: .get,
                                 header: nil) { result in
            do {
                let decodedData = try DecodingManager.decodeJSON(type: KMDbMovieImage.self, data: result.get())
                var movieData = decodedData.data.first
                
                movieData?.result.sort(by: { a, b in
                    a.productionYear > b.productionYear
                })
                
                var movieImageURL: URL? = nil
                if let movieResult = movieData?.result,
                   let moviePosterURLs = movieResult.first?.posters,
                   let movieImageURLString = moviePosterURLs.split(separator: "|").first,
                   let validURL = URL(string: String(movieImageURLString)) {
                    movieImageURL = validURL
                }
                completion(.success(movieImageURL))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
