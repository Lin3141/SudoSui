//
//  SafetyPlanViewController.swift
//  SudoSui
//
//  Created by lingxinchen on 4/23/22.
//

import UIKit
import Firebase

class SafetyPlanViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var step1TF: [UITextField]!
    @IBOutlet var step2TF: [UITextField]!
    @IBOutlet var step3TF: [UITextField]!
    @IBOutlet var step4TF: [UITextField]!
    @IBOutlet var step5TF: [UITextField]!
    var allSteps: [[UITextField]] = []
    var user: String = ""
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        allSteps = [step1TF,step2TF,step3TF,step4TF,step5TF]
        delegateAll(allSteps)
        if let userTemp = Auth.auth().currentUser?.email {
            user = userTemp.replacingOccurrences(of: ".", with: "@")
            loadPlan()
        }
    }

    @IBAction func editSaveButton(_ sender: UIBarButtonItem) {
        toggleAll(allSteps)
        if sender.title == "Edit" {
            sender.title = "Save"
        } else {
            sender.title = "Edit"
        }
    }
    
    //MARK: Helper functions
    func delegateAll(_ tfs: [[UITextField]]) {
        for steps in tfs {
            for step in steps {
                step.delegate = self
                step.addTarget(self, action: #selector(textFieldDidChange(_:)),
                              for: .editingChanged)
            }
        }
    }
    
    func toggleAll(_ tfs: [[UITextField]]) {
        for steps in tfs {
            for step in steps {
                step.isEnabled = !step.isEnabled
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let category = getCategory(textField)
        db.collection(user).document("step\(category[0])").setData(["\(category[1])": textField.text], merge: true)
    }
    
    func getCategory(_ textField: UITextField) -> [Int]{
        var toReturn: [Int] = []
        for i in 0..<allSteps.count {
            for j in 0..<allSteps[i].count {
                if allSteps[i][j] == textField {
                    toReturn.append(contentsOf: [i,j])
                    break
                }
            }
        }
        return toReturn
    }
    
    func loadPlan() {
        for i in 0..<allSteps.count {
            for j in 0..<allSteps[i].count {
                db.collection(user).document("step\(i)")
                    .addSnapshotListener { documentSnapshot, error in
                      guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        return
                      }
                      guard let data = document.data() else {
                          print("Not written yet")
                        return
                      }
                        if let plan = data[String(j)] {
                            self.allSteps[i][j].text = plan as? String
                        }
                    }
            }
        }
    }
}

