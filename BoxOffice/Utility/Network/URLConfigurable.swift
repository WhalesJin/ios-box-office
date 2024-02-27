//
//  URLConfigurable.swift
//  BoxOffice
//
//  Created by Dasan & Whales on 2023/07/28.
//

import Foundation

protocol URLConfigurable {
    var baseUrl: String { get }
    var path: String { get }
    var queries: [URLQueryItem] { get }
}
