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
    var boxOfficeItems: [BoxOfficeItem] = []
    
    init(networkManager: NetworkManageable = NetworkManager(requester: DefaultRequester())) {
        self.networkManager = networkManager
        self.imageManager = ImageManager(networkManager: networkManager)
    }
    
    private func appendAndCheckSize(movieCode: String, boxOfficeData: BoxOfficeData, movieInformation: MovieInformation, imageUrl: URL?, posterImage: UIImage) -> Bool {
        boxOfficeItems.append(BoxOfficeItem(movieCode: movieCode,
                                            boxOfficeData: boxOfficeData,
                                            movieInformation: movieInformation,
                                            imageUrl: imageUrl,
                                            posterImage: posterImage))
        if boxOfficeItems.count == 10 { // 10개 채워졌을 때만 넘겨주기
            boxOfficeItems.sort { a, b in Int(a.boxOfficeData.rank) ?? 0 < Int(b.boxOfficeData.rank) ?? 0 }
            return true
        }
        return false
    }
    
    func fetchBoxOfficeItems(targetDate: TargetDate, completion: @escaping (Result<[BoxOfficeItem], Error>) -> Void) {
        fetchDailyBoxOfficeList(with: targetDate) { [self] dailyBoxOfficeListResult in
            switch dailyBoxOfficeListResult {
            case .success(let dailyBoxOfficeList):
                for movie in dailyBoxOfficeList {
                    fetchMovieData(with: movie.movieCode) { [self] movieResult in
                        switch movieResult {
                        case .success(let movieInformation):
                            fetchMovieImageUrl(with: (movieInformation.movieName, movieInformation.movieEnglishName)) { [self] imageDataResult in
                                switch imageDataResult {
                                case .success(let imageUrl):
                                    if let imageUrl {
                                        imageManager.fetchImage(url: imageUrl) { [self] imageResult in
                                            switch imageResult {
                                            case .success(let posterImage):
                                                if let posterImage,
                                                   appendAndCheckSize(movieCode: movie.movieCode,
                                                                      boxOfficeData: movie,
                                                                      movieInformation: movieInformation,
                                                                      imageUrl: imageUrl,
                                                                      posterImage: posterImage) {
                                                    completion(.success(boxOfficeItems))
                                                }
                                            case .failure(let error):
                                                completion(.failure(error))
                                            }
                                        }
                                    }
                                    else {
                                        completion(.failure(DataError.noData))
                                    }
                                case .failure(_):
                                    if appendAndCheckSize(movieCode: movie.movieCode,
                                                          boxOfficeData: movie,
                                                          movieInformation: movieInformation,
                                                          imageUrl: URL(string: ""),
                                                          posterImage: UIImage(named: "default_image")!) {
                                        completion(.success(boxOfficeItems))
                                    }
                                }
                            }
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchDailyBoxOfficeList(with targetDate: TargetDate, completion: @escaping (Result<[BoxOfficeData], Error>) -> Void) {
        let _ = networkManager.fetchData(from: KobisAPI.boxOffice(targetDate: targetDate.formattedWithoutSeparator()).url,
                                 method: .get,
                                 header: nil) { result in
            do {
                let decodedData = try DecodingManager.decodeJSON(type: BoxOffice.self, data: result.get())
                let dailyBoxOfficeList = decodedData.boxOfficeResult.dailyBoxOfficeList
                
                completion(.success(dailyBoxOfficeList))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func fetchMovieData(with movieCode: String, completion: @escaping (Result<MovieInformation, Error>) -> Void) {
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
    
    // MARK: 영화포스터 이미지 가져오기 - Kakao 검색 API 사용
    func fetchMovieImageUrl(with keyword: String, completion: @escaping (Result<URL?, Error>) -> Void) {
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
    
    // MARK: 영화포스터 이미지 가져오기 - Koreafilm API 사용
    func fetchMovieImageUrl(with keyword: (String, String), completion: @escaping (Result<URL?, Error>) -> Void) {
        let koreafilmAPI = KoreafilmAPI.movie(title: keyword.0, englishTitle: keyword.0.count < 15 ? keyword.1 : "")
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
                } else {
                    completion(.failure(DataError.noData))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
}
