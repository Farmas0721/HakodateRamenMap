//
//  MyPage.swift
//  HakodateRamenMap
//
//  Created by Fuuya Yamada on 2019/03/02.
//  Copyright © 2019 asahi. All rights reserved.
//

import UIKit

class MyPage: UIViewController {

    var sidebarView = sidebarViewController()
    
    @IBOutlet var username: UITextField!
    @IBOutlet var Follownum: UILabel!
    @IBOutlet var Followernum: UILabel!
    @IBOutlet var profileImage: UIButton!
    
    var imagePicker = UIImagePickerController()
    
    @IBAction func tapImage(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)

    }
    
    @IBAction func followpage(_ sender: Any) {
        
    }
    
    @IBAction func followerpage(_ sender: Any) {
        
    }
    
    @IBAction func openSIdeber(_ sender: Any) {
        addChild(sidebarView)
        view.addSubview(sidebarView.view)
        sidebarView.didMove(toParent: self)
        sidebarView.showSidebar(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sidebarView.delegate = self
        
        // Do any additional setup after loading the view.
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

extension MyPage: sidebarViewControllerDelegate {
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

extension MyPage: UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
    
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
