//
//  NetworkManageable.swift
//  BoxOffice
//
//  Created by Dasan on 2024/01/12.
//

import Foundation

protocol NetworkManageable {
    var requester: Requestable { get }
    
    func fetchData(
        from url: URL?,
        method: HTTPMethod,
        header: [HTTPHeader]?,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    ) -> URLSessionDataTask?
}
