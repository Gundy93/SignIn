//
//  SingUpViewController.swift
//  SignIn
//
//  Created by Gundy on 2023/10/11.
//

import UIKit
import Combine

final class SingUpViewController: UIViewController {
    
    @IBOutlet weak var identifierTextField: UITextField!
    @IBOutlet weak var identifierCautionLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCautionLabel: UILabel!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    @IBOutlet weak var passwordAgainCautionLabel: UILabel!
    @IBOutlet weak var createAccountButton: UIButton!
    @Published private var identifier: String = String()
    @Published private var password: String = String()
    @Published private var passwordAgain: String = String()
    private var cancellables: Set<AnyCancellable> = []
    private var accountManager: AccountManager = AccountManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    private func bind() {
        let validateIdentifier = $identifier
            .map { (self.accountManager.validateNewIdentifier($0), $0) }
            .eraseToAnyPublisher()
        
        validateIdentifier
            .sink { (validation, identifier) in
            self.identifierCautionLabel.textColor = self.textColor(validation: validation || identifier.isEmpty)
        }.store(in: &cancellables)
        
        let validatePassword = $password
            .map { (self.accountManager.validateNewPassword($0), $0) }
            .eraseToAnyPublisher()
        
        validatePassword
            .sink { (validation, password) in
            self.passwordCautionLabel.textColor = self.textColor(validation: validation || password.isEmpty)
        }.store(in: &cancellables)
        
        let validatePasswordAgain = $passwordAgain
            .combineLatest($password) { passwordAgain, password in
                (self.accountManager.validatePasswordAgain(password,
                                                           passwordAgain), passwordAgain)
            }
            .eraseToAnyPublisher()
        
        validatePasswordAgain.sink { (validation, passwordAgain) in
            self.passwordAgainCautionLabel.textColor = self.textColor(validation: validation || passwordAgain.isEmpty)
        }.store(in: &cancellables)
        
        validateIdentifier
            .combineLatest(validatePassword,
                           validatePasswordAgain) { identifier, password, passwordAgain in
                identifier.0 && password.0 && passwordAgain.0
            }
                           .eraseToAnyPublisher()
                           .assign(to: \.isEnabled,
                                   on: createAccountButton).store(in: &cancellables)
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
    
    private func textColor(validation: Bool) -> UIColor {
        return validation ? .clear : .systemRed
    }
    
    @IBAction func createAccount(_ sender: Any) {
        accountManager.creatAccount(identifier: identifier,
                                    password: password)
        showAlertController(title: "계정 생성 완료",
                            message: nil,
                            action: makeDoneAction())
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
