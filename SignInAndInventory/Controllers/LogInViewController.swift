//
//  LogInViewController.swift
//  SignInAndInventory
//
//  Created by OPSolutions on 2/4/23.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    public static let identifier = String(describing: LogInViewController.self)
    let firebaseAuthManager = FirebaseAuthenticationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LogIn
        setupLogInUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func setupLogInUI() {
        signInButton.layer.cornerRadius = 10
        usernameTextField.autocapitalizationType = .none
        usernameTextField.leftViewMode = .always
        usernameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        
        passwordTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
        passwordTextField.leftViewMode = .always
        passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
    }
    
    
    @IBAction func didTapSignIn(_ sender: Any) {
        let (isValidCredentails, error) = firebaseAuthManager.checkCredentialsForSignIn(username: usernameTextField.text, password: passwordTextField.text)
        if isValidCredentails == true {
            firebaseAuthManager.signInUser(username: usernameTextField.text ?? EmptyString,
                                           password: passwordTextField.text ?? EmptyString) { success, error in
                if success == true {
                    self.dismiss(animated: true)
                } else {
                    self.showAlert(title: SignInErrorTitle, message: error ?? SignInError)
                }
            }
        } else {
            showAlert(title: SignInErrorTitle , message: error ?? SignInError)
        }
    }
    
    @IBAction func didTapRegister(_ sender: Any) {
        presentRegistrationView()
    }
    
    func presentRegistrationView() {
        let storyboard = UIStoryboard(name: Main, bundle: Bundle.main)
        let registrationViewController = storyboard.instantiateViewController(withIdentifier: RegistrationViewController.identifier) as! RegistrationViewController
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(registrationViewController, animated: true)
        }
       
    }
}
