//
//  MainViewController.swift
//  SignIn
//
//  Created by Gundy on 2023/10/11.
//

import UIKit
import Combine

final class MainViewController: UIViewController {
    
    @IBOutlet weak var identifierTextField: UITextField!
    @IBOutlet weak var identifierCautionLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCautionLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    private var accountManager: AccountManager = AccountManager()
    @Published private var identifier: String = String()
    private var validateIdentifier: AnyPublisher<String?, Never> {
        return $identifier
            .map { self.accountManager.validateIdentifier($0) || $0.isEmpty ? $0 : nil }
            .eraseToAnyPublisher()
    }
    private var identifierCancellable: AnyCancellable?
    @Published private var password: String = String()
    private var validatePassword: AnyPublisher<Bool, Never> {
        return $identifier
            .combineLatest($password) { identifier, password in
                return self.accountManager.validateAccount(identifier: identifier,
                                                           password: password) || password.isEmpty
            }
            .eraseToAnyPublisher()
    }
    private var passwordCancellable: AnyCancellable?
    private var validateAccount: AnyPublisher<Bool, Never> {
        return $identifier
            .combineLatest($password) { identifier, password in
                return self.accountManager.validateAccount(identifier: identifier,
                                                           password: password)
            }
            .eraseToAnyPublisher()
    }
    private var signInButtonCancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCancellable()
    }
    
    private func configureCancellable() {
        identifierCancellable = validateIdentifier.sink { identifier in
            guard identifier != nil else {
                self.identifierCautionLabel.textColor = .systemRed
                return
            }
            
            self.identifierCautionLabel.textColor = .clear
        }
        passwordCancellable = validatePassword.sink { validation in
            guard validation else {
                self.passwordCautionLabel.textColor = .systemRed
                return
            }
            
            self.passwordCautionLabel.textColor = .clear
        }
        signInButtonCancellable = validateAccount.assign(to: \.isEnabled,
                                                         on: signInButton)
    }
    
    @IBAction func identifierChanged(_ sender: UITextField) {
        guard let identifier = sender.text else { return }
        
        self.identifier = identifier
    }
    
    @IBAction func passwordChanged(_ sender: UITextField) {
        guard let password = sender.text else { return }
        
        self.password = password
    }
}
