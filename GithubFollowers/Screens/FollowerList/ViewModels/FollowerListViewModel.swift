//
//  FollowerListViewModel.swift
//  GithubFollowers
//
//  Created by Mustafa Kemal Gökçe on 7.02.2024.
//

import Foundation

final class FollowerListViewModel {
    
    var username: String
    
    init(username: String) {
        self.username = username
    }
    
    func getFollowerList(completion: @escaping (Result<[Follower], Error>) -> Void ) {
        NetworkManager.shared.getFollowers(for: username, page: 1, completion: completion)
    }
}
