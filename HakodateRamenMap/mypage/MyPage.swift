//
//  Mypage.swift
//  HakodateRamenMap
//
//  Created by 佐々木真矢 on 2019/03/03.
//  Copyright © 2019 asahi. All rights reserved.
//

import UIKit

class Mypage: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var Follownum: UILabel!
    @IBOutlet weak var Followernum: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var profileimage: UIButton!
    
    @IBAction func profileimage(_ sender: Any) {
        // カメラロールが利用可能か？
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            // 写真を選ぶビュー
            let pickerView = UIImagePickerController()
            // 写真の選択元をカメラロールにする
            // 「.camera」にすればカメラを起動できる
            pickerView.sourceType = .photoLibrary
            // デリゲート
            pickerView.delegate = self
            // ビューに表示
            self.present(pickerView, animated: true)
        }
    }
    
    // 写真を選んだ後に呼ばれる処理
    func imagePickerController(_ imagePicker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        let image = info[.originalImage]
            as? UIImage
        // ビューに表示する
        self.icon.image = image
        // 写真を選ぶビューを引っ込める
        self.dismiss(animated: true)
    }
    
    @IBAction func followpage(_ sender: Any) {
    }
    @IBAction func followerpage(_ sender: Any) {
    }
    
    
    @IBOutlet weak var username: UITextField!
    var rgba = UIColor(red: 210/255, green: 255/255, blue: 255/255, alpha: 1.0) // ボタン背景色設定
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.username.delegate = self
        view.backgroundColor = UIColor.orange
        profileimage.backgroundColor = rgba
        username.backgroundColor = UIColor.clear
        profileimage.setTitleColor(UIColor.cyan, for: UIControl.State.normal)          // Do any additional setup after loading the view.
    }
    
    func usernameShouldReturn(username: UITextField) -> Bool {
        username.resignFirstResponder()
        return true
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

