//
//  ImageDownloader.swift
//  GithubFollowers
//
//  Created by Mustafa Kemal Gökçe on 8.02.2024.
//

import Foundation

protocol ImageDownloaderProtocol {
    var cache: NSCache<NSString, NSData> { get }
    func download(from urlString: String, completion: @escaping (Data?) -> Void)
}

final class ImageDownloader: ImageDownloaderProtocol {
    var cache =  NSCache<NSString, NSData>()
    
    static let shared = ImageDownloader()
    
    private init() {}
    
    func download(from urlString: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        if let cachedData = cache.object(forKey: urlString as NSString) {
            completion(cachedData as Data)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak cache] data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data else { return completion(nil)}
            
            cache?.setObject(data as NSData, forKey: urlString as NSString)
            completion(data)
            
        }.resume()
    }
    
    
    
}
