//
//  CacheManagerTests.swift
//  BoxOfficeTests
//
//  Created by Dasan on 2024/02/27.
//

import XCTest
@testable import BoxOffice

final class AnyType {
    let value: Int
    
    init(value: Int) {
        self.value = value
    }
}

final class CacheManagerTests: XCTestCase {
    let cacheManager = CacheManager<AnyType>()

    func testInsert() {
        cacheManager.insert("1", AnyType(value: 1))
        XCTAssertEqual(cacheManager.read(key: "1")?.value, 1)
        
        cacheManager.insert("1", AnyType(value: 2))
        XCTAssertEqual(cacheManager.read(key: "1")?.value, 2)
    }
    
    func testRemove() {
        cacheManager.insert("1", AnyType(value: 1))
        cacheManager.insert("2", AnyType(value: 2))
        
        cacheManager.remove(key: "1")
        XCTAssertEqual(cacheManager.read(key: "1")?.value, nil)
        XCTAssertEqual(cacheManager.read(key: "2")?.value, 2)
    }
    
    func testRemoveAll() {
        cacheManager.insert("3", AnyType(value: 3))
        cacheManager.insert("4", AnyType(value: 4))
        
        cacheManager.removeAll()
        XCTAssertEqual(cacheManager.read(key: "3")?.value, nil)
        XCTAssertEqual(cacheManager.read(key: "4")?.value, nil)
    }
    
    func testIsCached() {
        cacheManager.insert("1", AnyType(value: 1))
        
        if let object = cacheManager.read(key: "1") {
            XCTAssertEqual(object.value, 1)
        } else {
            XCTFail()
        }
    }
    
    func testIsNotCached() {
        cacheManager.insert("1", AnyType(value: 1))
        
        if let _ = cacheManager.read(key: "2") {
            XCTFail()
        } else {
            XCTAssertNil(cacheManager.read(key: "2")?.value)
        }
    }
}
