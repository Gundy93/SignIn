//
//  AccountManager.swift
//  SignIn
//
//  Created by Gundy on 2023/10/11.
//

import Foundation

struct AccountManager {
    
    func creatAccount(identifier: String, password: String) {
        UserDefaults.standard.setValue(password, forKey: identifier)
    }
    
    private func findPassword(forIdentifier identifier: String) -> String? {
        return UserDefaults.standard.string(forKey: identifier)
    }
    
    func validateIdentifier(_ identifier: String) -> Bool {
        return findPassword(forIdentifier: identifier) != nil
    }
    
    func validateAccount(identifier: String, password: String) -> Bool {
        return findPassword(forIdentifier: identifier) == password
    }
    
    func validateNewIdentifier(_ identifier: String) -> Bool {
        return findPassword(forIdentifier: identifier) == nil
    }
    
    func validateNewPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
    
    func validatePasswordAgain(_ password: String, _ passwordAgain: String) -> Bool {
        return password == passwordAgain
    }
}
