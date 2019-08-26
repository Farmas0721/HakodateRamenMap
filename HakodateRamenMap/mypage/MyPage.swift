//
//  Mypage.swift
//  HakodateRamenMap
//
//  Created by 佐々木真矢 on 2019/03/03.
//  Copyright © 2019 asahi. All rights reserved.
//

import UIKit

class Mypage: UIViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate {//UICollectionViewDelegateFlowLayout{
   
    @IBOutlet weak var collectionView: UICollectionView!
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 2.0, bottom: 2.0, right: 2.0)
    private let itemsPerRow: CGFloat = 3
    //  @IBOutlet weak var picture: UICollectionViewCell!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18 // 表示するセルの数
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) // 表示するセルを登録(先程命名した"Cell")
        cell.backgroundColor = .orange  // セルの色
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem + 42)
    }
    
    
    var sidebarView = sidebarViewController()
    

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var profileImage: UIButton!
    @IBOutlet weak var FollowButton: UIButton!
    @IBOutlet weak var FollowerButton: UIButton!
    @IBOutlet weak var follownum: UILabel!
    @IBOutlet weak var followenum: UILabel!
    @IBOutlet weak var RamenNum: UILabel!
    @IBOutlet weak var RamenNumberButton: UIButton!
    @IBOutlet weak var MessageButton: UIButton!
    @IBOutlet weak var MessageEditButton: UIButton!
    
    
    @IBAction func tapImage(_ sender: Any) {
        // カメラロールが利用可能か？
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            // 写真を選ぶビュー
            let pickerView = UIImagePickerController()
            // 写真の選択元をカメラロールにする
            // 「.camera」にすればカメラを起動できる
            pickerView.sourceType = .photoLibrary
            // デリゲート
            pickerView.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            // ビューに表示
            self.present(pickerView, animated: true)
        }

    }
    
    @IBAction func followpage(_ sender: Any) {
        
    }
    
    @IBAction func followerpage(_ sender: Any) {
        
    }
    
    var rgba = UIColor(red: 210/255, green: 255/255, blue: 255/255, alpha: 1.0) // ボタン背景色設定

    @IBAction func openSIdeber(_ sender: Any) {
        addChild(sidebarView)
        view.addSubview(sidebarView.view)
        sidebarView.didMove(toParent: self)
        sidebarView.showSidebar(animated: true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rgba = UIColor(red: 210/255, green: 255/255, blue: 255/255, alpha: 1.0) // ボタン背景色設定
        self.navigationController?.navigationBar.barTintColor = .orange
        self.navigationItem.title = "マイページ"
        self.navigationController?.navigationBar.barStyle = .default
        
        sidebarView.delegate = self
        view.backgroundColor = UIColor.orange
        profileImage.backgroundColor = rgba
        username.backgroundColor = UIColor.clear
        profileImage.setTitleColor(UIColor.cyan, for: UIControl.State.normal)          // Do any additional setup after loading the view.
        
        self.profileImage.layer.cornerRadius = 35
        self.profileImage.clipsToBounds = true
        FollowButton.layer.borderWidth = 3
        FollowButton.layer.borderColor = UIColor.white.cgColor
        FollowButton.layer.cornerRadius = 35
        
        FollowerButton.layer.borderWidth = 3
        FollowerButton.layer.borderColor = UIColor.white.cgColor
        FollowerButton.layer.cornerRadius = 35

        RamenNumberButton.layer.borderWidth = 3
        RamenNumberButton.layer.borderColor = UIColor.white.cgColor
        RamenNumberButton.layer.cornerRadius = 35
        
        MessageButton.layer.borderWidth = 3
        MessageButton.layer.borderColor = UIColor.white.cgColor
        MessageButton.layer.cornerRadius = 5
        
        MessageEditButton.layer.borderWidth = 3
        MessageEditButton.layer.borderColor = UIColor.white.cgColor
        MessageEditButton.layer.cornerRadius = 5
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

extension Mypage: sidebarViewControllerDelegate {
    func sidebarVIewController(_ sidebarViewController: sidebarViewController, didSelectRowAt indexPath: IndexPath) {
        sidebarView.hideSidebar(animated: true, completion: nil)
    }
    
    func sidebarViewControllerRequestShow(_ sidebarViewController: sidebarViewController, animated: Bool) {
    }
    
    func numberOfSection(in sidebarViewController: sidebarViewController) -> Int {
        return 1
    }
    
    func tableView(_ sidebarViewController: sidebarViewController, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ sidebarViewController: sidebarViewController, cellForRowAt indexPath: IndexPath, _ cell: UITableViewCell) -> UITableViewCell {
        cell.backgroundColor = UIColor.orange
        if indexPath.row == 0 {
            cell.textLabel?.text = "HAKODATE ラーメンマップ"
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }else {
            cell.textLabel?.text = "Item \(indexPath.row)"
        }
        return cell
    }
    
}

extension Mypage: UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
    
    //画像が選択された時に呼ばれる.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            
            //ボタンの背景に選択した画像を設定
            profileImage.setImage(image, for: .normal)
            
        }else{
            print("Error")
        }
        
        // モーダルビューを閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
    //画像選択がキャンセルされた時に呼ばれる.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        // モーダルビューを閉じる
        self.dismiss(animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // スタンプが押された時の処理を書く
    }
}





