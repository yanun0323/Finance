//
//  File.swift
//  
//
//  Created by Yanun on 2022/5/8.
//

import SwiftUI

enum Repeated: Identifiable, CaseIterable{
    var id: String { self.name }
    case none
    case day
    case week
    case month
    case year
    case forever
    
    var name: String {
        switch self {
            case .none:
                return "無"
            case .day:
                return "每天"
            case .week:
                return "每週"
            case .month:
                return "每月"
            case .year:
                return "每年"
            case .forever:
                return "永久"
        }
    }
    
    func DateOffset(date: Date) -> Date? {
        switch self {
            case .none:
                return nil
            case .day:
                return date.AddDay(day: 1).Prev()
            case .week:
                return date.AddWeek(week: 1).Prev()
            case .month:
                return date.AddMonth(month: 1).Prev()
            case .year:
                return date.AddYear(year: 1).Prev()
            case .forever:
                return nil
        }
    }
}

