//
//  KoreafilmAPI.swift
//  BoxOffice
//
//  Created by Dasan on 2024/01/31.
//

import Foundation

enum KoreafilmAPI {
    case movie(title: String, englishTitle: String)
}

extension KoreafilmAPI: URLConfigurable {
    var baseURL: String {
        return "http://api.koreafilm.or.kr"
    }
    
    var path: String {
        return "/openapi-data2/wisenut/search_api/search_json2.jsp"
    }
    
    var queries: [URLQueryItem] {
        switch self {
        case .movie(let title, let englishTitle):
            return [URLQueryItem(name: "collection", value: "kmdb_new2"),
                    URLQueryItem(name: "detail", value: "Y"),
                    URLQueryItem(name: "query", value: "\(title) \(englishTitle)"),
                    URLQueryItem(name: "ServiceKey", value: Bundle.main.KMDB_REST_API_KEY)]
        }
    }
    
    var url: URL? {
        return URL(baseURL, path, queries)
    }
}
