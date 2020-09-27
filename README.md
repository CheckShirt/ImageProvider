# ImageProvider



[![License](https://img.shields.io/cocoapods/l/SwiftString.svg?style=flat)](http://cocoapods.org/pods/SwiftString)

[![Platform](https://img.shields.io/cocoapods/p/SwiftString.svg?style=flat)](http://cocoapods.org/pods/SwiftString)

[![Swift-5.0](http://img.shields.io/badge/Swift-5.0-blue.svg)]()



### At Glance

Swift toy 프로젝트에서 사용할 Image Cache 코드를 간단하게 작성해 봤습니다.

그리고 될 수 있으면 image Cache의 기본적인 원리만 알고, 잘 되어 있는 기존 프레임워크 사용합시다...



### Cache

Cache: 한번 연산이 진행된 데이터를 별도의 저장소에 저장해 놓고, 데이터를 재사용 시 기 연산 된 데이터를 사용한다.

[Image Cache: URL 정보를 통해 받아온 이미지를 임시 저장소(메모리, 디스크) 등에 저장하여 사용한다. 일반적으로 키 값은 URL 기반으로 작동한다.](https://github.com/hirohisa/ImageLoaderSwift)



### 메모리 캐시

DiskCache 방식은 File I/O를 하게 됨으로 메모리 캐시에 비해 성능이 떨어집니다.

대신에 앱을 지우지 않는 한 영구적으로 저장할 수 있다는 장점이 있죠.

DB나 UserDefault 에 사용하는 방법도 있겠으나, 일단 기본적인 원리릉 알기 위해 작성하는 코드임으로 여기선 메모리 캐시만 다루도록 하겠습니다.

메모리 캐시를 다루는 방법은 크게 두 가지가 있어요



### Dictionary

### 장점

- 키 값을 구현할 때 NSString 으로 as 캐스팅을 하지 않아도 된다.
- Subscript 를 사용해서 쉽게 지정할 수 있다.

### 단점

- 디바이스에 메모리가 부족하더라도 자동으로 삭제해주지는 않는다.



### NSCache

### 장점

- 메모리 부족시 자동으로 삭제해준다.
- totoalCountLimit, totalCostLimit를 통해 데이터 크기를 지정할 수 있다.

### 단점

- 지워지는 데이터를 내가 임의로 선별할 수 없다.
- Subscript를 사용할 수 없다. → HashStorage 소스로 이를 해결

### 추가

**NSPurgeableData**

sContentDiscarede 메서드를 통해 캐시된 데이터가 해제되었는지를 판단할 수 있다.

**beginContentAcess, EndContentAccess**

Read-Write 문제를 해결하기 위해 기존 저장된 데이터를 사용할 때, 이를 지우지 말라고 data에 알리는 역할



### Code It

```swift
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
```



### Diagram

![ImageProvider] (https://user-images.githubusercontent.com/6268707/94352440-ed8a5c80-009f-11eb-9d46-07895e321790.png)



### Conclusion

기본적인 Image Cache 방법에 대해서 작성해 봤습니다.



### Reference

[ImageLoader] (https://github.com/hirohisa/ImageLoaderSwift)
