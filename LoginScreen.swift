//
//  LoginScreen.swift
//  Chestnut Chores Revamp
//
//  Created by Andy Lau on 3/17/21.
//  Copyright © 2021 SCH Academy. All rights reserved.
//

import UIKit

class LoginScreen: UIViewController {
    
    @IBOutlet weak var appLogo: UIImageView!
    @IBOutlet weak var greetingsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        appLogo.image = UIImage(named: "chestnutChoresLogo")
        greetingsLabel.text = "Welcome  Back!"
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toChoresInfo", sender: nil)
    }
}
