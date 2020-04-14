//
//  MarvelHQ.swift
//  desafio-ios-romulo-mantovani
//
//  Created by Romulo Bittencourt Mantovani on 14/04/20.
//  Copyright © 2020 Romulo Bittencourt Mantovani. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import RxSwift

class MarvelHQ {
    var title: String
    private var thumbPath: String
    var cachedImage: UIImage?
    var description: String
    var price: Double
    
    init(json: JSON) {
        self.title = json["title"].stringValue
        self.description = json["description"].stringValue
        
        let thumbnail = json["thumbnail"]
        self.thumbPath = thumbnail["path"].stringValue+"."+thumbnail["extension"].stringValue
        
        let prices = json["prices"].arrayValue
        let highestPrice = prices.max { (json0, json1) -> Bool in
            json0["price"].doubleValue > json1["price"].doubleValue
        }
        self.price = highestPrice?["price"].doubleValue ?? 0.0
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
