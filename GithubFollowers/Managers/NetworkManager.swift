//
//  NetworkManager.swift
//  GithubFollowers
//
//  Created by Mustafa Kemal Gökçe on 7.02.2024.
//

import Foundation

protocol FollowerAPIProtocol {
    func getFollowers(for username: String, page: Int, completion: @escaping (Result<[Follower], Error>) -> Void)
}

final class FollowerAPI: FollowerAPIProtocol {
    enum EndPoint {
        static let baseUrl = "https://api.github.com"
        case followers(username: String, page: Int)
        
        var url: URL? {
            switch self {
                case .followers(let username, let page):
                    URL(string: "\(Self.baseUrl)/users/\(username)/followers?per_page=100&page=\(page)")
            }
        }
    }
    
    func getFollowers(for username: String, page: Int, completion: @escaping (Result<[Follower], Error>) -> Void) {
        guard let url = EndPoint.followers(username: username, page: page).url else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }
       
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else { completion(.failure(error!)); return }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(NetworkError.badResponse))
                return
            }
            
            guard let data else { completion(.failure(NetworkError.invalidData)); return }
            
            do {
                let decoded = try JSONDecoder().decode([Follower].self, from: data)
                completion(.success(decoded))
            }catch {
                completion(.failure(error))
            }
            
        }.resume()
       
    }
    
}
