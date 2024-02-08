//
//  UserInfoViewController.swift
//  GithubFollowers
//
//  Created by Mustafa Kemal Gökçe on 8.02.2024.
//

import UIKit

protocol UserInfoViewControllerDelegate: AnyObject {
    func didTapGithubProfile()
    func didTapGetFollowers()
}

class UserInfoViewController: UIViewController {

    private let viewModel: UserInfoViewModel
    private let headerView = UIView()
    private let itemViewOne = UIView()
    private let itemViewTwo = UIView()
    private let dateLabel = GFBodyLabel(textAlignment: .center)
    
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
        
        let itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        
        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                itemView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            ])
            
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            itemViewOne.heightAnchor.constraint(equalToConstant: 140),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: 20),
            itemViewTwo.heightAnchor.constraint(equalToConstant: 140),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: 20),
            dateLabel.heightAnchor.constraint(equalToConstant: 18),
            
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
            createChildViewControllers(user: user)
            dateLabel.text = "Github since \(user.createdAt.convertToDisplayFormat())"
        }
    }
    
    private func createChildViewControllers(user: User) {
        let repoViewController = GFRepoItemViewController(user: user)
        let followerViewController = GFFollowerItemViewController(user: user)
        
        repoViewController.delegate = self
        followerViewController.delegate = self
        
        add(child: GFUserInfoHeaderViewController(user: user), to: headerView)
        add(child: repoViewController, to: itemViewOne)
        add(child: followerViewController, to: itemViewTwo)
    }
    
    func didFinishLoadingWithError(_ error: Error) {
        hideLoadingView { [weak self] in
            self?.presentGFAlert(title: "Error", message: error.localizedDescription, buttonTitle: "Ok")
        }
    }
    
    
}


// MARK: - UserInfoViewController delegate methods
extension UserInfoViewController: UserInfoViewControllerDelegate {
    func didTapGithubProfile() {
        //TODO: open safari
    }
    
    func didTapGetFollowers() {
        //TODO: show followerlist viewcontroller
    }
    
}
