//
//  UserInfoViewController.swift
//  GithubFollowers
//
//  Created by Mustafa Kemal Gökçe on 8.02.2024.
//

import UIKit

class UserInfoViewController: UIViewController {

    private let viewModel: UserInfoViewModel
    
    init(username: String) {
        self.viewModel = UserInfoViewModel(username: username)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        viewModel.fetchUserInfo()
        
    }

    
    
    @objc private func doneBarButtonTapped() {
        dismiss(animated: true)
    }
}

// MARK: - Configure UI Items
extension UserInfoViewController {
    
    private func configureNavigationBar() {
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneBarButtonTapped))
        navigationItem.rightBarButtonItem = doneButton
    }
}
