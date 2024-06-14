import Foundation
import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    private let loginForm = UIView()
    private var bottomConstraint: Constraint?
    private let tokenTextField = TokenTextField()
    private let loginButton = LoginButton()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfKeychainExists()
        setupView()
        subscribeToKeyboardNotifications()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        tokenTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        resetViewController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func setupView() {
        view.backgroundColor = .white
        addViews()
        styleViews()
        setupConstraints()
        setupGestureRecognizers()
    }
    
    @objc func loginButtonTapped() {
        view.endEditing(true)
        guard let token = tokenTextField.text else { return }
        UserDefaultsService.saveDataToUserDefaults(id: token)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            
            let mainViewController = MainViewController()
            self.navigationController?.pushViewController(mainViewController, animated: true)
        }
        
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: Validation methods
extension LoginViewController {
    
    func showSuccessAlert() {
        let alertController = UIAlertController(title: "Success", message: "Login successful!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showErrorAlert() {
        let alertController = UIAlertController(title: "Error", message: "Invalid email or password", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

//MARK: BaseViewProtocol
extension LoginViewController {
    
    func addViews() {
        view.addSubview(loginForm)
        loginForm.addSubview(tokenTextField)
        loginForm.addSubview(loginButton)
    }
    
    func styleViews() {
        loginForm.backgroundColor = UIColor(white: 0, alpha: 0.7)
        loginForm.layer.cornerRadius = 15
        loginForm.layer.masksToBounds = true
    }
    
    func setupConstraints() {
        
        loginForm.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(240)
            bottomConstraint = $0.bottom.equalToSuperview().inset(100).constraint
        }
        
        tokenTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        loginButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(15)
            $0.leading.trailing.equalToSuperview().inset(80)
        }
    }
    
    func setupGestureRecognizers() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
}

//MARK: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: Additional functions
extension LoginViewController {
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardHeight = keyboardFrame.height
        
        bottomConstraint?.update(offset: -keyboardHeight - 20)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        bottomConstraint?.update(inset: 100)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func checkIfKeychainExists() {
        if(UserDefaultsService.retrieveDataFromUserDefaults() != nil) {
            let mainViewController = MainViewController()
            self.navigationController?.pushViewController(mainViewController, animated: true)
        }
    }
    
    func resetViewController() {
        tokenTextField.text = ""
        loginForm.isHidden = false
        loginForm.alpha = 1.0
        subscribeToKeyboardNotifications()
    }
}

//MARK: UIGestureRecognizerDelegate
extension LoginViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
