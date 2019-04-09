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
   
    @IBOutlet weak var ramenImage: UIImageView!
    @IBOutlet weak var doneLabel: UIButton!
    @IBOutlet weak var nameText: UITextField!
    var selectedSnap: DataSnapshot! //ListViewControllerからのデータの受け取りのための変数

    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameText.delegate = self as? UITextFieldDelegate //デリゲートをセット
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //selectedSnapがnilならその後の処理をしない
        guard let snap = self.selectedSnap else { return }
        
        //受け取ったselectedSnapを辞書型に変換
        let item = snap.value as! Dictionary<String, AnyObject>
        //textFieldに受け取ったデータのcontentを表示
        nameText.text = item["content"] as? String
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
        if isCreate {
            //投稿のためのメソッド
            create()
            upload()
        }else {
            //更新するためのメソッド
            update()
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
        guard let text = nameText.text else { return }
        
        //ロートからログインしているユーザーのIDをchildにしてデータを作成
        //childByAutoId()でユーザーIDの下に、IDを自動生成してその中にデータを入れる
        //setValueでデータを送信する。第一引数に送信したいデータを辞書型で入れる
        //今回は記入内容と一緒にユーザーIDと時間を入れる
        //FIRServerValue.timestamp()で現在時間を取る
        self.ref.child((Auth.auth().currentUser?.uid)!).childByAutoId().setValue(["user": (Auth.auth().currentUser?.uid)!, "content": text, "date": ServerValue.timestamp()])
    }
    
    func update() {
        //ルートからのchildをユーザーIDに指定
        //ユーザーIDからのchildを受け取ったデータのIDに指定
        //updateChildValueを使って更新
        ref.keepSynced(true)
        ref.child((Auth.auth().currentUser?.uid)!).child("\(self.selectedSnap.key)").updateChildValues(["user": (Auth.auth().currentUser?.uid)!,"content": self.nameText.text!, "date": ServerValue.timestamp()])
    }
    
    func upload(){
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: "gs://hakodateramenapp.appspot.com/RamenImage/")
        let name = nameText.text!
        let data = ramenImage.image!.pngData()
        let reference = storageRef.child(name + ".jpg")
        reference.putData(data!, metadata: nil, completion: { metaData, error in
            print(metaData!)
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

