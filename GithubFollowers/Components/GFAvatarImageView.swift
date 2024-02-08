//
//  GFAvatarImageView.swift
//  GithubFollowers
//
//  Created by Mustafa Kemal Gökçe on 7.02.2024.
//

import UIKit

final class GFAvatarImageView: UIImageView {
    
    private let placeholderImage = UIImage(resource: .avatarPlaceholder)
    
    private var downloader: ImageDownloaderProtocol?
    
    init() {
        super.init(frame: .zero)
        downloader = ImageDownloader.shared
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImage(from urlString: String) {
        downloader?.download(from: urlString, completion: { [weak self] data in
            self?.updateImage(from: data)
        })
    }
    
    private func updateImage(from data: Data?) {
        if let data, let image = UIImage(data: data) {
            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
        }
    }
}
