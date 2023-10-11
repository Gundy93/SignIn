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
    @Published private var identifier: String = String()
    @Published private var password: String = String()
    private var cancellables: Set<AnyCancellable> = []
    private var accountManager: AccountManager = AccountManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    private func bind() {
        let validateIdentifier = $identifier
            .map { (self.accountManager.validateIdentifier($0), $0) }
            .eraseToAnyPublisher()
        
        validateIdentifier.sink { (validation, identifier) in
            self.identifierCautionLabel.textColor = self.textColor(validation: validation || identifier.isEmpty)
        }.store(in: &cancellables)
        let validatePassword = $identifier
            .combineLatest($password) { identifier, password in
                (self.accountManager.validateAccount(identifier: identifier,
                                                     password: password), password)
            }
            .eraseToAnyPublisher()
            
        validatePassword
            .sink { (validation, password) in
            self.passwordCautionLabel.textColor = self.textColor(validation: validation || password.isEmpty)
        }.store(in: &cancellables)
        
        validatePassword.sink{ (validation, _) in
            self.signInButton.isEnabled = validation
        }.store(in: &cancellables)
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
}
