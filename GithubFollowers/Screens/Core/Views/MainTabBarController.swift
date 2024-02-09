//
//  MainTabBarController.swift
//  GithubFollowers
//
//  Created by Mustafa Kemal Gökçe on 7.02.2024.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [
            createSearchNavigationViewController(),
            createFavouritesListNavigationViewController()
        ]
        
    }
    
    func createSearchNavigationViewController() -> UINavigationController {
        let searchViewController = SearchViewController()
        searchViewController.title = "Search"
        searchViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        return UINavigationController(rootViewController: searchViewController)
    }
    
    func createFavouritesListNavigationViewController() -> UINavigationController {
        let favouritesListViewController = FavoritesListViewController()
        favouritesListViewController.title = "Favourites"
        favouritesListViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        return UINavigationController(rootViewController: favouritesListViewController)
    }
  
}

@available(iOS 17, *)
#Preview {
    MainTabBarController()
}
