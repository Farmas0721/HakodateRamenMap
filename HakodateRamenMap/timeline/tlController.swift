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
    
    var ref = Database.database().reference()
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
/*
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //selectedSnapがnilならその後の処理をしない
        guard let snap = self.selectedSnap else { return }
        
       //受け取ったselectedSnapを辞書型に変換
        let item = snap.value as! Dictionary<String, AnyObject>
        //textFieldに受け取ったデータのcontentを表示
        storeName.text = item["storeName"] as? String
        isCreateをfalseにし、更新するためであることを明示
        isCreate = false

    }
*/
    
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

    
    @IBAction func post(_ sender: UIButton) {
        if self.isCreate {
            //投稿のためのメソッド
            self.create()
            //self.upload(image: ramenImage.image!)
        }/*else {
            //更新するためのメソッド
            self.update()
         }*/
        _ = self.navigationController?.popViewController(animated: true)
        //self.performSegue(withIdentifier: "toTl", sender: nil)
    }
    //returnでキーボード閉じる
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
        
        let image = ramenImage.image!
        
        let photoRef = storageRef.child("RamenImage")
        let imageRef = photoRef.child("ramen.jpg")
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        let user = (Auth.auth().currentUser?.uid)!
        let imageData = image.jpegData(compressionQuality: 1.0)!
        imageRef.putData(imageData, metadata: meta) { metadata, error in
            if error != nil {
                print("Uh-oh, an error occurred!")
            } else {
                //URL型をNSstring型に変更
                imageRef.downloadURL { (url, err) in
                    let data = url?.absoluteString
                    self.ref.keepSynced(true)
                    self.ref.child("timeline").child(user).childByAutoId().setValue(["user": (Auth.auth().currentUser?.uid)!, "storeName": name, "taste":taste, "ramenValue":ramenvalue, "date": ServerValue.timestamp(),"imageID":data!])
                }
                print("成功！")
            }
        }
        
    }
    
    func update() {
        //ルートからのchildをユーザーIDに指定
        //ユーザーIDからのchildを受け取ったデータのIDに指定
        //updateChildValueを使って更新
        ref.keepSynced(true)
        ref.child("timeline").child((Auth.auth().currentUser?.uid)!).child("\(self.selectedSnap.key)").updateChildValues(["user": (Auth.auth().currentUser?.uid)!, "storeName": storeName.text!, "taste":taste.text!, "ramenValue":ramenValue.text!, "date": ServerValue.timestamp()])
    }
    
//    func upload(image: UIImage){
//        let photoRef = storageRef.child("RamenImage")
//        let imageRef = photoRef.child("image.jpg")
//        let meta = StorageMetadata()
//        meta.contentType = "image/jpeg"
//        let user = (Auth.auth().currentUser?.uid)!
//        let imageData = image.jpegData(compressionQuality: 1.0)!
//        imageRef.putData(imageData, metadata: meta) { metadata, error in
//            if error != nil {
//                print("Uh-oh, an error occurred!")
//            } else {
//                //URL型をNSstring型に変更
//                imageRef.downloadURL { (url, err) in
//                    let data = url?.absoluteString
//                    self.ref.keepSynced(true)
//                    //self.ref.child("imageID").child(user).updateChildValues(["imageID":data!])
//                }
//                print("成功！")
//            }
//        }
//    }
    
    @IBAction func tapImage(_ sender: UITapGestureRecognizer) {
        //print("タップ")
        dispAlert()
        //selectPickerImage()
    }
    
}


extension tlController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //library
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
        ramenImage.contentMode = .scaleAspectFit
        ramenImage.image = image
        // 写真を選ぶビューを引っ込める
        self.dismiss(animated: true)
    }
    
    
    //camera
    func startCamera() {
        let sourceType:UIImagePickerController.SourceType =
            UIImagePickerController.SourceType.camera
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerController.SourceType.camera){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
        else{
            print("errorrrrrrr")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}

extension tlController{
    func dispAlert() {
        let alert: UIAlertController = UIAlertController(title: "表示方法", message: "どちらか選んでね", preferredStyle:  UIAlertController.Style.actionSheet)
        
        let camera: UIAlertAction = UIAlertAction(title: "写真を撮る", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            self.startCamera()
        })
        
        let library: UIAlertAction = UIAlertAction(title: "カメラロール", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            self.selectPickerImage()
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "cancel", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
        })
        
        alert.addAction(cancelAction)
        alert.addAction(camera)
        alert.addAction(library)
        
        present(alert, animated: true, completion: nil)
    }
}
