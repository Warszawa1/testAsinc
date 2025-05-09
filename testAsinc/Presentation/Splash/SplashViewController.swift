//
//  SplashViewController.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//


import UIKit

class SplashViewController: UIViewController {
    
    // MARK: - Properties
    private var secureData = SecureDataService.shared
    
    // MARK: - UI Components
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "star.circle.fill") // Replace with your actual logo
        imageView.tintColor = .systemBlue
        return imageView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Small delay to ensure smooth transition from launch screen
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.checkAuthAndNavigate()
        }
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            logoImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    // MARK: - Navigation
    private func checkAuthAndNavigate() {
        if secureData.getToken() != nil {
            let heroesVC = HeroesViewController()
            navigationController?.pushViewController(heroesVC, animated: false)
        } else {
            let loginController = LoginViewController()
            navigationController?.pushViewController(loginController, animated: true)
        }
    }
}
