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
    let service: FollowerAPI
    var followers: [Follower] = []
    
    weak var delegate: FollowerListViewModelDelegate?
    
    init(username: String, service: FollowerAPI = NetworkManager.shared) {
        self.username = username
        self.service = service
    }
    
    func getFollowerList() {
        delegate?.didStartLoading()
        
        service.getFollowers(for: username, page: 1) { [weak self] result in
            switch result {
                case .success(let success):
                    self?.followers = success
                    self?.delegate?.didFinishLoadingSuccessfully()
                case .failure(let failure):
                    self?.delegate?.didFinishLoadingWithError(failure)
            }
        }
        
    }
}
