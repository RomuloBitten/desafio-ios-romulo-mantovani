//
//  CharactersAPI.swift
//  desafio-ios-romulo-mantovani
//
//  Created by Romulo Bittencourt Mantovani on 07/04/20.
//  Copyright © 2020 Romulo Bittencourt Mantovani. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import Alamofire

fileprivate struct CharactersRequests {
    private static let path = "https://gateway.marvel.com:443"
    
    static public var characters: MarvelRequestProtocol {
        return MarvelRequest(path: path+"/v1/public/characters")
    }
    
    static public func characterHQs(_ id: Int) -> MarvelRequestProtocol {
        return MarvelRequest(path:  path+"/v1/public/characters/\(id)/comics")
    }
}

class CharactersAPI {
    public func getCharacters(offsetBy offset: Int? = nil, limit: Int? = nil) -> Observable<JSON>{
        let request = CharactersRequests.characters
        if let offset = offset {
            request.addParameters(["offset" : offset])
        }
        if let limit = limit {
            request.addParameters(["limit" : limit])
        }
        return request.call()
    }
    
    public func getImage(fromUrl url: String) -> Observable<Data> {
        MarvelRequest(path: url).callData()
    }
    
    public func getCharacterHQs(forId id: Int, offsetBy offset: Int? = nil) -> Observable<JSON> {
       let request = CharactersRequests.characterHQs(id)
        request.addParameters(["limit": 50])
        if let offset = offset {
            request.addParameters(["offset" : offset])
        }
        
        return request.call()
    }
}
