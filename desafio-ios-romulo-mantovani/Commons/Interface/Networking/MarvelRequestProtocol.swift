//
//  MarvelRequestProtocol.swift
//  desafio-ios-romulo-mantovani
//
//  Created by Romulo Bittencourt Mantovani on 09/04/20.
//  Copyright © 2020 Romulo Bittencourt Mantovani. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RxSwift

protocol MarvelRequestProtocol {
    var path: String { get set }
    var headers: [String: String]? { get set }
    var params: [String: Any]? { get set }
    var body: Data? { get set }
    var requestMethod: HTTPMethod { get set }
    
    func addParameters(_ customParams: [String: Any])
    func addHeaders(_ customHeaders: [String: String])
    func call() -> Observable<JSON>
}
