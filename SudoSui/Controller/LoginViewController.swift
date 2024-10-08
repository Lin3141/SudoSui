//
//  ViewController.swift
//  SudoSui
//
//  Created by lingxinchen on 3/30/22.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }
    
    
    @IBAction func loginButton(_ sender: UIButton) {
        if let username = usernameTF.text, let password = passwordTF.text {
            Auth.auth().signIn(withEmail: username, password: password) {
                authDataResult, error in
                if let e = error {
                    self.handleError(errorMessage: e.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: "toHomeVC", sender: self)
                }
            }
        }
    }
    
    @IBAction func register(_ sender: UIButton) {
        if let username = usernameTF.text, let password = passwordTF.text {
            Auth.auth().createUser(withEmail: username, password: password) {
                authDataResult, error in
                if let e = error {
                    self.handleError(errorMessage: e.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: "toHomeVC", sender: self)
                }
            }
        }
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        switch segue.identifier {
//        case "toHomeVC":
//            let destinationVC = segue.destination as! UITabBarController
//        default:
//            print("invalid in prepare in StartpageVC")
//        }
//    }
    
    func handleError(errorMessage: String) {
        let defaultAction = UIAlertAction(title: "OK",
                            style: .default)
        let alert = UIAlertController(title: "Error",
                message: errorMessage,
                preferredStyle: .alert)
        alert.addAction(defaultAction)
        self.present(alert, animated: true)
    }
}

