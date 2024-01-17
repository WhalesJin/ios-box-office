//
//  DummyRequester.swift
//  DecodingManagerTests
//
//  Created by Dasan on 2024/01/09.
//

import XCTest
@testable import BoxOffice

final class DummyRequester: Requestable {
    func dataTask(with urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: URL(string: "")!)
    }
}
