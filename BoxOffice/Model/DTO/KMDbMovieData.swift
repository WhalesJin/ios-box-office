//
//  KMDbMovieData.swift
//  BoxOffice
//
//  Created by Dasan on 2024/01/31.
//

struct KMDbMovieData: Decodable {
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
    let kmdbUrl: String
    let posterUrls: String
    let productionYear: String
    let plots: Plots
    
    private enum CodingKeys: String, CodingKey {
        case title
        case kmdbUrl
        case posterUrls = "posters"
        case productionYear = "prodYear"
        case plots
    }
}

struct Plots: Decodable {
    let plot: [Plot]
}

struct Plot: Decodable {
    let plotText: String
}
