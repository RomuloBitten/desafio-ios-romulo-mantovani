//
//  MarvelRequest.swift
//  desafio-ios-romulo-mantovani
//
//  Created by Romulo Bittencourt Mantovani on 09/04/20.
//  Copyright © 2020 Romulo Bittencourt Mantovani. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import Alamofire
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG



class MarvelRequest: MarvelRequestProtocol {
    var path: String
    
    var headers: [String : String]?
    
    var params: [String : Any]?
    
    var body: Data?
    
    var requestMethod: HTTPMethod
    
    init(path: String,
         headers: [String: String]? = nil,
         params: [String: Any]? = nil,
         body: Data? = nil,
         requestMethod: HTTPMethod = .get) {
        self.path = path
        self.params = params
        self.body = body
        self.requestMethod = requestMethod
        
        if let customHeader = headers {
            self.addHeaders(customHeader)
        }
    }
    
    func addParameters(_ customParams: [String : Any]) {
        guard var parameters = self.params else {
            self.params = customParams
            return
        }
        
        for key in customParams.keys {
            parameters[key] = customParams[key]
        }
        self.params = parameters
    }
    
    func addDefaultsParams() {
        addParameters(["ts": 1])
        addParameters(["apikey": DataManager.sharedInstance.apiKey])
        addParameters(["hash": DataManager.sharedInstance.apiHash])
    }
    
    func addHeaders(_ customHeaders: [String : String]) {
        guard var currentHeaders = self.headers else {
            self.headers = customHeaders
            return
        }
        
        for key in customHeaders.keys {
            currentHeaders[key] = customHeaders[key]
        }
        self.headers = currentHeaders
    }
    
    func call() -> Observable<JSON> {
        addDefaultsParams()
        
        let AFHeaders = HTTPHeaders(self.headers ?? [:])
        let AFRequest = AF.request(path,
                                   method: self.requestMethod,
                                   parameters: self.params,
                                   headers: AFHeaders)
        
        return Observable<JSON>.create { observer -> Disposable in
             AFRequest.responseJSON { response in
                debugPrint(response.request?.url?.absoluteString ?? "")
                switch response.result {
                case .success(let value):
                    return observer.onNext(JSON(value))
                case .failure(let error):
                    return observer.onError(error)
                }
            }

            return Disposables.create {
                AFRequest.cancel()
            }
        }
    }
    
    func callData() -> Observable<Data> {
        let AFHeaders = HTTPHeaders(self.headers ?? [:])
        let AFRequest = AF.download(path,
                                    method: self.requestMethod,
                                    parameters: self.params,
                                    headers: AFHeaders)
        
        return Observable<Data>.create { observer -> Disposable in
            AFRequest.responseData { response in
                debugPrint(response.request?.url?.absoluteString ?? "")
                switch response.result {
                case .success(let data):
                    return observer.onNext(data)
                case .failure(let error):
                    return observer.onError(error)
                }
            }

            return Disposables.create {
                AFRequest.cancel()
            }
        }
    }
}
