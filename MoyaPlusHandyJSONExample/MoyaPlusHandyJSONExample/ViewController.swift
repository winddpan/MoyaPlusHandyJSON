//
//  ViewController.swift
//  MoyaPlusHandyJSONExample
//
//  Created by PANGE on 2018/2/21.
//  Copyright © 2018年 PANGE. All rights reserved.
//

import UIKit
import MoyaPlusHandyJSON
import RxSwift

class ViewController: UIViewController {
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GitHub.provider().rx
            .request(.userProfile("winddpan"))
            .mapString()
            .subscribe(onSuccess: { json in
                print(json)
            }) { error in
                print(error.localizedDescription)
            }.disposed(by: bag)
        
        GitHub.provider().rx
            .request(.userProfile("winddpan"))
            .map(GitHubUserProfile.self)
            .subscribe(onSuccess: { user in
                print("\nname:\(user.name!) id:\(user.id) url:\(user.url!)")
            }) { error in
                print(error.localizedDescription)
            }.disposed(by: bag)
        
        GitHub.provider()
            .request(.userProfile("winddpan")) { result in
                switch result {
                case let .success(moyaResponse):
                    let data = moyaResponse.data
                    let statusCode = moyaResponse.statusCode
                    let user = try! moyaResponse.map(GitHubUserProfile.self)
                    
                    print("\nname:\(user.name!) id:\(user.id) url:\(user.url!)")
                // do something with the response data or statusCode
                case let .failure(error):
                    // this means there was a network failure - either the request
                    // wasn't sent (connectivity), or no response was received (server
                    // timed out).  If the server responds with a 4xx or 5xx error, that
                    // will be sent as a ".success"-ful response.
                    break
                }
        }
    }
    
}



