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
        
        // Check auth after minimal delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
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
        if secureData.getToken() != nil {
            destinationVC = HeroesViewController()
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
}
