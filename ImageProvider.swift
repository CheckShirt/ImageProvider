//
//  ImageProvider.swift
//  AppStoreSearch
//
//  Created by HanSangmin on 2020/09/18.
//  Copyright © 2020 HanSangmin. All rights reserved.
//

import UIKit

struct ImageProvider {
            
    static func load(_ url: URL,
                     completionHandler: ((Result<UIImage, Error>) -> Void)? = nil) {
        if let image = manager.getImage(for: url.absoluteString) {
            completionHandler?(.success(image))
        } else {
            session.request(url) { (result: Result<Data, Error>) in
                switch result {
                case .success(let data):
                    if let image = UIImage(data: data) {
                        manager.setImage(image: image, for: url.absoluteString)
                        completionHandler?(.success(image))
                    }
                case .failure(let error):
                    completionHandler?(.failure(error))
                }
            }
        }
    }
    
    private static var manager: ImageStorageManager {
        return ImageStorageManager.shared
    }
    
    private static var session: Session {
        return Session.shared
    }
}

final class ImageStorageManager {
    
    static let shared = ImageStorageManager()
        
    func getImage(for key: String) -> UIImage? {
        return storage[key]
    }
    
    func setImage(image: UIImage, for key: String) {
        storage[key] = image
    }
    
    func removeAll() {
        storage.removeAll()
    }
    
    func removeObject(for key: String) {
        storage.remove(for: key)
    }
    
    private let session = Session.shared
    private let storage: HashImageStorage = .init()
}

public protocol ImageStorage {
    
    func remove(for key: String)
    
    func removeAll()
}
