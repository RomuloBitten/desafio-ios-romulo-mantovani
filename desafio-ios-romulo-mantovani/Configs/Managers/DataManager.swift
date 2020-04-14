//
//  DataManager.swift
//  desafio-ios-romulo-mantovani
//
//  Created by Romulo Bittencourt Mantovani on 09/04/20.
//  Copyright © 2020 Romulo Bittencourt Mantovani. All rights reserved.
//

import Foundation

public class DataManager {
    public static var sharedInstance = DataManager()
    
    fileprivate init() {
        if let defaults = self.sharedDefaults {
            defaults.set("bc2602122181c650e12b9f0ca0a0c1f2", forKey: apiKey)
            defaults.set("4e2f867479a98f5f77e63de47abc859e", forKey: apiHash)
        }
    }
    
    public var sharedDefaults: UserDefaults? = {
        return UserDefaults(suiteName: "desafio-ios-romulo-mantovani")
    }()
    
    public var apiKey: String {
        return sharedDefaults?.string(forKey: "apiKey") ?? "bc2602122181c650e12b9f0ca0a0c1f2"
    }
    
    public var apiHash: String {
        return sharedDefaults?.string(forKey: "apiHash") ?? "4e2f867479a98f5f77e63de47abc859e"
    }
}
