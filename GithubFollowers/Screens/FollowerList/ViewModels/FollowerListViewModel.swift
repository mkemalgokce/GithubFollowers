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
    
    let username: String
    private var currentPage: Int = 1
    private var hasMoreFollowers = true
    let service: FollowerAPI
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
            switch result {
                case .success(let success):
                    if success.count < 100 { self?.hasMoreFollowers = false }
                    self?.currentPage += 1
                    self?.followers.append(contentsOf: success)
                    self?.delegate?.didFinishLoadingSuccessfully()
                case .failure(let failure):
                    self?.delegate?.didFinishLoadingWithError(failure)
            }
        }
        
    }
    
    func filter(_ filter: String) {
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased())}
    }
}
