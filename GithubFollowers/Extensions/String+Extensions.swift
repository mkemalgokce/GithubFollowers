//
//  String+Extensions.swift
//  GithubFollowers
//
//  Created by Mustafa Kemal Gökçe on 8.02.2024.
//

import Foundation

extension String {
    
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = .init(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current
        
        return dateFormatter.date(from: self)
    }
    
    func convertToDisplayFormat() -> String {
        guard let date = convertToDate() else { return "N/A"}
        return date.convertToMonthYearFormat()
    }
}
