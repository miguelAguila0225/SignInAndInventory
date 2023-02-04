//
//  FirebaseAuthenticationFunctions.swift
//  SignInAndInventory
//
//  Created by OPSolutions on 2/4/23.
//

import Foundation
import Firebase
import FirebaseAuth

public class FirebaseAuthenticationManager {
    
    func isSignedIn() -> Bool {
        let user = Auth.auth().currentUser?.uid
        return user != nil
    }
    
    func signOutUser(completion: @escaping (Bool, String?) -> ()){
        do {
            try Auth.auth().signOut()
            completion(true, nil)
        } catch {
            completion(false, error.localizedDescription)
        }
    }
    
    func signInUser(username: String, password: String, completion: @escaping (Bool, String?) -> ()) {
        Auth.auth().signIn(withEmail: username, password: password) { authResult, error in
            guard error == nil else {
                completion(false, error?.localizedDescription)
                return
            }
            completion(true, nil)
        }
    }
    
    func checkCredentialsForSignIn(username: String?, password: String?) -> (Bool, String?){
        if var username = username,
           var password = password {
            username = removeEmptySpace(text: username)
            password = removeEmptySpace(text: password)
            
            if username != "" && password != "" {
                return (true, nil)
            } else {
                return (false, "Unable to Sign In, Kindly fill up all the fields")
            }
        } else {
            return (false, "Unable to Sign In, Kindly fill up all the fields")
        }
    }
    
    func registerUser(username: String, password: String, completion: @escaping (Bool,String?) -> () ) {
        Auth.auth().createUser(withEmail: username, password: password ) { authResult, error in
            guard error == nil else {
                completion(false, error?.localizedDescription)
                return
            }
            completion(true, nil)
        }
    }
    
    func checkCredentialsForRegistration(username: String?, password: String?, passwordConfirm: String?) -> (Bool, String?) {
        if var username = username,
           var password = password,
           var passwordConfirm = passwordConfirm {
            
            username = removeEmptySpace(text: username)
            password = removeEmptySpace(text: password)
            passwordConfirm = removeEmptySpace(text: passwordConfirm)
            
            let passwordMatched = comparePasswordForRegistration(password: password,
                                                                 passwordConfirm: passwordConfirm)
            if passwordMatched == true &&
                username != "" &&
                password != "" {
                return (true, nil)
            } else {
                if passwordMatched == false {
                    return (false, "Unable to complete registration, the passwords do not match")
                } else {
                    return (false, "Unable to complete registration, Kindly fill up all the fields")
                }
            }
        } else {
            return (false, "Unable to complete registration, Kindly fill up all the fields")
        }
    }
    
    private func removeEmptySpace(text: String) -> String {
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func comparePasswordForRegistration(password: String, passwordConfirm: String) -> Bool {
        return password == passwordConfirm
    }
    
    
}
