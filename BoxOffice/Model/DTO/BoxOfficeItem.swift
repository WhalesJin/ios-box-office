//
//  BoxOfficeItem.swift
//  BoxOffice
//
//  Created by Dasan on 2024/02/20.
//

import UIKit

struct BoxOfficeItem: Hashable {
    let movieCode: String
    let boxOfficeData: BoxOfficeData
    let movieInformation: MovieInformation
    let imageUrl: URL?
    let posterImage: UIImage
    
    static func == (lhs: BoxOfficeItem, rhs: BoxOfficeItem) -> Bool {
        return lhs.movieCode == rhs.movieCode
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(movieCode)
    }
}
