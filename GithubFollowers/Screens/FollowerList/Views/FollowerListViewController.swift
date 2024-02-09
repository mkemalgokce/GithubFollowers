//
//  FollowerListViewController.swift
//  GithubFollowers
//
//  Created by Mustafa Kemal Gökçe on 7.02.2024.
//

import UIKit

protocol FollowerListViewControllerDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}

final class FollowerListViewController: UIViewController {

    enum Section { case main }
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
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
        
        configureViewController()
        configureSearchController()
        configureCollectionView()
        configureDataSource()
        
        viewModel.delegate = self
        viewModel.fetchFollowers()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc private func addNavBarButtonItemTapped() {
        viewModel.getUserInfo()
    }
    
}

// MARK: - Configure UI Items
extension FollowerListViewController {
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createThreeColumnFlowLayout())
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCollectionViewCell.self, forCellWithReuseIdentifier: FollowerCollectionViewCell.reuseIdentifier)
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(addNavBarButtonItemTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func createThreeColumnFlowLayout() -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding = 12.0
        let minimumItemSpacing = 10.0
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        
        let itemWidth = availableWidth / 3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowLayout
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower  in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCollectionViewCell.reuseIdentifier, for: indexPath) as? FollowerCollectionViewCell else {
                fatalError("Unknown error occurred on collection view.")
            }
            cell.set(follower: follower)
            return cell
        })
    }
    
    private func configureSearchController() {
        let searchController = UISearchController()
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        searchController.searchBar.placeholder = "Search for a username"
        navigationItem.searchController = searchController
    }
}

// MARK: - ViewModelDelegate methods
extension FollowerListViewController: FollowerListViewModelDelegate {
    func didFinishUserInfoFetchingSuccessfully(_ follower: Follower) {
        hideLoadingView { [weak self] in
            self?.presentGFAlert(title: "Success!", message: "You have successfully favorited this user", buttonTitle: "Hooray!")
        }
    }
    
    private func updateCollectionView(with followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        dataSource.apply(snapshot, animatingDifferences: true)

    }
    
    func didStartLoading() {
        showLoadingView()
    }
    
    func didFinishLoadingSuccessfully() {
        hideLoadingView { [weak self ] in
            guard let self else { return }
            if (viewModel.followers.isEmpty) {
               showEmptyStateView(with: "This user doesn't have any followers. Go follow them 😄", in: view)
            }else {
                print("Update with: \(viewModel.followers)")
                updateCollectionView(with: viewModel.followers)
            }
        }
    }
    
    func didFinishLoadingWithError(_ error: Error) {
        hideLoadingView()
        presentGFAlert(title: "Error", message: error.localizedDescription, buttonTitle: "Ok")
    }
    
}

//MARK: - UICollectionViewDelegate methods
extension FollowerListViewController: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.bounds.height
        
        if offsetY > contentHeight - height {
            viewModel.fetchFollowers()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let follower = viewModel.get(on: indexPath) else { return }
       
        let destinationViewController = UserInfoViewController(username: follower.login)
        destinationViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: destinationViewController)
        
        present(navigationController, animated: true)
    }
}

//MARK: - UISearchResultsUpdating methods
extension FollowerListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            viewModel.endSearching()
            updateCollectionView(with: viewModel.followers)
            return
        }
        viewModel.filter(filter)
        updateCollectionView(with: viewModel.filteredFollowers)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.endSearching()
        updateCollectionView(with: viewModel.followers)
    }
}

//MARK: - FollowerListViewControllerDelegate methods
extension FollowerListViewController: FollowerListViewControllerDelegate {
    
    func didRequestFollowers(for username: String) {
        viewModel.reset(with: username)
        title = username
        collectionView.setContentOffset(.zero, animated: true)
        viewModel.fetchFollowers()
    }
    
}
