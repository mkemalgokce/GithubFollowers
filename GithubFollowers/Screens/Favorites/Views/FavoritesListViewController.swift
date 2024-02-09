//
//  FavoritesListViewController.swift
//  GithubFollowers
//
//  Created by Mustafa Kemal Gökçe on 7.02.2024.
//

import UIKit

final class FavoritesListViewController: UIViewController {
    
    private let viewModel = FavoritesListViewModel()
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFavorites()
    }
}

//MARK: - Configure UI methods
extension FavoritesListViewController {
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.identifier)
    }
}

//MARK: - UITableViewDelegate&DataSource methods
extension FavoritesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count:", viewModel.favoriteCount)
        return viewModel.favoriteCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.identifier, for: indexPath) as? FavoriteTableViewCell else { return UITableViewCell() }
        guard let favorite = viewModel.favorite(on: indexPath) else { return cell }
        cell.set(favorite: favorite)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let favorite = viewModel.favorite(on: indexPath) else { return }
        let destViewController = FollowerListViewController(username: favorite.login)
        destViewController.title = favorite.login
        
        navigationController?.pushViewController(destViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        viewModel.delete(on: indexPath)
    }
    
    
}
//MARK: - FavoritesViewModelDelegate methods
extension FavoritesListViewController: FavoritesViewModelDelegate {
    func didStartLoading() {
        print("Start.")
        showLoadingView()
    }
    
    func didFinishDeletingSuccessfully() {
        print("Finish1.")
        hideLoadingView { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func didFinishLoadingWithError(_ error: Error) {
        print("Finish2.")
        hideLoadingView { [weak self] in
            self?.presentGFAlert(title: "Error", message: error.localizedDescription, buttonTitle: "Ok")
        }
    }
    
    func didFinishFetchingSuccessfully() {
        print("Finish3.")
        hideLoadingView { [weak self] in
            guard let self else { return }
            if viewModel.favoriteCount == 0 {
                showEmptyStateView(with: "No Favorites?\nAdd one on the follower screen.", in: view)
            }else {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    tableView.reloadData()
                    view.bringSubviewToFront(tableView)
                }
            }
        }
        
    }
    
    
}
