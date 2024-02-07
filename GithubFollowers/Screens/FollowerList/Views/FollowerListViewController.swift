//
//  FollowerListViewController.swift
//  GithubFollowers
//
//  Created by Mustafa Kemal Gökçe on 7.02.2024.
//

import UIKit

final class FollowerListViewController: UIViewController {

    private let viewModel: FollowerListViewModel
    
    init(username: String) {
        viewModel = FollowerListViewModel(username: username)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        viewModel.getFollowerList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}

// MARK: - ViewModelDelegate methods
extension FollowerListViewController: FollowerListViewModelDelegate {
    func didStartLoading() {
        print("Loading")
    }
    
    func didFinishLoadingSuccessfully() {
        print("Finish")
    }
    
    func didFinishLoadingWithError(_ error: Error) {
        print("Error: \(error)")
    }
    
    
}
