//
//  KakaoAPI.swift
//  BoxOffice
//
//  Created by Dasan & Whales on 2023/08/12.
//

import Foundation

enum KakaoAPI {
    case image(keyword: String)
}

extension KakaoAPI: URLConfigurable {
    var baseURL: String {
        return "https://dapi.kakao.com"
    }
    
    var path: String {
        var pathString = "/v2/search/"
        
        switch self {
        case .image:
            pathString += "image"
        }
        
        return pathString
    }
    
    var queries: [URLQueryItem] {
        switch self {
        case .image(let keyword):
            return [URLQueryItem(name: "query", value: keyword)]
        }
    }
    
    var url: URL? {
        return URL(baseURL, path, queries)
    }
    
    var header: [HTTPHeader]? {
        return [.authorization(key: "KakaoAK \(Bundle.main.KAKAO_REST_API_KEY)")]
    }
    
    var urlRequest: URLRequest? {
        guard let url = URL(baseURL, path, queries) else { return nil }

        var urlRequest = URLRequest(url: url)

        urlRequest.httpMethod = "GET"
        urlRequest.addValue("KakaoAK \(Bundle.main.KAKAO_REST_API_KEY)", forHTTPHeaderField: "Authorization")

        return urlRequest
    }
}
