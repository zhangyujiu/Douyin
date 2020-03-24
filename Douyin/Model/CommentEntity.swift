//
//  CommentEntity.swift
//  Douyin
//
//  Created by 张玉久 on 2020/3/24.
//  Copyright © 2020 张玉久. All rights reserved.
//

import Foundation

struct CommentEntity:Codable {
    var content:String=""
    var vote:Int=0
    var time:Int=0
    var user:User
}
