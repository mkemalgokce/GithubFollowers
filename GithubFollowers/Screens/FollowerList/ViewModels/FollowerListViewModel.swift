//
//  FollowerListViewModel.swift
//  GithubFollowers
//
//  Created by Mustafa Kemal Gökçe on 7.02.2024.
//

import Foundation

protocol FollowerListViewModelDelegate: AnyObject {
    func didStartLoading()
    func didFinishLoadingSuccessfully()
    func didFinishLoadingWithError(_ error: Error)
}

final class FollowerListViewModel {
    
    private let username: String
    private let service: FollowerAPI
    private var currentPage: Int = 1
    private var hasMoreFollowers = true
    
    private var isSearching = false
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    
    weak var delegate: FollowerListViewModelDelegate?
    
    init(username: String, service: FollowerAPI = FollowerAPI()) {
        self.username = username
        self.service = service
    }
    
    func fetchFollowers() {
        guard hasMoreFollowers else { return }
        delegate?.didStartLoading()
        
        service.getFollowers(for: username, page: currentPage) { [weak self] result in
            guard let self else { return }
            switch result {
                case .success(let success):
                    if success.count < 100 { hasMoreFollowers = false }
                    currentPage += 1
                    followers.append(contentsOf: success)
                    delegate?.didFinishLoadingSuccessfully()
                case .failure(let failure):
                    delegate?.didFinishLoadingWithError(failure)
            }
        }
        
    }
  
    func endSearching() {
        isSearching = false
    }
    
    func filter(_ filter: String) {
        isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased())}
    }
    
    func get(on indexPath: IndexPath) -> Follower? {
        let activeArray = isSearching ? filteredFollowers : followers
        if indexPath.item >= activeArray.count { return nil }
        return activeArray[indexPath.item]
    }
}
