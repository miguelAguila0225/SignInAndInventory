//
//  RegistrationViewController.swift
//  SignInAndInventory
//
//  Created by OPSolutions on 2/4/23.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    public static let identifier = String(describing: RegistrationViewController.self)
    let firebaseAuthManager = FirebaseAuthenticationManager()
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sign Up"
        setupUI()
    }
    
    func setupUI() {
        signUpButton.layer.cornerRadius = 10
        usernameTextField.autocapitalizationType = .none
        usernameTextField.leftViewMode = .always
        usernameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        
        passwordTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
        passwordTextField.leftViewMode = .always
        passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        
        confirmPasswordTextField.autocapitalizationType = .none
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.leftViewMode = .always
        confirmPasswordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        let (isCredentialsValid, credentialsError) = firebaseAuthManager.checkCredentialsForRegistration(username: usernameTextField.text,
                                                                                                         password: passwordTextField.text,
                                                                                                         passwordConfirm: confirmPasswordTextField.text)
        if isCredentialsValid == true {
            firebaseAuthManager.registerUser(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "", completion: {
                success, error in
                if success == true {
                    self.showAlertForSaveSuccess()
                } else {
                    self.showAlert(title: "Registration Failed", message: error ?? "")
                }
            })
        } else {
            showAlert(title: "Registration Failed", message: credentialsError ?? "")
        }
    }
    
    private func showAlertForSaveSuccess() {
        let alert = UIAlertController(title: "Registration Successful",
                                      message: "\(self.usernameTextField.text ?? "") registered",
                                      preferredStyle: UIAlertController.Style.alert)
        self.present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.dismiss(animated: true) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
