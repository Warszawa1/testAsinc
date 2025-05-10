//
//  LoginViewController.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    
    // MARK: - UI Elements
    private let logoImageView = UIImageView()
    private let usernameTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Dependencies
    private let viewModel: LoginViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(viewModel: LoginViewModel = LoginViewModel()) {
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
        setupKeyboardHandling()
        setupBindings()  // New method for Combine bindings
        
        // Hide back button
        navigationItem.hidesBackButton = true
        
        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Setup Bindings
    private func setupBindings() {
        // Bind text fields to view model
        usernameTextField.textPublisher
            .map { $0 ?? "" }  // Convert optional to non-optional
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .assign(to: \.email, on: viewModel)
            .store(in: &cancellables)
        
        passwordTextField.textPublisher
            .map { $0 ?? "" }  // Convert optional to non-optional
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .assign(to: \.password, on: viewModel)
            .store(in: &cancellables)
        
        // Bind login button tap to view model trigger
        loginButton.tapPublisher
            .sink { [weak self] _ in
                self?.dismissKeyboard()
                self?.viewModel.loginTrigger.send()
            }
            .store(in: &cancellables)
        
        // Bind view model state to UI
        viewModel.$state
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                self?.updateUI(with: state)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - UI Updates
    private func updateUI(with state: LoginState) {
        switch state {
        case .initial:
            showLoading(false)
        case .loading:
            showLoading(true)
        case .success:
            showLoading(false)
            navigateToHeroesList()
        case .error(let message):
            showLoading(false)
            // First show the visual feedback
            showLoginError()
            // Then show the alert with a small delay to avoid conflicts
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.showError(message: message)
            }
        }
    }

    
    // MARK: - UI Setup
    private func setupUI() {
        // Set background to light
        view.backgroundColor = .systemBackground
        
        // Add a scroll view for better keyboard handling
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // Add a content view inside scroll view
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Set up scroll view constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Setup logo image view
        logoImageView.image = UIImage(named:"boladragon")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(logoImageView)
        
        // Setup username text field - system appearance
        usernameTextField.placeholder = "Usuario"
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.backgroundColor = UIColor.systemGray6
        usernameTextField.textColor = .label
        usernameTextField.autocapitalizationType = .none
        usernameTextField.autocorrectionType = .no
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(usernameTextField)
        
        // Setup password text field - system appearance
        passwordTextField.placeholder = "Contraseña"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.backgroundColor = UIColor.systemGray6
        passwordTextField.textColor = .label
        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(passwordTextField)
        
        // Setup login button - system appearance
        loginButton.setTitle("Continuar", for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        loginButton.setTitleColor(.systemBlue, for: .normal)
        loginButton.layer.cornerRadius = 8
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(loginButton)
        
        // Setup activity indicator - system appearance
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .gray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isHidden = true
        contentView.addSubview(activityIndicator)
        
        // Layout constraints - position elements higher on screen
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 80), // Higher position
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 120),
            logoImageView.heightAnchor.constraint(equalToConstant: 120),
            
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            usernameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            usernameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 10),
            passwordTextField.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            // Make content view taller to allow scrolling when keyboard appears
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        ])
    }
    
    // MARK: - Keyboard Handling
    private func setupKeyboardHandling() {
        // Register for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if let scrollView = view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView {
                // Add inset to allow scrolling when keyboard is shown
                scrollView.contentInset.bottom = keyboardSize.height
                scrollView.verticalScrollIndicatorInsets.bottom = keyboardSize.height
                
                // Scroll to the active text field
                if let activeField = [usernameTextField, passwordTextField].first(where: { $0.isFirstResponder }) {
                    let rect = activeField.convert(activeField.bounds, to: scrollView)
                    scrollView.scrollRectToVisible(rect.insetBy(dx: 0, dy: -80), animated: true)
                }
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        if let scrollView = view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView {
            // Reset insets when keyboard is hidden
            scrollView.contentInset.bottom = 0
            scrollView.verticalScrollIndicatorInsets.bottom = 0
        }
    }
    
    // MARK: - Cleanup
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Helper Methods
    private func showLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            loginButton.isEnabled = false
            usernameTextField.isEnabled = false
            passwordTextField.isEnabled = false
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            loginButton.isEnabled = true
            usernameTextField.isEnabled = true
            passwordTextField.isEnabled = true
        }
    }
    
    private func showError(message: String) {
        // Show the shake animation first
        showLoginError()
        
        // Then show the alert
        let alert = UIAlertController(
            title: "Error de Login",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
    
    private func showLoginError() {
        // Subtle shake animation for the login form
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        loginButton.layer.add(animation, forKey: "shake")
        
        // Briefly highlights the fields in red for light theme
        UIView.animate(withDuration: 0.2, animations: {
            self.usernameTextField.backgroundColor = UIColor.red.withAlphaComponent(0.2)
            self.passwordTextField.backgroundColor = UIColor.red.withAlphaComponent(0.2)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.usernameTextField.backgroundColor = UIColor.systemGray6
                self.passwordTextField.backgroundColor = UIColor.systemGray6
            }
        }
    }
    
    private func navigateToHeroesList() {
        let heroesVC = HeroesViewController()
        navigationController?.setViewControllers([heroesVC], animated: true)
    }
}




