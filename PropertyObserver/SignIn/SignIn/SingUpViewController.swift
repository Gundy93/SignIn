//
//  SingUpViewController.swift
//  SignIn
//
//  Created by Gundy on 2023/10/11.
//

import UIKit

final class SingUpViewController: UIViewController {
    
    @IBOutlet weak var identifierTextField: UITextField!
    @IBOutlet weak var identifierCautionLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCautionLabel: UILabel!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    @IBOutlet weak var passwordAgainCautionLabel: UILabel!
    @IBOutlet weak var createAccountButton: UIButton!
    private let accountManager: AccountManager = AccountManager()
    private var identifier: String = String() {
        didSet {
            let validation = accountManager.validateNewIdentifier(identifier)
            
            identifierCautionLabel.textColor = textColor(validation: validation)
            validateCreation()
        }
    }
    private var password: String = String() {
        didSet {
            let validation = accountManager.validateNewPassword(password)
            
            passwordCautionLabel.textColor = textColor(validation: validation)
            validateCreation()
        }
    }
    private var passwordAgain: String = String() {
        didSet {
            let validation = accountManager.validatePasswordAgain(password,
                                                                  passwordAgain)
            
            passwordAgainCautionLabel.textColor = textColor(validation: validation)
            validateCreation()
        }
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func identifierChanged(_ sender: UITextField) {
        guard let identifier = sender.text else { return }
        
        self.identifier = identifier
    }
    
    @IBAction func passwordChanged(_ sender: UITextField) {
        guard let password = sender.text else { return }
        
        self.password = password
    }
    
    @IBAction func passwordAgainChanged(_ sender: UITextField) {
        guard let passwordAgain = sender.text else { return }
        
        self.passwordAgain = passwordAgain
    }
    
    @IBAction func createAccount(_ sender: Any) {
        accountManager.creatAccount(identifier: identifier,
                                    password: password)
        showAlertController(title: "계정 생성 완료",
                            message: nil,
                            action: makeDoneAction())
    }
    
    private func textColor(validation: Bool) -> UIColor {
        return validation ? .clear : .systemRed
    }
    
    private func validateCreation() {
        let validation = accountManager.validateNewIdentifier(identifier) &&
        accountManager.validateNewPassword(password) &&
        accountManager.validatePasswordAgain(password, passwordAgain)
        
        createAccountButton.isEnabled = validation
    }
    
    private func showAlertController(title: String?, message: String?, action: UIAlertAction) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    private func makeDoneAction() -> UIAlertAction {
        let action = UIAlertAction(title: "확인",
                                   style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        }
        
        return action
    }
}
