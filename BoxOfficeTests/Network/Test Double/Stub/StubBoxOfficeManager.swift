//
//  StubBoxOfficeManager.swift
//  DecodingManagerTests
//
//  Created by Dasan on 2024/01/12.
//

import XCTest
@testable import BoxOffice

final class StubBoxOfficeManager {
    private var networkManager: NetworkManageable
    
    init(networkManager: NetworkManageable) {
        self.networkManager = networkManager
    }
    
    func fetchBoxOfficeData(with targetDate: String, completion: @escaping (Result<[BoxOfficeData]?, Error>) -> Void) {
        
        let _ = networkManager.fetchData(from: URL(string: "boxOfficeURL"),
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
        let _ = networkManager.fetchData(from: URL(string: "movieURL"),
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
        let imageManager = ImageManager(networkManager: networkManager)
        var movieImageURLString: String?
        
        let _ = networkManager.fetchData(from: URL(string: "MovieImageURL"),
                                         method: .get,
                                         header: [HTTPHeader.authorization(key: "key")]) { result in
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
    }
}
