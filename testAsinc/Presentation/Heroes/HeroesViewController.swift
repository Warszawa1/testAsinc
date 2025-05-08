//
//  HeroesViewController.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//

// Presentation/Heroes/HeroesViewController.swift
import UIKit

class HeroesViewController: UIViewController {
    
    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.register(HeroCell.self, forCellWithReuseIdentifier: HeroCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Properties
    private var heroes: [Hero] = []
    private let heroesService: HeroesServiceProtocol
    
    // MARK: - Initialization
    init(heroesService: HeroesServiceProtocol = HeroesService()) {
        self.heroesService = heroesService
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
        loadHeroes()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Heroes"
        
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        title = "heroes.title".localized
        navigationItem.hidesBackButton = true // Prevent going back to login
        
        // Create logout button with proper icon
        let logoutButton = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
            style: .plain,
            target: self,
            action: #selector(logoutTapped)
        )
        logoutButton.tintColor = .systemRed
        
        navigationItem.rightBarButtonItem = logoutButton
    }

    
    // MARK: - Data Loading
    private func loadHeroes() {
        activityIndicator.startAnimating()
        
        heroesService.getHeroes { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                
                switch result {
                case .success(let heroes):
                    self?.heroes = heroes
                    self?.collectionView.reloadData()
                case .failure(let error):
                    self?.showError(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Actions
    @objc private func logoutTapped() {
        // Create confirmation alert
        let alert = UIAlertController(
            title: "logout.confirm.title".localized,
            message: "logout.confirm.message".localized,
            preferredStyle: .alert
        )
        
        // Cancel action
        alert.addAction(UIAlertAction(
            title: "common.cancel".localized,
            style: .cancel,
            handler: nil
        ))
        
        // Logout action
        alert.addAction(UIAlertAction(
            title: "logout.confirm.button".localized,
            style: .destructive,
            handler: { [weak self] _ in
                // Perform logout
                self?.performLogout()
            }
        ))
        
        // Present the alert
        present(alert, animated: true)
    }

    private func performLogout() {
        // Clear the token
        SecureDataService.shared.clearToken()
        
        // Navigate back to login screen
        if let loginVC = navigationController?.viewControllers.first {
            navigationController?.popToViewController(loginVC, animated: true)
        } else {
            // If no login in stack, create new one
            let loginVC = LoginViewController()
            navigationController?.setViewControllers([loginVC], animated: true)
        }
    }
    
    // MARK: - Helpers
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            // Force collection view layout update after orientation change
            self.collectionView.collectionViewLayout.invalidateLayout()
        })
    }
}

// MARK: - UICollectionViewDataSource
extension HeroesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heroes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroCell.identifier, for: indexPath) as? HeroCell else {
            return UICollectionViewCell()
        }
        
        let hero = heroes[indexPath.item]
        cell.configure(with: hero)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HeroesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let hero = heroes[indexPath.item]
        
        // Create the view model with hero and service (defaults to HeroDetailService())
        let heroDetailViewModel = HeroDetailViewModel(hero: hero)
        
        // Create the view controller with the view model
        let detailVC = HeroDetailViewController(viewModel: heroDetailViewModel)
        
        // Navigate to hero detail
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HeroesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Determine number of columns based on orientation
        let isLandscape = UIDevice.current.orientation.isLandscape
        let numberOfColumns: CGFloat = isLandscape ? 3 : 2
        
        // Calculate available width accounting for spacing
        let spacing: CGFloat = 16
        let availableWidth = collectionView.bounds.width - (spacing * (numberOfColumns + 1))
        let itemWidth = availableWidth / numberOfColumns
        
        // Use a 2:3 aspect ratio
        return CGSize(width: itemWidth, height: itemWidth * 1.5)
    }
}
