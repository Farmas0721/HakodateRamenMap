//
//  ViewController.swift
//  SNSApp
//
//  Created by 山田楓也 on 2019/03/24.
//  Copyright © 2019 Fuuya Yamada. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

@IBDesignable class tlController: UIViewController{
    
    let ref = Database.database().reference()
    var isCreate = true //データの作成か更新かを判定、trueなら作成、falseなら更新
    let storageRef = Storage.storage().reference(forURL: "gs://hakodateramenapp.appspot.com")
   
    @IBOutlet weak var ramenImage: UIImageView!
    @IBOutlet weak var doneLabel: UIButton!
    @IBOutlet weak var storeName: UITextField!
    @IBOutlet weak var taste: UITextField!
    @IBOutlet weak var ramenValue: UITextField!
    
    var selectedSnap: DataSnapshot! //ListViewControllerからのデータの受け取りのための変数

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        storeName.delegate = self as? UITextFieldDelegate
        taste.delegate = self as? UITextFieldDelegate
        ramenValue.delegate = self as? UITextFieldDelegate
        
        view.backgroundColor =  UIColor.rgba(red: 242, green: 92, blue: 0, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //selectedSnapがnilならその後の処理をしない
        guard let snap = self.selectedSnap else { return }
        
        //受け取ったselectedSnapを辞書型に変換
        let item = snap.value as! Dictionary<String, AnyObject>
        //textFieldに受け取ったデータのcontentを表示
        storeName.text = item["storeName"] as? String
        //isCreateをfalseにし、更新するためであることを明示
        isCreate = false
    }
    
    func logout() {
        do {
            //do-try-catchの中で、Auth.auth().signOut()を呼ぶだけで、ログアウトが完了
            try Auth.auth().signOut()
            
            //先頭のNavigationControllerに遷移
            let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Nav")
            self.present(storyboard, animated: true, completion: nil)
        }catch let error as NSError {
            print("\(error.localizedDescription)")
        }
        
    }
    @IBAction func selectedPhoto(_ sender: Any) {
        selectPickerImage()
    }
    
    @IBAction func post(_ sender: UIButton) {
        if self.isCreate {
            //投稿のためのメソッド
            self.create()
            self.upload()
        }else {
            //更新するためのメソッド
            self.update()
         }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //データの送信のメソッド
    func create() {
        //何もしない
        guard let name = storeName.text else { return }
        guard let taste = taste.text else { return }
        guard let ramenvalue = ramenValue.text else { return }
        
        //ロートからログインしているユーザーのIDをchildにしてデータを作成
        //childByAutoId()でユーザーIDの下に、IDを自動生成してその中にデータを入れる
        //setValueでデータを送信する。第一引数に送信したいデータを辞書型で入れる
        //今回は記入内容と一緒にユーザーIDと時間を入れる
        //FIRServerValue.timestamp()で現在時間を取る
        self.ref.child("timeline").child((Auth.auth().currentUser?.uid)!).childByAutoId().setValue(["user": (Auth.auth().currentUser?.uid)!, "storeName": name, "taste":taste, "ramenValue":ramenvalue, "date": ServerValue.timestamp()])
    }
    
    func update() {
        //ルートからのchildをユーザーIDに指定
        //ユーザーIDからのchildを受け取ったデータのIDに指定
        //updateChildValueを使って更新
        ref.keepSynced(true)
        ref.child("timeline").child((Auth.auth().currentUser?.uid)!).child("\(self.selectedSnap.key)").updateChildValues(["user": (Auth.auth().currentUser?.uid)!, "storeName": storeName.text!, "taste":taste.text!, "ramenValue":ramenValue.text!, "date": ServerValue.timestamp()])
    }
    
    func upload(){
        let photoRef = storageRef.child("RamenImage")
        let name = storeName.text!
        let data = ramenImage.image!.pngData()
        let reference = photoRef.child(name + ".jpg")
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        reference.putData(data!, metadata: meta, completion: { metaData, error in
            reference.downloadURL { url, error in
                if let error = error {
                    // Handle any errors
                } else {
                    getUrl = url!
                    print(getUrl)
                }
            }
        })
        dismiss(animated: true, completion: nil)
    }
    
}


extension tlController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func selectPickerImage(){
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 選択した写真を取得する
        let image = info[.originalImage] as! UIImage
        ramenImage.image = image
        // 写真を選ぶビューを引っ込める
        self.dismiss(animated: true)
    }
    
}

