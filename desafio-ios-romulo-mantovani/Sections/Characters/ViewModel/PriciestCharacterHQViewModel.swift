//
//  PriciestCharacterHQViewModel.swift
//  desafio-ios-romulo-mantovani
//
//  Created by Romulo Bittencourt Mantovani on 14/04/20.
//  Copyright © 2020 Romulo Bittencourt Mantovani. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

class PriciestCharacterHQViewModel {
    private var allHQs: [MarvelHQ] = []
    
    let characterAPIs = CharactersAPI()
    
    let disposeBag = DisposeBag()
    
    private var lastOffset = -50
    
    func rx_retrievePriciestHQ(_ id: Int) -> Observable<MarvelHQ>{
        lastOffset += 50

        return self.rx_retriveHQs(id, offset: lastOffset).map { [weak self] json -> [MarvelHQ] in
            guard let self = self else {return []}
            let data = json["data"]
            var results = data["results"].arrayValue.map { (jsonHQ) -> MarvelHQ in
                MarvelHQ(json: jsonHQ)
            }
            if data["total"].intValue > data["count"].intValue {
                self.rx_retrievePriciestHQ(id).subscribe { event in
                    guard let lastPriciestHQ = event.element else {return}
                    results.append(lastPriciestHQ)
                }.disposed(by: self.disposeBag)
            }
            return results
        }.map {[weak self] results -> MarvelHQ in
            guard let self = self else {return results.first!}
            self.allHQs = results
            
            let priciestIndex = self.allHQs.enumerated().map {($0, $1.price)}.max { (arg0, arg1) -> Bool in
                let (_, prevPrice) = arg0
                let (_, nextPrice) = arg1
                return prevPrice > nextPrice
            }
            let priciestHQ = self.allHQs[priciestIndex?.0 ?? 0]
            
            return priciestHQ
        }
    }
    
    private func rx_retriveHQs(_ id: Int, offset: Int) -> Observable<JSON> {
        characterAPIs.getCharacterHQs(forId: id, offsetBy: offset)
    }
}
