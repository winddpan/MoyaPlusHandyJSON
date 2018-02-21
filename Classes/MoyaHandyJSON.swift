//
//  MoyaResponseHandyJSON.swift
//  HJSwift
//
//  Created by PAN on 2017/10/24.
//  Copyright © 2017年 YR. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import HandyJSON

public enum HandyJSONMapError: Swift.Error {
    case mapError
}

public extension Response {

    public func map<D: HandyJSON>(_ type: D.Type, atKeyPath keyPath: String? = nil) throws -> D {
        let jsonString = try mapString()
        if let obj = D.deserialize(from: jsonString, designatedPath: keyPath) {
            return obj
        }
        throw MoyaError.objectMapping(HandyJSONMapError.mapError, self)
    }
    
    public func map<D: HandyJSON>(_ type: [D].Type, atKeyPath keyPath: String? = nil) throws -> [D] {
        let jsonString = try mapString()
        if let objs = [D].deserialize(from: jsonString, designatedPath: keyPath) as? [D] {
            return objs
        }
        throw MoyaError.objectMapping(HandyJSONMapError.mapError, self)
    }
}

extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {

    public func map<D: HandyJSON>(_ type: D.Type, atKeyPath keyPath: String? = nil) -> Single<D> {
        return flatMap { response -> Single<D> in
            return Single.just(try response.map(type, atKeyPath: keyPath))
        }
    }
    
    public func map<D: HandyJSON>(_ type: [D].Type, atKeyPath keyPath: String? = nil) -> Single<[D]> {
        return flatMap { response -> Single<[D]> in
            return Single.just(try response.map(type, atKeyPath: keyPath))
        }
    }
}

extension ObservableType where E == Response {
    
    public func map<D: HandyJSON>(_ type: D.Type, atKeyPath keyPath: String? = nil) -> Observable<D> {
        return flatMap { response -> Observable<D> in
            return Observable.just(try response.map(type, atKeyPath: keyPath))
        }
    }
    
    public func map<D: HandyJSON>(_ type: [D].Type, atKeyPath keyPath: String? = nil) -> Observable<[D]> {
        return flatMap { response -> Observable<[D]> in
            return Observable.just(try response.map(type, atKeyPath: keyPath))
        }
    }
}
