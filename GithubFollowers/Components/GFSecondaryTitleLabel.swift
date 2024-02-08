//
//  GFSecondaryTitleLabel.swift
//  GithubFollowers
//
//  Created by Mustafa Kemal Gökçe on 8.02.2024.
//

import UIKit

final class GFSecondaryTitleLabel: UILabel {

    convenience init() {
        self.init()
        configure()
    }
    
    convenience init(fontSize: CGFloat) {
        self.init(frame: .zero)
        self.font = .systemFont(ofSize: fontSize, weight: .medium)
        configure()
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        font = .preferredFont(forTextStyle: .body)
        textColor = .secondaryLabel
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.90
        
        
        lineBreakMode = .byTruncatingTail
        
    }
}
