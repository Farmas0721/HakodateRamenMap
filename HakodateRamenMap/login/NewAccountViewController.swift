//
//  NewAccountViewController.swift
//  HakodateRamenMap
//
//  Created by 中村　朝陽 on 2019/03/03.
//  Copyright © 2019年 asahi. All rights reserved.
//

import UIKit
import Firebase

class NewAccountViewController: UIViewController {

    @IBOutlet weak var emailAddress: TextFieldSettings!
    @IBOutlet weak var password: TextFieldSettings!
    @IBOutlet weak var conformPassword: TextFieldSettings!
    
    
    @IBAction func createAccount(_ sender: Any) {
        if isValidEmail(emailAddress.text ?? ""){
            if password.text == conformPassword.text {
                
                Auth.auth().createUser(withEmail: emailAddress.text!, password: password.text!) { (authResult, error) in
                    // ...
                    guard (authResult?.user) != nil else { return }
                }
                
                navigationController?.popViewController(animated: true)
            }else{
                let alert = UIAlertController(title: "パスワードが一致しません", message: "もう一度入力してください", preferredStyle: UIAlertController.Style.actionSheet)
                let okButton = UIAlertAction(title: "ok", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                present(alert, animated: true, completion: nil)
            }
        }else{
            let alert = UIAlertController(title: "不正なアドレス", message: "正しいメールアドレスを入力してください", preferredStyle: UIAlertController.Style.actionSheet)
            let okButton = UIAlertAction(title: "ok", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okButton)
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func returnPage(_ sender: Any) {
            navigationController?.popViewController(animated: true)
    }
    
    func isValidEmail(_ string: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: string)
        return result
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
