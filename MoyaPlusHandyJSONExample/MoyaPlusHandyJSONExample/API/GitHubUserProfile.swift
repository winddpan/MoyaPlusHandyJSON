//
//  GitHubUserProfile.swift
//  Moya+HandyJSONExample
//
//  Created by PANGE on 2018/2/21.
//  Copyright © 2018年 PANGE. All rights reserved.
//

import Foundation
import HandyJSON

class GitHubUserProfile: HandyJSON {
    var name: String?
    var id: Int = 0
    var url: String?
    
    required init() {}
}
