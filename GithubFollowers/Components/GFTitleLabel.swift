//
//  GFTitleLabel.swift
//  GithubFollowers
//
//  Created by Mustafa Kemal Gökçe on 7.02.2024.
//

import UIKit

final class GFTitleLabel: UILabel {

    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        self.init()
        self.textAlignment = textAlignment
        font = .systemFont(ofSize: fontSize, weight: .bold)
        
    }
        
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        textColor = .label // black on white screen, white on black screen
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail // like asdasd...
        
    }
}
