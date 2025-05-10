//
//  HeroesViewController.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//


import UIKit
import Combine

enum HeroesSections {
    case main
}

class HeroesViewController: UIViewController {
    
    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    // MARK: - Properties
    typealias Datasource = UICollectionViewDiffableDataSource<HeroesSections, Hero>
    
    private var heroes: [Hero] = []
    private var datasource: Datasource?
    private let viewModel: HeroesViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(viewModel: HeroesViewModel = HeroesViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        configureCollectionView()
        setupBindings()
        loadHeroes()
    }
    
    private func setupBindings() {
        viewModel.$heroes
            .receive(on: RunLoop.main)
            .sink { [weak self] heroes in
                self?.heroes = heroes
                self?.updateDataSource()
            }
            .store(in: &cancellables)
        
        viewModel.$state
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                switch state {
                case .error(let message):
                    self?.showErrorAlert(message: message)
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCollectionViewLayout() // Update layout after view is laid out
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Add collectionView to view hierarchy
        view.addSubview(collectionView)
        
        // Set constraints
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        title = "Heroes"
        
        navigationItem.hidesBackButton = true
        
        // Create a logout button with a system icon
        let logoutButton = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
            style: .plain,
            target: self,
            action: #selector(logoutTapped)
        )
        logoutButton.tintColor = .systemRed
        
        // Set it as the right bar button item
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    func configureCollectionView() {
        // layout with 2 columns
        let layout = UICollectionViewFlowLayout()
        
        // Set reasonable defaults initially (will be updated in viewWillLayoutSubviews)
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        // Apply the layout
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        
        // Register cell
        collectionView.register(HeroCell.self, forCellWithReuseIdentifier: HeroCell.identifier)
        
        // Configure diffable data source
        datasource = Datasource(collectionView: collectionView, cellProvider: { collectionView, indexPath, hero in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroCell.identifier, for: indexPath) as? HeroCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: hero)
            return cell
        })
    }
    
    private func updateCollectionViewLayout() {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        // Get current width and make sure it's valid
        let availableWidth = collectionView.bounds.width
        guard availableWidth > 0 else { return } // Skip if width is zero or negative
        
        // Calculate item size based on current screen width
        let spacing: CGFloat = 8
        let numberOfColumns: CGFloat = availableWidth > 500 ? 3 : 2 // Use 3 columns for wider screens
        
        // Calculate width ensuring it's positive
        let itemWidth = max(50, (availableWidth - spacing * (numberOfColumns - 1) - 16) / numberOfColumns)
        
        // Update the item size with a safe value
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        // Invalidate layout to force recalculation
        layout.invalidateLayout()
    }
    
    // MARK: - Data Loading
    private func loadHeroes() {
        viewModel.loadHeroes()
    }
    
    private func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<HeroesSections, Hero>()
        snapshot.appendSections([.main])
        snapshot.appendItems(heroes, toSection: .main)
        datasource?.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - Helper Methods
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc func logoutTapped(_ sender: Any) {
        // Create confirmation alert
        let alert = UIAlertController(
            title: "Logout",
            message: "Are you sure you want to log out?",
            preferredStyle: .alert
        )
        
        // Cancel action
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        ))
        
        // Logout action
        alert.addAction(UIAlertAction(
            title: "Logout",
            style: .destructive,
            handler: { [weak self] _ in
                // Perform logout
                SecureDataService.shared.clearToken()
                
                // Navigate to login screen
                let loginController = LoginViewController()
                self?.navigationController?.setViewControllers([loginController], animated: true)
            }
        ))
        
        // Present the alert
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDelegate
extension HeroesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row < heroes.count else { return }
        
        let hero = heroes[indexPath.row]
        let viewModel = HeroDetailViewModel(hero: hero)
        let heroDetail = HeroDetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(heroDetail, animated: true)
    }
}
