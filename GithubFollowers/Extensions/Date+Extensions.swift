//
//  Date+Extensions.swift
//  GithubFollowers
//
//  Created by Mustafa Kemal Gökçe on 8.02.2024.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
