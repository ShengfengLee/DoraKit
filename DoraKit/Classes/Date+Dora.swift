//
//  Date+Dora.swift
//  hoonpay
//
//  Created by 李胜锋 on 2017/8/7.
//  Copyright © 2017年 lishengfeng. All rights reserved.
//

import Foundation

public extension Date {
    static func dora_timestamp(_ timestamp:String?) -> Date? {
        let timeInterval = Double.dora_parse(timestamp)
        
        return Date.init(timeIntervalSince1970: timeInterval)
    }
    
    ///根据日期字符串返回日期
    static func dora_date(_ timeStr: String, formate:String) -> Date? {
        let formatter = DateFormatter.init()
        formatter.dateFormat = formate
//        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.date(from: timeStr)
    }

    
    ///根据日期返回日期字符串
    static func dora_formateStr(_ date:Date, formate:String) -> String {
        let formatter = DateFormatter.init()
        formatter.dateFormat = formate
//        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: date)
    }
    
    func dora_formate(_ formate: String) -> String {
        return Date.dora_formateStr(self, formate: formate)
    }
    
    ///根据时间戳返回日期字符串
    static func dora_formateStr(timeInterval:TimeInterval, formate:String) -> String {
        let date = Date.init(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter.init()
//        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = formate
        return formatter.string(from: date)
    }
    
    ///年龄
    static func dora_age(_ timeInterval:TimeInterval) -> Int {
        let date = NSDate.init(timeIntervalSince1970: timeInterval)
        let timeDiff = 0 - date.timeIntervalSinceNow
        
        let age = trunc(timeDiff/(60*60*24)) / 365
        return Int(age)
    }
    
    static func dora_duration(timeInterval: Int) -> String {
        //秒
        let second = timeInterval % 60
        //分钟
        let minute = timeInterval / 60
        
        let hour = timeInterval / 3600
        
        if hour > 0 {
            return String.init(format: "%02d:%02d:%02d", hour, minute, second)
        }
        return String.init(format: "%02d:%02d", minute, second)
    }
    
    ///时分秒
    static func dora_hourDuration(timeInterval: Int) -> String {
        //秒
        let second = timeInterval % 60
        //分钟
        let minute = timeInterval / 60
        let hour = timeInterval / 3600
        
        return String.init(format: "%02d:%02d:%02d", hour, minute, second)
    }
    
    ///根据时间戳返回星期
    /*
     首先要知道timeIntervalSince1970是取当前日期和1970-01-01 0点的时间差，当天是星期四，因此根据时间差算星期几时需要加4；为了保证输入年份小于1970时仍然有效，也就是说interval以及days有可能为负数，因此模7取余后，又进行了加7和模7；最后，为了调整weekday按之前约定星期一从1开始编号，需要将计算的0值转换成7，于是有了最后一行的“return weekday == 0 ? 7 : weekday”。测试一下“2016-01-17 23:58:00”，得出结果为“7”，貌似没有问题；再试一个"1969-12-31 00:00:00"，得出结果3（之前说了1970-01-01时周四），也对，但是真的不对。幸亏写这个方法时是夜里23:50左右，一过零点到了下一天，问题出来了，“2016-01-18 00:01:01”竟然得出来还是7，跟17日的星期数一样！Why？？？！！！
     
     在playground里调试一下发现只有interval可能有问题，仔细百度并次查看官方API文档后发现，NSDate表示的时间在内存中都是UTC时间，即0时区的时间，当需要显示时，才会根据当前系统的时区或者代码里指定的时区进行显示。以“2016-01-18 00:01:01”为例，输入值自然伴随着当前的时区（中国时区为东8区），转换成NSDate对象后就变成了UTC时间，即 “2016-01-17 16:01:01”，小时数减了8，而 timeIntervalSince1970 计算出来的时间差自然也就是2016-01-17到1970-01-01的。知道问题所在，只需修改一下interval的计算即可，变成“ interval = Int(date!.timeIntervalSince1970) + NSTimeZone.localTimeZone().secondsFromGMT", 修正后的版本为：
     */
    static func getWeekDay(_ timeInterval:TimeInterval)->String? {
        let days = Int(timeInterval/86400) // 24*60*60
        let weekday = ((days + 4)%7+7)%7
        var weekdayStr:String?
        switch weekday {
        case 0:
            weekdayStr = "星期天"
        case 1:
            weekdayStr = "星期一"
        case 2:
            weekdayStr = "星期二"
        case 3:
            weekdayStr = "星期三"
        case 4:
            weekdayStr = "星期四"
        case 5:
            weekdayStr = "星期五"
        case 6:
            weekdayStr = "星期六"
        
        default:
            break
        }
        return weekdayStr
    }
    
    ///判断星期几
    func weekDay() -> String {
        let weekDays = ["星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期天"]
        var calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        calendar.firstWeekday = 0
        let component = calendar.component(Calendar.Component.weekday, from: self)
        return weekDays[component]
    }
    
    ///是否是今天
    func dora_todayStr() -> String? {
        let today = Date()
        
        let dateStr = (self.description as NSString).substring(to: 10)
        let todayStr = (today.description as NSString).substring(to: 10)
        if dateStr == todayStr {
            return "今天"
        }
        
        let secondsPerDay: TimeInterval = 24 * 60 * 60
        let yesterday = today.addingTimeInterval(0 - secondsPerDay)
        let yesterdayStr = (yesterday.description as NSString).substring(to: 10)
        if yesterdayStr == dateStr {
            return "昨天"
        }
        
        return nil
    }
    
}
