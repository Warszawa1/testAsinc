//
//  HeroDetailViewController.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//


import UIKit
import Kingfisher
import Combine

class HeroDetailViewController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .justified
        label.numberOfLines = 0
        return label
    }()
    
    private let transformationsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.text = String(localized: "detail.transformations")
        return label
    }()
    
    private let transformationsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 150)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let noTransformationsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.text = String(localized: "detail.noTransformations")
        label.isHidden = true
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Properties
    private let viewModel: HeroDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(viewModel: HeroDetailViewModel) {
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
        setupCollectionView()
        setupBindings()
        
        // Load data
        viewModel.loadData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = viewModel.hero.name
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(heroImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(transformationsLabel)
        contentView.addSubview(transformationsCollectionView)
        contentView.addSubview(noTransformationsLabel)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            heroImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            heroImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            heroImageView.widthAnchor.constraint(equalToConstant: 200),
            heroImageView.heightAnchor.constraint(equalToConstant: 200),
            
            nameLabel.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            transformationsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            transformationsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            transformationsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            transformationsCollectionView.topAnchor.constraint(equalTo: transformationsLabel.bottomAnchor, constant: 8),
            transformationsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            transformationsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            transformationsCollectionView.heightAnchor.constraint(equalToConstant: 150),
            transformationsCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            noTransformationsLabel.topAnchor.constraint(equalTo: transformationsLabel.bottomAnchor, constant: 8),
            noTransformationsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            noTransformationsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            noTransformationsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Configure with hero
        nameLabel.text = viewModel.hero.name
        descriptionLabel.text = viewModel.hero.description
        
        // Load hero image with Kingfisher
        if let photoURLString = viewModel.hero.photo, let photoURL = URL(string: photoURLString) {
            heroImageView.kf.setImage(
                with: photoURL,
                placeholder: UIImage(systemName: "person.fill"),
                options: [
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            )
        } else {
            heroImageView.image = UIImage(systemName: "person.fill")
        }
    }
    
    
    
    private func setupCollectionView() {
        transformationsCollectionView.delegate = self
        transformationsCollectionView.dataSource = self
        transformationsCollectionView.register(TransformationCell.self, forCellWithReuseIdentifier: "TransformationCell")
    }
    
    private func setupBindings() {
        // Observe transformations
        viewModel.$transformations
            .receive(on: RunLoop.main)
            .sink { [weak self] transformations in
                self?.updateTransformationsUI(transformations: transformations)
            }
            .store(in: &cancellables)
        
        // Observe state
        viewModel.$state
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                self?.updateUI(with: state)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - UI Updates
    private func updateUI(with state: HeroDetailState) {
        switch state {
        case .initial:
            activityIndicator.stopAnimating()
        case .loading:
            activityIndicator.startAnimating()
        case .loaded:
            activityIndicator.stopAnimating()
            UIView.animate(withDuration: 0.3) {
                self.transformationsCollectionView.alpha = 1.0
            }
        case .error(let message):
            activityIndicator.stopAnimating()
            showErrorAlert(message: message)
        }
    }
    
    private func updateTransformationsUI(transformations: [Transformation]) {
        if transformations.isEmpty {
            transformationsCollectionView.isHidden = true
            noTransformationsLabel.isHidden = false
        } else {
            transformationsCollectionView.isHidden = false
            noTransformationsLabel.isHidden = true
            transformationsCollectionView.reloadData()
        }
    }
    
    // MARK: - Helpers
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "common.error".localized,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "common.ok".localized,
            style: .default
        ))
        
        present(alert, animated: true)
    }
    
    // MARK: - Show Transformation Detail
    private func showTransformationDetail(transformation: Transformation) {
        let transformationVC = TransformationDetailViewController(transformation: transformation)
        present(transformationVC, animated: true)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension HeroDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.transformations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransformationCell", for: indexPath) as? TransformationCell else {
            return UICollectionViewCell()
        }
        
        let transformation = viewModel.transformations[indexPath.item]
        cell.configure(with: transformation)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let transformation = viewModel.transformations[indexPath.item]
        showTransformationDetail(transformation: transformation)
    }
}
