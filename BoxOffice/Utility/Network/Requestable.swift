//
//  Requestable.swift
//  BoxOffice
//
//  Created by Dasan on 2024/01/12.
//

import Foundation

protocol Requestable {
    func dataTask(
        with urlRequest: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}
