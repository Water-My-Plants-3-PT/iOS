//
//  LogInViewController.swift
//  WaterMyPlants
//
//  Created by Ian French on 6/22/20.
//  Copyright © 2020 conner. All rights reserved.
//
import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var signupSegment: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!

    let plantController = PlantController()
    var loginType = LoginType.signUp

    override func viewDidLoad() {
        super.viewDidLoad()
        signupButton.backgroundColor = UIColor.systemBlue
        signupButton.tintColor = .white
        signupButton.layer.cornerRadius = 8.0

        signupSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
        signupSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue], for: UIControl.State.selected)
        signupSegment.backgroundColor = UIColor.systemBlue
        signupSegment.tintColor = .white
        signupSegment.layer.cornerRadius = 8.0
    }

    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signupButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signupButton.setTitle("Sign In", for: .normal)
        }
    }
    
    private func displayAlert(title: String, message: String, completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(
                UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
            )
            self.present(alertController, animated: true) {
                completion()
            }
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let username = usernameTextField.text,
            let password = passwordTextField.text,
            !username.isEmpty,
            !password.isEmpty else { return }
        let user = User(username: username, password: password, phoneNumber: "123-456-7890")
        switch loginType {
        case .signUp:
            plantController.signUp(with: user, completion: { error in
                guard error == nil else {
                    print("error signing up: \(error!)")
                    return
                }
                self.displayAlert(title: "Sign-Up Succeeded", message: "Please sign in") {
                    self.loginType = .signIn
                    self.signupSegment.selectedSegmentIndex = 1
                    self.signupButton.setTitle("Sign In", for: .normal)
                }
            })
        case .signIn:
            plantController.signIn(with: user, completion: { error in
                guard error == nil else {
                    print("error signing in: \(error!)")
                    self.displayAlert(title: "Error signing in", message: "Invalid password") {}
                    return
                }
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
}
