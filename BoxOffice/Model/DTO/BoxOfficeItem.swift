//
//  BoxOfficeItem.swift
//  BoxOffice
//
//  Created by Dasan on 2024/02/20.
//

import UIKit.UIImage

final class BoxOfficeItem: Hashable {
    let movieCode: String
    let boxOfficeData: BoxOfficeData
    let movieInformation: MovieInformation
    let plot: String
    let imageUrl: URL?
    let posterImage: UIImage
    
    init(movieCode: String, boxOfficeData: BoxOfficeData, movieInformation: MovieInformation, plot: String, imageUrl: URL?, posterImage: UIImage) {
        self.movieCode = movieCode
        self.boxOfficeData = boxOfficeData
        self.movieInformation = movieInformation
        self.plot = plot
        self.imageUrl = imageUrl
        self.posterImage = posterImage
    }
    
    static func == (lhs: BoxOfficeItem, rhs: BoxOfficeItem) -> Bool {
        return lhs.movieCode == rhs.movieCode
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(movieCode)
    }
}
