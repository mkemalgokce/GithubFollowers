//
//  GFAvatarImageView.swift
//  GithubFollowers
//
//  Created by Mustafa Kemal Gökçe on 7.02.2024.
//

import UIKit

final class GFAvatarImageView: UIImageView {
    
    private let placeholderImage = UIImage(resource: .avatarPlaceholder)
    
    convenience init() {
        self.init(frame: .zero)
        configure()
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImage(from urlString: String) {
        ImageDownloader.shared.download(from: urlString) { [weak self] data in
            self?.updateImage(from: data)
        }
    }
    
    private func updateImage(from data: Data?) {
        if let data, let image = UIImage(data: data) {
            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
        }
    }
}
