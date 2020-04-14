//
//  CharactersListViewModel.swift
//  desafio-ios-romulo-mantovani
//
//  Created by Romulo Bittencourt Mantovani on 09/04/20.
//  Copyright © 2020 Romulo Bittencourt Mantovani. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

class CharactersListViewModel {
    var characters: [MarvelCharacter] = []
    
    var retrievedPages = -1
    
    var totalPages: Int?
    
    var itemsForPage = 20
    
    private var charactersApi = CharactersAPI()
    
    func rx_retrieveNextPage() -> Observable<Void> {
        retrievedPages += 1
        return charactersApi.getCharacters(offsetBy: retrievedPages*itemsForPage, limit: self.itemsForPage).map { [weak self] json -> () in
            guard let self = self else {return}
            let data = json["data"]
            self.totalPages = data["total"].intValue/self.itemsForPage
            guard let results = data["results"].array else {return}
            for jsonChar in results{
                for (index, currentChar) in self.characters.enumerated() {
                    if currentChar.id == jsonChar["id"].intValue {
                        let newChar = MarvelCharacter(json: jsonChar, image: currentChar.cachedImage)
                        self.characters.replaceSubrange(index...index, with: [newChar])
                        return
                    }
                }
                let newChar = MarvelCharacter(json: jsonChar)
                self.characters.append(newChar)
            }
        }
    }
}
