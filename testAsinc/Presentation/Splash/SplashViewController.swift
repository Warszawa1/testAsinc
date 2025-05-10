//
//  SplashViewController.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//


import UIKit

class SplashViewController: UIViewController {
    
    private var secureData = SecureDataService.shared
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .systemOrange
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Start animation immediately
        activityIndicator.startAnimating()
        
        // Add a longer delay to ensure proper initialization
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.checkAuthAndNavigate()
        }
    }
    
    private func setupUI() {
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func checkAuthAndNavigate() {
        let destinationVC: UIViewController
        
        // More defensive check
        let token = secureData.getToken()
        print("DEBUG: Token check - Token exists: \(token != nil)")
        
        if let token = token, !token.isEmpty {
            // Additional validation - check if token looks valid
            if isValidToken(token) {
                destinationVC = HeroesViewController()
            } else {
                // Invalid token, clear it and go to login
                secureData.clearToken()
                destinationVC = LoginViewController()
            }
        } else {
            destinationVC = LoginViewController()
        }
        
        // Stop animation before navigation
        activityIndicator.stopAnimating()
        
        // Quick fade transition
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = .fade
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.setViewControllers([destinationVC], animated: false)
    }
    
    private func isValidToken(_ token: String) -> Bool {
        // Basic validation - token should not be empty or whitespace
        let trimmedToken = token.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmedToken.isEmpty && trimmedToken.count > 10  // Assuming tokens are at least 10 chars
    }
}
