//
//  TimeHelper.swift
//  Douyin
//
//  Created by 张玉久 on 2020/3/24.
//  Copyright © 2020 张玉久. All rights reserved.
//
import Foundation

struct TimeHelper {
    //时间戳转换为字符串
    static func timeStamp2String(timeStamp:Int)->String{
        let timeInterval:TimeInterval = TimeInterval(timeStamp)
        let date = NSDate(timeIntervalSince1970: timeInterval)
         
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd"
        return dformatter.string(from: date as Date)
    }
}
