//
//  UserInfoViewModel.swift
//  GithubFollowers
//
//  Created by Mustafa Kemal Gökçe on 8.02.2024.
//

import Foundation

protocol UserInfoViewModelDelegate: AnyObject {
    func didStartLoading()
    func didFinishLoadingSuccessfully()
    func didFinishLoadingWithError(_ error: Error)
}

final class UserInfoViewModel {
    
    private let service: UserInfoAPIProtocol
    private let username: String
    private(set) var user: User?
    weak var delegate: UserInfoViewModelDelegate?
    
    init(username: String, service: UserInfoAPIProtocol = UserInfoAPI()) {
        self.username = username
        self.service = service
    }
    
    func fetchUserInfo() {
        delegate?.didStartLoading()
        service.getUserInfo(for: username) { [weak self] result in
            print(result)
            guard let self else { return }
            switch result {
                case .success(let success):
                    user = success
                    delegate?.didFinishLoadingSuccessfully()
                case .failure(let failure):
                    delegate?.didFinishLoadingWithError(failure)
            }
        }
    }
    
}
