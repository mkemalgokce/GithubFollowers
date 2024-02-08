//
//  GFItemInfoView.swift
//  GithubFollowers
//
//  Created by Mustafa Kemal Gökçe on 8.02.2024.
//

import UIKit

final class GFItemInfoView: UIView {
    
    enum ItemType {
        case repos, gists, followers, following
    }
    
    private let symbolImageView = UIImageView()
    private let titleLabel = GFTitleLabel(textAlignment: .left, fontSize: 14)
    private let countLabel = GFTitleLabel(textAlignment: .left, fontSize: 14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(symbolImageView)
        addSubview(titleLabel)
        addSubview(countLabel)
        
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        symbolImageView.contentMode = .scaleAspectFill
        symbolImageView.tintColor = .label
        
        NSLayoutConstraint.activate([
            symbolImageView.topAnchor.constraint(equalTo: topAnchor),
            symbolImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            symbolImageView.widthAnchor.constraint(equalToConstant: 20),
            symbolImageView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 18),
            
            countLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 4),
            countLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    

    func set(itemType: ItemType, withCount count: Int) {
        switch itemType {
            case .repos:
                symbolImageView.image = UIImage(systemName: "folder")
                titleLabel.text = "Public repos"
            case .gists:
                symbolImageView.image = UIImage(systemName: "text.alignleft")
                titleLabel.text = "Public gists"
            case .followers:
                symbolImageView.image = UIImage(systemName: "heart")
                titleLabel.text = "Followers"
            case .following:
                symbolImageView.image = UIImage(systemName: "person.2")
                titleLabel.text = "Following"
        }
        
        countLabel.text = "\(count)"
    }
}
