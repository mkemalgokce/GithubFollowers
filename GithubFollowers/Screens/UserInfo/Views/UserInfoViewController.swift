//
//  UserInfoViewController.swift
//  GithubFollowers
//
//  Created by Mustafa Kemal Gökçe on 8.02.2024.
//

import UIKit

class UserInfoViewController: UIViewController {

    private let viewModel: UserInfoViewModel
    private let headerView = UIView()
    private let itemViewOne = UIView()
    private let itemViewTwo = UIView()
    
    init(username: String) {
        self.viewModel = UserInfoViewModel(username: username)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureNavigationBar()
        viewModel.delegate = self
        viewModel.fetchUserInfo()
        
    }
    
    @objc private func doneBarButtonTapped() {
        dismiss(animated: true)
    }
    
    private func add(child: UIViewController, to containerView: UIView) {
        addChild(child)
        containerView.addSubview(child.view)
        
        child.view.frame = containerView.bounds
        child.didMove(toParent: self)
    }
}

// MARK: - Configure UI Items
extension UserInfoViewController {
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        let itemViews = [headerView, itemViewOne, itemViewTwo]
        
        for (index, itemView) in itemViews.enumerated() {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                itemView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            ])
            
        }
        
        itemViewOne.backgroundColor = .yellow
        itemViewTwo.backgroundColor = .purple
        
    
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            itemViewOne.heightAnchor.constraint(equalToConstant: 140),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: 20),
            itemViewTwo.heightAnchor.constraint(equalToConstant: 140),
            
        ])
    }
    
    private func configureNavigationBar() {
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneBarButtonTapped))
        navigationItem.rightBarButtonItem = doneButton
    }
}


// MARK: UserInfoViewModel delegate methods
extension UserInfoViewController: UserInfoViewModelDelegate {
    func didStartLoading() {
        showLoadingView()
    }
    
    func didFinishLoadingSuccessfully() {
        hideLoadingView { [weak self] in
            guard let self, let user = viewModel.user else { return }
            add(child: GFUserInfoHeaderViewController(user: user), to: headerView)
        }
    }
    
    func didFinishLoadingWithError(_ error: Error) {
        hideLoadingView { [weak self] in
            self?.presentGFAlert(title: "Error", message: error.localizedDescription, buttonTitle: "Ok")
        }
    }
    
    
}
