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
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
}
