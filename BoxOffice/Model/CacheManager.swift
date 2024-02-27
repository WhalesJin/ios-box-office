//
//  CacheManager.swift
//  BoxOffice
//
//  Created by Dasan on 2024/02/27.
//

import Foundation

final class CacheManager<T: AnyObject> {
    let cache = NSCache<NSString, AnyObject>()
    
    func insert(_ key: String, _ value: T) {
        cache.setObject(value, forKey: key as NSString)
    }
    
    func read(key: String) -> T? {
        return cache.object(forKey: key as NSString) as? T
    }
    
    
    func remove(key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    func removeAll() {
        cache.removeAllObjects()
    }
}
