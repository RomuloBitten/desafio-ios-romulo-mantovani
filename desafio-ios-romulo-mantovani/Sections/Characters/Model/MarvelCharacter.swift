//
//  MarvelCharacter.swift
//  desafio-ios-romulo-mantovani
//
//  Created by Romulo Bittencourt Mantovani on 09/04/20.
//  Copyright © 2020 Romulo Bittencourt Mantovani. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift

class MarvelCharacter {
    var id: Int
    var name: String
    var description: String
    private var thumbPath: String
    var cachedImage: UIImage?
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.description = json["description"].stringValue
        
        let thumbnail = json["thumbnail"]
        self.thumbPath = thumbnail["path"].stringValue+"."+thumbnail["extension"].stringValue
    }
    convenience init(json: JSON, image: UIImage?) {
        self.init(json: json)
        self.cachedImage = image
    }
    
    func image() -> Observable<UIImage?> {
        if let image = cachedImage {
            return Observable.just(image)
        } else {
            return CharactersAPI().getImage(fromUrl: thumbPath).observeOn(MainScheduler.instance).map {[weak self] data -> UIImage? in
                let image = UIImage(data: data, scale:1)
                guard let self = self else {return image}
                self.cachedImage = image
                return image
            }
        }
    }
}
