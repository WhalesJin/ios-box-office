//
//  ImageManager.swift
//  BoxOffice
//
//  Created by Dasan on 2024/01/09.
//

import UIKit.UIImage

final class ImageManager {
    private let networkManager: NetworkManageable
    
    init(networkManager: NetworkManageable = NetworkManager(requester: DefaultRequester())) {
        self.networkManager = networkManager
    }
    
    func fetchImage(url: URL?, completion: @escaping (Result<UIImage?, NetworkError>) -> Void) {
        let _ = networkManager.fetchData(from: url,
                                         method: .get,
                                         header: nil) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                completion(.success(image))
            case .failure(let error):
                if error == .invalidURL {
                    let defaultImage = UIImage(named: "default_image")!
                    completion(.success(defaultImage))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
}
