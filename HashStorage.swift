//
//  HashStorage.swift
//  AppStoreSearch
//
//  Created by HanSangmin on 2020/09/21.
//  Copyright © 2020 HanSangmin. All rights reserved.
//

import UIKit

/// HashImageStoryage Ref. hirohisa/ImageLoaderSwift Github

class HashImageStorage: ImageStorage {
    
    private var storage = NSCache<NSString, UIImage>()
    
    public init() {
        storage.countLimit = 300
        storage.name = "ImageDataCache"
    }
    
    public subscript(key: String) -> UIImage? {
        get {
            objc_sync_enter(HashImageStorage.self)
            defer { objc_sync_exit(HashImageStorage.self) }
            return storage.object(forKey: key as NSString)
        }
        
        set(value) {
            objc_sync_enter(HashImageStorage.self)
            defer { objc_sync_exit(HashImageStorage.self) }
            
            if let value = value {
                storage.setObject(value, forKey: key as NSString)
            }
        }
    }
    
    public func removeAll() {
        storage.removeAllObjects()
    }
    
    public func remove(for key: String) {
        storage.removeObject(forKey: key as NSString)
    }
}


