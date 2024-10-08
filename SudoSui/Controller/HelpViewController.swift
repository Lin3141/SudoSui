//
//  HelpViewController.swift
//  SudoSui
//
//  Created by lingxinchen on 4/18/22.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var yesNoButtons: [UIButton]!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    var index: Int = 0
    var buttonArrays : [UIButton] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        storeButtons()
        startButton.isHidden = true
        navigationItem.hidesBackButton = true
    }

    @IBAction func submitButton(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            if index == 0 {
                questionLabel.text = "Have you prepared or started to do anything to end your life?"
                index += 1
            } else {
                infoLabel.text = "I totally understand your situation now. You need someone to be with you. \nIf you have already made a safety plan in SudoSui, you can login to make full use of it.\nIf not, please call someone who can help or National Suicide Prevention Line at 800-273-8255."
                buttonArrays[1].isEnabled = false
                sender.isEnabled = false
                startButton.isHidden = false
            }
        case 1:
            if index == 0 {
                infoLabel.text = "I understand you must feel bad now. Would you like to write down how you feel by creating an account or logging in?"
                index += 1
            } else {
                infoLabel.text = "I understand you must feel depressed now. Would you like to write down how you feel and make safety plan by creating an account or logging in?"
            }
            buttonArrays[0].isEnabled = false
            sender.isEnabled = false
            startButton.isHidden = false
        default:
            print("invalid yes/no button in HelpVC")
        }
    }
    
    func storeButtons() {
        for b in yesNoButtons {
            buttonArrays.append(b)
        }
    }
    
    func showAlert() {
        // Create the action buttons for the alert.
        let defaultAction = UIAlertAction(title: "Call",
                            style: .default) { (action) in
            self.callNumber(phoneNumber: "8002738255")
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                        style: .cancel) { (action) in
        }
        let alert = UIAlertController(title: "Call Lifeline",
                message: "You may need help. Do you want to call National Suicide Prevention Line?",
                preferredStyle: .alert)
        let titleFont = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25)]
        let titleAttrString = NSMutableAttributedString(string: "Call Lifeline", attributes: titleFont)
        alert.setValue(titleAttrString, forKey: "attributedTitle")
        let msgFont = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]
        let msgAttrString = NSMutableAttributedString(string: "You may need help. Do you want to call National Suicide Prevention Line?", attributes: msgFont)
        alert.setValue(msgAttrString, forKey: "attributedMessage")
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }

    func callNumber(phoneNumber : String) {
      if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
        let application:UIApplication = UIApplication.shared
        if (application.canOpenURL(phoneCallURL)) {
            application.open(phoneCallURL, options: [:], completionHandler: nil)
        } else {
            print("Can't call on this device")
        }
      }
    }
    
}
