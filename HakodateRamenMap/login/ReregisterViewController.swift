//
//  ReregisterViewController.swift
//  HakodateRamenMap
//
//  Created by 永野誉也 on 2019/04/25.
//  Copyright © 2019 asahi. All rights reserved.
//

import UIKit
import FirebaseAuth

class ReregisterViewController: UIViewController {

    
    @IBOutlet var mailTextField: TextFieldSettings!
    
    @IBAction func sendReregisterMailButton(_ sender: Any) {
        if let mailAddress = mailTextField.text {
            Auth.auth().sendPasswordReset(withEmail: mailAddress, completion: {error in
                print(error)
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        self.navigationController?.setNavigationBarHidden(false, animated: false)
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
