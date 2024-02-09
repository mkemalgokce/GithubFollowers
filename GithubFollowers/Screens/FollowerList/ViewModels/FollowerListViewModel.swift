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
    func didFinishUserInfoFetchingSuccessfully(_ follower: Follower)
}

final class FollowerListViewModel {
    
    private(set) var username: String
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
    
    func reset(with username: String) {
        self.username = username
        followers.removeAll()
        filteredFollowers.removeAll()
        hasMoreFollowers = true
        currentPage = 1
    }
    
    func getUserInfo() {
        delegate?.didStartLoading()
        let api = UserInfoAPI()
        api.getUserInfo(for: username) { [weak self] result in
            guard let self else { return }
            switch result {
                case .success(let success):
                    let favorite = Follower(login: success.login, avatarUrl: success.avatarUrl)
                    PersistenceManager.update(with: favorite, actionType: .add) { [weak self] error in
                        if let error {
                            self?.delegate?.didFinishLoadingWithError(error)
                        } else {
                            self?.delegate?.didFinishUserInfoFetchingSuccessfully(favorite)
                        }
                    }
                case .failure(let failure):
                    delegate?.didFinishLoadingWithError(failure)
            }
        }
    }
}
