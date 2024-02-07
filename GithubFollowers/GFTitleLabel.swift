//
//  GFTitleLabel.swift
//  GithubFollowers
//
//  Created by Mustafa Kemal Gökçe on 7.02.2024.
//

import UIKit

final class GFTitleLabel: UILabel {

    convenience init() {
        self.init()
        configure()
    }
    
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        font = .systemFont(ofSize: fontSize, weight: .bold)
        configure()
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        textColor = .label // black on white screen, white on black screen
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail // like asdasd...
        
    }
}
