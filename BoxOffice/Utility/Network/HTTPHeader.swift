//
//  HTTPHeader.swift
//  BoxOffice
//
//  Created by Dasan on 2024/01/15.
//

enum HTTPHeader: Equatable {
    case authorization(key: String)

    var header: [String: String] {
        switch self {
        case .authorization(let key):
            return ["Authorization": key]
        }
    }
}
