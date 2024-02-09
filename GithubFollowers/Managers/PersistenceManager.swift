//
//  PersistenceManager.swift
//  GithubFollowers
//
//  Created by Mustafa Kemal Gökçe on 9.02.2024.
//

import Foundation

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
    }
    
    enum ActionType {
        case add, remove
    }
    
    enum Error: LocalizedError {
        case alreadyInFavorites
        
        var errorDescription: String? {
            "Already in favourites"
        }
    }
    
    static func retrieveFavorites(completion: @escaping (Result<[Follower], Swift.Error>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completion(.success([]))
            return
        }
        
        do {
            let decoded = try JSONDecoder().decode([Follower].self, from: favoritesData)
            completion(.success(decoded))
        }catch {
            completion(.failure(error))
        }
    }
    
    static func update(with favorite: Follower, actionType: ActionType, completion: @escaping (Swift.Error?) -> Void) {
        retrieveFavorites { result in
            switch result {
                case .success(var favorites):
                    print("Favorites: \(favorites)")
                    switch actionType {
                        case .add:
                            guard !favorites.contains(favorite) else {
                                completion(Error.alreadyInFavorites)
                                return
                            }
                            favorites.append(favorite)
                            
                        case .remove:
                            favorites.removeAll { $0.login == favorite.login}
                    }
                    completion(save(favorites: favorites))
                    
                case .failure(let failure):
                    completion(failure)
            }
        }
    }
    
    static func save(favorites: [Follower]) -> Swift.Error? {
        do {
            let encoded = try JSONEncoder().encode(favorites)
            defaults.setValue(encoded, forKey: Keys.favorites)
            return nil
        }catch {
            return error
        }
    }
    
    
    
}
