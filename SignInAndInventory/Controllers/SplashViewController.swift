//
//  ViewController.swift
//  SignInAndInventory
//
//  Created by OPSolutions on 2/3/23.
//

import UIKit
import Firebase
import FirebaseAuth

class SplashViewController: UIViewController {
    
    public static let identifier = String(describing: SplashViewController.self)
    let firebaseAuthManager = FirebaseAuthenticationManager()
    let firestoreManager = FirestoreManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let isSignedIn = self.firebaseAuthManager.isSignedIn()
            
            if isSignedIn == true {
                self.presentInventoryViewController()
            } else {
                self.presentLogInViewController()
            }
        }
    }
    
    func presentLogInViewController() {
        let storyboard = UIStoryboard(name: Main, bundle: Bundle.main)
        guard let loginViewController = storyboard.instantiateViewController(withIdentifier: LogInViewController.identifier) as? LogInViewController else {
            return
        }
        let logInNavigationController = UINavigationController()
        logInNavigationController.viewControllers = [loginViewController]
        logInNavigationController.modalPresentationStyle = .fullScreen
        
        DispatchQueue.main.async {
            self.navigationController?.present(logInNavigationController, animated: true)
        }
    }
    
    func presentInventoryViewController() {
        let storyboard = UIStoryboard(name: Main, bundle: Bundle.main)
        
        guard let inventoryViewController = storyboard.instantiateViewController(withIdentifier: InventoryViewController.identifier) as? InventoryViewController else {
            return
        }
        firestoreManager.retrieveAllItems { items, error in
            guard error == nil, let items = items else {
                self.showAlert(title: RetrieveErrorTitle, message: error ?? RetrieveError)
                return
            }
            inventoryViewController.inventoryItems = items
            let inventoryNavigationController = UINavigationController()
            inventoryNavigationController.viewControllers = [inventoryViewController]
            inventoryNavigationController.modalPresentationStyle = .fullScreen
            
            DispatchQueue.main.async {
                self.navigationController?.present(inventoryNavigationController, animated: true)
            }
            
        }
    }
    
}

