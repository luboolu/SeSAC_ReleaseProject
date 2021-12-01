//
//  Date+Extension.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/11/27.
//

import Foundation

extension DateFormatter {

    //timeStamp에 쓰일 모든 종류의 date formatter 생성
    
    //Fri - 금
    static var dayOfWeekFormat1: DateFormatter {
        let date = DateFormatter()
        date.dateFormat = "EE"
        
        return date
    }
    
    //Friday - 금요일
    static var dayOfWeekFormat2: DateFormatter {
        let date = DateFormatter()
        date.locale = Locale(identifier: "en_KR")
        date.dateFormat = "EEEE"
        
        return date
    }
    
    //am, pm - 오전 오후
    static var amPmFormat: DateFormatter {
        let date = DateFormatter()
        date.dateFormat = "a"
        
        return date
    }
    
    static var yearFormar: DateFormatter {
        let date = DateFormatter()
        date.dateFormat = "yyyy"
        
        return date
    }
    
    
    
    /*
     /////////////////////////////////////////////////
     /////////////////////////////////////////////////
     */
    //날짜 format
    
    //2021.11.28
    static var yearDayFormat1: DateFormatter {

        let date = DateFormatter()
        date.locale = Locale(identifier: "en_KR")
        date.dateFormat = "yyyy.M.d"

        return date
    }
    
    static var yearDayFormat1_2: DateFormatter {

        let date = DateFormatter()
        date.locale = Locale(identifier: "en_KR")
        date.dateFormat = "yyyy.MM.dd"

        return date
    }
    
    //21.11.28
    static var yearDayFormat2: DateFormatter {
        let date = DateFormatter()
        date.locale = Locale(identifier: "en_KR")
        date.dateFormat = "yy.M.d"
        
        return date
    }
    
    static var yearDayFormat2_2: DateFormatter {
        let date = DateFormatter()
        date.locale = Locale(identifier: "en_KR")
        date.dateFormat = "yy.MM.dd"
        
        return date
    }
    
    //2021 11/28
    static var yearDayFormat3: DateFormatter {
        let date = DateFormatter()
        date.locale = Locale(identifier: "en_KR")
        date.dateFormat = "yyyy M/d"
        
        return date
    }
    
    static var yearDayFormat3_2: DateFormatter {
        let date = DateFormatter()
        date.locale = Locale(identifier: "en_KR")
        date.dateFormat = "yyyy MM/dd"
        
        return date
    }
    
    //21 11/28
    static var yearDayFormat4: DateFormatter {
        let date = DateFormatter()
        date.locale = Locale(identifier: "en_KR")
        date.dateFormat = "yy M/d"
        
        return date
    }
    
    static var yearDayFormat4_2: DateFormatter {
        let date = DateFormatter()
        date.locale = Locale(identifier: "en_KR")
        date.dateFormat = "yy MM/dd"
        
        return date
    }
    
    /*
     /////////////////////////////////////////////////
     /////////////////////////////////////////////////
     */
    
    
    //11.28
    static var dayFormat1: DateFormatter {
        let date = DateFormatter()
        date.locale = Locale(identifier: "en_KR")
        date.dateFormat = "M.d"
        
        return date
    }
    
    static var dayFormat1_2: DateFormatter {
        let date = DateFormatter()
        date.locale = Locale(identifier: "en_KR")
        date.dateFormat = "MM.dd"
        
        return date
    }
    
    //11/28
    static var dayFormat2: DateFormatter {
        let date = DateFormatter()
        date.locale = Locale(identifier: "en_KR")
        date.dateFormat = "M/d"
        
        return date
    }
    
    static var dayFormat2_2: DateFormatter {
        let date = DateFormatter()
        date.locale = Locale(identifier: "en_KR")
        date.dateFormat = "MM/dd"
        
        return date
    }
    
    //nov 28
    static var dayFormat3: DateFormatter {
        let date = DateFormatter()
        date.locale = Locale(identifier: "en_KR")
        date.dateFormat = "MMM d"
        
        return date
    }
    
    static var dayFormat3_2: DateFormatter {
        let date = DateFormatter()
        date.locale = Locale(identifier: "en_KR")
        date.dateFormat = "MMM dd"
        
        return date
    }
    
    //nov.28
    static var dayFormat4: DateFormatter {
        let date = DateFormatter()
        date.locale = Locale(identifier: "en_KR")
        date.dateFormat = "MMM d"
        
        return date
    }
    
    static var dayFormat4_2: DateFormatter {
        let date = DateFormatter()
        date.locale = Locale(identifier: "en_KR")
        date.dateFormat = "MMM dd"
        
        return date
    }
    
    //november 28
    static var dayFormat5: DateFormatter {
        let date = DateFormatter()
        date.locale = Locale(identifier: "en_KR")
        date.dateFormat = "MMMM d"
        
        return date
    }
    
    static var dayFormat5_2: DateFormatter {
        let date = DateFormatter()
        date.locale = Locale(identifier: "en_KR")
        date.dateFormat = "MMMM dd"
        
        return date
    }
    
    /*
     /////////////////////////////////////////////////
     /////////////////////////////////////////////////
     */
    
    
    //시간 format
    //5:25
    static var timeFormat1: DateFormatter {
        let date = DateFormatter()
        date.dateFormat = "h:m"

        return date
    }
    
    static var timeFormat1_2: DateFormatter {
        let date = DateFormatter()
        date.dateFormat = "hh:mm"

        return date
    }
    
    //17:25
    static var timeFormat2: DateFormatter {
        let date = DateFormatter()
        date.dateFormat = "H:m"
        
        return date
    }
    
    static var timeFormat2_2: DateFormatter {
        let date = DateFormatter()
        date.dateFormat = "HH:mm"
        
        return date
    }

    //PM 5:25
    static var timeFormat3: DateFormatter {
        let date = DateFormatter()
        date.dateFormat = "a H:m"
        
        return date
    }
    
    static var timeFormat3_2: DateFormatter {
        let date = DateFormatter()
        date.dateFormat = "a HH:mm"
        
        return date
    }

    

}
