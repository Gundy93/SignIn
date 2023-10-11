//
//  MainViewController.swift
//  SignIn
//
//  Created by Gundy on 2023/10/11.
//

import UIKit

final class MainViewController: UIViewController {
    
    @IBOutlet weak var identifierTextField: UITextField!
    @IBOutlet weak var identifierCautionLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCautionLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    private let accountManager: AccountManager = AccountManager()
    private var identifier: String = String() {
        didSet {
            let validation = accountManager.validateIdentifier(identifier)
            
            identifierCautionLabel.textColor = textColor(validation: validation)
            validateAccount()
        }
    }
    private var password: String = String() {
        didSet {
            let validation = accountManager.validateAccount(identifier: identifier,
                                                            password: password)
            
            passwordCautionLabel.textColor = textColor(validation: validation)
            validateAccount()
        }
    }
    
    @IBAction func identifierChanged(_ sender: UITextField) {
        guard let identifier = sender.text else { return }
        
        self.identifier = identifier
    }
    
    @IBAction func passwordChanged(_ sender: UITextField) {
        guard let password = sender.text else { return }
        
        self.password = password
    }
    
    private func textColor(validation: Bool) -> UIColor {
        return validation ? .clear : .systemRed
    }
    
    private func validateAccount() {
        let validation = accountManager.validateAccount(identifier: identifier,
                                                        password: password)
        
        signInButton.isEnabled = validation
    }
}
