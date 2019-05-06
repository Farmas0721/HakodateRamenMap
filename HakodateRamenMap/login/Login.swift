//
//  login.swift
//  HakodateRamenMap
//
//  Created by Fuuya Yamada on 2019/03/02.
//  Copyright © 2019 asahi. All rights reserved.
//

import UIKit
import Firebase


class Login: UIViewController {
    
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWord: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
        if let email = self.userName.text, let password = self.passWord.text {
            showSpinner {
                // [START headless_email_auth]
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    // [START_EXCLUDE]
                    self.hideSpinner {
                        if let error = error {
                            self.showMessagePrompt(error.localizedDescription)
                            return
                        }
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        //get isInitial view
                        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainTab")
                        self.present(mainViewController, animated: true, completion: nil)
                        //self.navigationController!.popViewController(animated: true)
                    }
                    // [END_EXCLUDE]
                }
                // [END headless_email_auth]
            }
        } else {
            self.showMessagePrompt("email/password can't be empty")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func newAccountButton(_ sender: Any) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
