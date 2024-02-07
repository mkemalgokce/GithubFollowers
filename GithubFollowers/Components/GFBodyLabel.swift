//
//  GFBodyLabel.swift
//  GithubFollowers
//
//  Created by Mustafa Kemal Gökçe on 7.02.2024.
//

import UIKit

final class GFBodyLabel: UILabel {

    convenience init() {
        self.init()
        configure()
    }
    
    convenience init(textAlignment: NSTextAlignment) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        configure()
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        font = .preferredFont(forTextStyle: .body)
        textColor = .secondaryLabel
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.75
        
        
        lineBreakMode = .byWordWrapping // like asdasd...
        
    }

}
