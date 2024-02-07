//
//  Follower.swift
//  GithubFollowers
//
//  Created by Mustafa Kemal Gökçe on 7.02.2024.
//

import Foundation

struct Follower: Codable, Hashable {
    let login: String
    let avatarUrl: String
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
}
