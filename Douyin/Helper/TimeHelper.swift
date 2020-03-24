//
//  TimeHelper.swift
//  Douyin
//
//  Created by 张玉久 on 2020/3/24.
//  Copyright © 2020 张玉久. All rights reserved.
//
import Foundation

struct TimeHelper {
    static func timeStamp2String(timeStamp:Int)->String{
        //转换为时间
        let timeInterval:TimeInterval = TimeInterval(timeStamp)
        let date = NSDate(timeIntervalSince1970: timeInterval)
         
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd"
        return dformatter.string(from: date as Date)
    }
}
