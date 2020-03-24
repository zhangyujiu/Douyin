//
//  VideoModel.swift
//  Douyin
//
//  Created by 张玉久 on 2020/3/17.
//  Copyright © 2020 张玉久. All rights reserved.
//

import Foundation


struct VideoEntity : Codable {
    var _id:String = ""
    var title:String = ""
    var poster:String = ""
    var url:String = ""
    var user: User
    var game_name:String = ""
    var game_icon:String = ""
    var vote:Int = 0
    var share:Int = 0
    var comment_count:Int = 0
    var game_id:String=""
    
    
    
    
}
struct User : Codable{
    var name:String=""
    var icon:String=""
}
