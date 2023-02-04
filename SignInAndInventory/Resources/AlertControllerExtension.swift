//
//  AlertControllerExtension.swift
//  SignInAndInventory
//
//  Created by OPSolutions on 2/4/23.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.dismiss(animated: true)
        }
    }
}
