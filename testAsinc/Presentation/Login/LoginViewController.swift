//
//  LoginViewController.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//


import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - UI Elements
    private let logoImageView = UIImageView()
    private let usernameTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Dependencies
    private let loginService: LoginServiceProtocol
    
    // MARK: - Initialization
    init(loginService: LoginServiceProtocol = LoginService()) {
        self.loginService = loginService
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
        
        // Hide back button
        navigationItem.hidesBackButton = true
        
        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
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
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 8
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
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
    
    // MARK: - Actions
    @objc func loginButtonTapped() {
        // Show loading state
        showLoading(true)
        
        // Get login credentials
        guard let email = usernameTextField.text, !email.isEmpty else {
            showError(message: "Please enter your email")
            showLoading(false)
            showLoginError()
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            showError(message: "Please enter your password")
            showLoading(false)
            showLoginError()
            return
        }
        
        // Perform login
        loginService.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.showLoading(false)
                
                switch result {
                case .success:
                    // Navigate to heroes list
                    self?.navigateToHeroesList()
                case .failure(let error):
                    // Show error message
                    self?.showError(message: error.localizedDescription)
                    self?.showLoginError()
                }
            }
        }
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
        let alert = UIAlertController(title: "Error de Login", message: message, preferredStyle: .alert)
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
