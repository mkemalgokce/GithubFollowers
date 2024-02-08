//
//  UserInfoAPI.swift
//  GithubFollowers
//
//  Created by Mustafa Kemal Gökçe on 8.02.2024.
//

import Foundation

protocol UserInfoAPIProtocol {
    func getUserInfo(for username: String, completion: @escaping (Result<User, Error>) -> Void)
}

final class UserInfoAPI: UserInfoAPIProtocol {
    enum EndPoint {
        static let baseUrl = "https://api.github.com"
        case info(username: String)
        
        var url: URL? {
            switch self {
                case .info(let username):
                    URL(string: "\(Self.baseUrl)/users/\(username)")
            }
        }
    }
    
    func getUserInfo(for username: String, completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = EndPoint.info(username: username).url else {
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
                let decoded = try JSONDecoder().decode(User.self, from: data)
                completion(.success(decoded))
            }catch {
                completion(.failure(error))
            }
            
        }.resume()
       
    }
    
}
