//
//  KMDbMovieImage.swift
//  BoxOffice
//
//  Created by Dasan on 2024/01/31.
//

struct KMDbMovieImage: Decodable {
    let data: [KMData]
    
    private enum CodingKeys: String, CodingKey {
        case data = "Data"
    }
}

struct KMData: Decodable {
    var result: [KMResult]
    
    private enum CodingKeys: String, CodingKey {
        case result = "Result"
    }
}

struct KMResult: Decodable {
    let title: String
    let kmdbURL: String
    let posters: String
    let productionYear: String
    
    private enum CodingKeys: String, CodingKey {
        case title
        case kmdbURL = "kmdbUrl"
        case posters
        case productionYear = "prodYear"
    }
}
