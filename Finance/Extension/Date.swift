import SwiftUI

extension Date {
    static public func Format(date: String, format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from:date)
    }
    
    static public func DayKeyFormat() -> String {
        "YYYYMMdd"
    }
    
    static public func MonthKeyFormat() -> String {
        "YYYYMM"
    }
    
    func String(format: String = "YYYY/MM/dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "zh_Hant_TW")
        return dateFormatter.string(from: self)
    }
    func DayKey() -> Date {
        return Date.Format(date: self.String(format: Date.DayKeyFormat()), format: Date.DayKeyFormat())!
    }
    
    func MonthKey() -> String {
        return self.String(format: Date.MonthKeyFormat())
    }
    
    func Next() -> Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self) ?? self
    }
    
    func Prev() -> Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self) ?? self
    }
    
    func AddDay(day: Int) -> Date {
        return self.Add(unit: .day, value: 1)
    }
    
    func AddMonth(month: Int) -> Date {
        return self.Add(unit: .month, value: 1)
    }
    
    func AddYear(year: Int) -> Date {
        return self.Add(unit: .year, value: 1)
    }
    
    func AddWeek(week: Int) -> Date {
        return self.Add(unit: .day, value: 7)
    }
    
    func Add(unit: Calendar.Component, value: Int) -> Date {
        return Calendar.current.date(byAdding: unit, value: value, to: self) ?? self
    }
}
