//
//  HomeViewController.swift
//  SudoSui
//
//  Created by lingxinchen on 4/19/22.
//

import UIKit
import Firebase

class HomeViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
