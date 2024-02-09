//
//  FavoritesListViewModel.swift
//  GithubFollowers
//
//  Created by Mustafa Kemal Gökçe on 9.02.2024.
//

import Foundation

protocol FavoritesViewModelDelegate: AnyObject {
    func didStartLoading()
    func didFinishFetchingSuccessfully()
    func didFinishDeletingSuccessfully()
    func didFinishLoadingWithError(_ error: Error)
}

final class FavoritesListViewModel {
    
    weak var delegate: FavoritesViewModelDelegate?
    private(set) var favorites: [Follower] = []
    
    var favoriteCount: Int {
        favorites.count
    }
    
    func fetchFavorites() {
        delegate?.didStartLoading()
        PersistenceManager.retrieveFavorites { [weak self] result in
            switch result {
                case .success(let success):
                    self?.favorites = success
                    self?.delegate?.didFinishFetchingSuccessfully()
                case .failure(let failure):
                    self?.delegate?.didFinishLoadingWithError(failure)
            }
        }
    }
    
    func favorite(on indexPath: IndexPath) -> Follower? {
        let index = indexPath.item
        if index < favoriteCount {
            return favorites[index]
        }
        return nil
    }
    
    func delete(on indexPath: IndexPath) {
        let index = indexPath.item
        guard index < favoriteCount else { return }
        let favorite = favorites[index]
        favorites.remove(at: index)
        delegate?.didStartLoading()
        PersistenceManager.update(with: favorite, actionType: .remove) { [weak self] error in
            guard let self else { return }
            if let error {
                delegate?.didFinishLoadingWithError(error)
            }
            delegate?.didFinishDeletingSuccessfully()
        }
    }
}
