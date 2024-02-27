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
    private let cacheManager = CacheManager<AnyObject>()
    var boxOfficeItems: [BoxOfficeItem] = []
    
    init(networkManager: NetworkManageable = NetworkManager(requester: DefaultRequester())) {
        self.networkManager = networkManager
        self.imageManager = ImageManager(networkManager: networkManager)
    }
    
    func fetchBoxOfficeItems(targetDate: TargetDate, completion: @escaping (Result<[BoxOfficeItem], Error>) -> Void) {
        fetchDailyBoxOfficeList(with: targetDate) { [self] dailyBoxOfficeListResult in
            switch dailyBoxOfficeListResult {
            case .success(let dailyBoxOfficeList):
                for movie in dailyBoxOfficeList {
                    if let cachedMovie = cacheManager.read(key: movie.movieCode) as? BoxOfficeItem {
                        print("\(cachedMovie.movieInformation.movieName) 캐시에 존재함")
                        continue
                    } else {
                        fetchMovieData(with: movie.movieCode) { [self] movieResult in
                            switch movieResult {
                            case .success(let movieInformation):
                                fetchKoreaFilmMovieData(with: (movieInformation.movieName, movieInformation.movieEnglishName)) { [self] imageDataResult in
                                    switch imageDataResult {
                                    case .success(let (imageUrl, plot)):
                                        if let imageUrl { // Url이 nil이 아닐 때
                                            imageManager.fetchImage(url: imageUrl) { [self] imageResult in
                                                switch imageResult {
                                                case .success(let posterImage):
                                                    if appendAndCheckSize(movieCode: movie.movieCode,
                                                                          boxOfficeData: movie,
                                                                          movieInformation: movieInformation,
                                                                          plot: plot,
                                                                          imageUrl: imageUrl,
                                                                          posterImage: posterImage ?? UIImage(named: "default_image")!
                                                    ) {
                                                        completion(.success(boxOfficeItems))
                                                    }
                                                case .failure(let error):
                                                    completion(.failure(error))
                                                }
                                            }
                                        } else { // Url이 nil일 때
                                            if appendAndCheckSize(movieCode: movie.movieCode,
                                                                  boxOfficeData: movie,
                                                                  movieInformation: movieInformation,
                                                                  plot: plot,
                                                                  imageUrl: URL(string: ""),
                                                                  posterImage: UIImage(named: "default_image")!
                                            ) {
                                                completion(.success(boxOfficeItems))
                                            }
                                        }
                                    case .failure(let error):
                                        completion(.failure(error))
                                    }
                                }
                            case .failure(let error):
                                completion(.failure(error))
                            }
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
    
    // MARK: Koreafilm에서 필요한 영화 정보 가져오기(줄거리, 영화포스터 URL)
    func fetchKoreaFilmMovieData(with keyword: (String, String), completion: @escaping (Result<(url: URL?, plot: String?), Error>) -> Void) {
        let koreaFilmAPI = KoreaFilmAPI.movie(title: keyword.0, englishTitle: keyword.0.count < 15 ? keyword.1 : "")
        
        let _ = networkManager.fetchData(from: koreaFilmAPI.url,
                                 method: .get,
                                 header: nil) { result in
            do {
                let decodedData = try DecodingManager.decodeJSON(type: KMDbMovieData.self, data: result.get())
                var movieData = decodedData.data.first
                
                movieData?.result.sort(by: { a, b in
                    a.productionYear > b.productionYear
                })
                
                if let movieResult = movieData?.result.first {
                    let movieImageUrlString = movieResult.posterUrls.split(separator: "|").first
                    let movieImageUrl = URL(string: String(movieImageUrlString ?? ""))
                    let moviePlotText = movieResult.plots.plot.first?.plotText
                    
                    completion(.success((movieImageUrl, moviePlotText)))
                } else {
                    completion(.failure(DataError.noData))
                }
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
    
    private func appendAndCheckSize(movieCode: String, boxOfficeData: BoxOfficeData, movieInformation: MovieInformation, plot: String?, imageUrl: URL?, posterImage: UIImage) -> Bool {
        let boxOfficeItem = BoxOfficeItem(movieCode: movieCode,
                                          boxOfficeData: boxOfficeData,
                                          movieInformation: movieInformation,
                                          plot: plot ?? "-",
                                          imageUrl: imageUrl,
                                          posterImage: posterImage)
        
        cacheManager.insert(movieCode, boxOfficeItem)
        boxOfficeItems.append(boxOfficeItem)
        
        if boxOfficeItems.count == 10 { // 10개 채워졌을 때만 넘겨주기
            boxOfficeItems.sort { a, b in Int(a.boxOfficeData.rank) ?? 0 < Int(b.boxOfficeData.rank) ?? 0 }
            return true
        }
        return false
    }
}
