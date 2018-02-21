//
//  LazyProvider.swift
//  HJSwift
//
//  Created by PAN on 2017/12/28.
//  Copyright © 2017年 YR. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Result

private class LazyResponseWrapper {
    var isRunning = false
    var cancellable: Cancellable?
    var response: Response?
    var runningCompletions: [Completion] = []
}

private class LazyProviderCache {
    static let shared: NSCache<NSString, AnyObject> = {
        let cache = NSCache<NSString, AnyObject>()
        cache.countLimit = 100
        cache.totalCostLimit = 10 * 1024 * 1024  //10MB
        return cache
    }()
}

private class RouterProvider {
    
    static func provider<T: TargetType>(useCacheIfExists: Bool = false) -> LazyProvider<T> {
        let cacheName = String(describing: T.self)
        let provider = shared.cache[cacheName] as? LazyProvider<T> ?? LazyProvider<T>(plugins: [NetworkActivityPlugin(){_ ,_  in }])
        provider.needsUpdate = !useCacheIfExists
        shared.cache[cacheName] = provider
        return provider
    }
    
    private var cache: [String: Any] = [String: Any]()
    private static let shared: RouterProvider = {
        return RouterProvider()
    }()
}

open class LazyProvider<Target: TargetType>: MoyaProvider<Target> {
    
    fileprivate var needsUpdate = true
    
    private func keyToken(_ target: TargetType) -> NSString? {
        if case Moya.Task.requestParameters(parameters: let params, encoding: _) = target.task {
            var hash = target.path.hashValue
            if params.count > 0, let data = try? JSONSerialization.data(withJSONObject: params, options: []) {
                hash += data.hashValue
            }
            return "\(hash)" as NSString
        }
        return nil
    }
    
    @discardableResult
    open func request(_ target: Target,
                          callbackQueue: DispatchQueue? = .none,
                          progress: ProgressBlock? = .none) -> Cancellable {
        return request(target, callbackQueue: callbackQueue, progress: progress, completion: { _ in })
    }

    @discardableResult
    override open func request(_ target: Target,
                          callbackQueue: DispatchQueue? = .none,
                          progress: ProgressBlock? = .none,
                          completion: @escaping Completion) -> Cancellable {
        guard let token = keyToken(target) else {
            return super.request(target, callbackQueue: callbackQueue, progress: progress, completion: completion)
        }
        
        var wrapper: LazyResponseWrapper! = LazyProviderCache.shared.object(forKey: token) as? LazyResponseWrapper
        if wrapper == nil {
            wrapper = LazyResponseWrapper()
            LazyProviderCache.shared.setObject(wrapper, forKey: token)
        }

        if let cancellable = wrapper.cancellable, (!needsUpdate || wrapper.isRunning) {
            if let response = wrapper.response {
                completion(Result.success(response))
            } else {
                wrapper.runningCompletions.append(completion)
            }
            return cancellable
        } else {
            wrapper.response = nil
            wrapper.isRunning = true
            wrapper.runningCompletions.append(completion)
            
            let cancellable = super.request(target, callbackQueue: callbackQueue, progress: progress, completion: { result in
                wrapper.isRunning = false
                if case .success(let response) = result {
                    wrapper.response = response
                }
                for cp in wrapper.runningCompletions {
                    cp(result)
                }
                wrapper.runningCompletions.removeAll()
            })
            wrapper.cancellable = cancellable
            return cancellable
        }
    }
    
    open func removeLazyCache(_ target: Target) {
        if let token = keyToken(target),
            let wrapper = LazyProviderCache.shared.object(forKey: token) as? LazyResponseWrapper,
            !wrapper.isRunning {
            
            wrapper.response = nil
            wrapper.cancellable = nil
            LazyProviderCache.shared.removeObject(forKey: token)
        }
    }
}


extension TargetType {
    
    public static func lazyProvider() -> LazyProvider<Self> {
        return RouterProvider.provider(useCacheIfExists: true)
    }
    
    public static func provider() -> LazyProvider<Self> {
        return RouterProvider.provider(useCacheIfExists: false)
    }
}

