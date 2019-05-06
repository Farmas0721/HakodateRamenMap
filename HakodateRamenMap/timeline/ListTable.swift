//
//  List.swift
//  SNSApp
//
//  Created by 山田楓也 on 2019/03/24.
//  Copyright © 2019 Fuuya Yamada. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseUI


class ListTable: UIViewController ,UITableViewDelegate, UITableViewDataSource{

    @IBOutlet var table: UITableView!
    
    var contentArray: [DataSnapshot] = []
    
    var snap: DataSnapshot!
    var selectedSnap: DataSnapshot!
    
    let ref = Database.database().reference()
    let storage = Storage.storage()
    let storageRef = Storage.storage().reference(forURL: "gs://hakodateramenapp.appspot.com")
    
    
    var sidebarView = sidebarViewController()
    
    var photo = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        table.delegate = self //デリゲートをセット
        table.dataSource = self //デリゲートをセット
        sidebarView.delegate = self
        
        self.navigationController?.navigationBar.barTintColor = .orange//UIColor.rgba(red: 242, green: 92, blue: 0, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.title = "タイムライン"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

        table.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.read()
        table.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //画面が消えたときに、Firebaseのデータ読み取りのObserverを削除しておく
        ref.removeAllObservers()
    }
    
    @IBAction func addTask(_ sender: Any) {
         self.transition()
    }
    
    func transition() {
        self.performSegue(withIdentifier: "toView", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return contentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //xibとカスタムクラスで作成したCellのインスタンスを作成
        let cell = table.dequeueReusableCell(withIdentifier: "cell") as! ListTableViewCell
        let calc = contentArray.count - indexPath.row - 1
        
        //配列の該当のデータをitemという定数に代入
        let item = contentArray[calc]
        //itemの中身を辞書型に変換
        let content = item.value as! Dictionary<String, AnyObject>
        //contentという添字で保存していた投稿内容を表示
        cell.content.text = String(describing: content["storeName"]!)
        let urlstring = String(describing:content["imageID"]!)
        let urlimage = URL(string: urlstring)
        //print("urliamge=\(urlimage!)")
        cell.ramenphoto.sd_setImage(with: urlimage)
        //dateという添字で保存していた投稿時間をtimeという定数に代入
        let time = content["date"] as! TimeInterval
        //getDate関数を使って、時間をtimestampから年月日に変換して表示
        cell.date.text = self.getDate(number: time/1000)
        return cell
    }
    
    func tableView(_ table: UITableView,heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  320
    }
    
    
    func read() {
        //FIRDataEventTypeを.Valueにすることにより、なにかしらの変化があった時に、実行
        //今回は、childでユーザーIDを指定することで、ユーザーが投稿したデータの一つ上のchildまで指定することになる
        ref.child("timeline").child((Auth.auth().currentUser?.uid)!).observe(.value, with: {(snapShots) in
            if snapShots.children.allObjects is [DataSnapshot] {
               // print("snapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                
              //  print("snapShot...\(snapShots)") //読み込んだデータをプリント
                
                self.snap = snapShots
            }
            self.reload(snap: self.snap)
        })
    }
    
    
  /*  func imageRead(){
        let userID = Auth.auth().currentUser?.uid
        if let user = userID {
            
        let imageURL = self.ref.child("imageID/\(user)/profile")
        //print(imageURL)
        imageURL.observe(DataEventType.value, with: { (snapshot) in
            let url = snapshot.value as? String
            if url == nil {
                print("ファイルなし")
            } else {
                //ダウンロードURLを取得し、ImageViewに反映
               let strURL = URL(string: url!)
                self.urlIamge = strURL
                //print(strURL!)
            }
         })
        }
    }
 */
    
    
    func reload(snap: DataSnapshot) {
        if snap.exists() {
            //FIRDataSnapshotが存在するか確認
            contentArray.removeAll()
            //1つになっているFIRDataSnapshotを分割し、配列に入れる
            for item in snap.children {
                contentArray.append(item as! DataSnapshot)
            }
            // ローカルのデータベースを更新
            ref.child("timeline").child((Auth.auth().currentUser?.uid)!).keepSynced(true)
            //テーブルビューをリロード
            table.reloadData()
        }
    }
    
    func getDate(number: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: number)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.string(from: date)
    }
    
    /////update/////
    func didSelectRow(selectedIndexPath indexPath: IndexPath) {
        //ルートからのchildをユーザーのIDに指定
        //ユーザーIDからのchildを選択されたCellのデータのIDに指定
        let calc = contentArray.count - indexPath.row - 1
        self.selectedSnap = contentArray[calc]
        self.performSegue(withIdentifier: "toDetail", sender: nil)
    }
    //celltapした時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelectRow(selectedIndexPath: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toView" {
            let view = segue.destination as! tlController
            if let snap = self.selectedSnap {
                view.selectedSnap = snap
            }
        }
        if segue.identifier == "toDetail" {
            let view = segue.destination as! Detail
            if let snap = self.selectedSnap {
                view.detailSnap = snap
            }
        }
    }
    
    ///delete///
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //デリートボタンを追加
        if editingStyle == .delete {
            //選択されたCellのNSIndexPathを渡し、データをFirebase上から削除するためのメソッド
            self.delete(deleteIndexPath: indexPath)
            //TableView上から削除
            table.deleteRows(at: [indexPath as IndexPath], with: .fade)
        }
    }
    
    func delete(deleteIndexPath indexPath: IndexPath) {
        let calc = contentArray.count - indexPath.row - 1
        let item = contentArray[calc]
        let content = item.value as! Dictionary<String, AnyObject>
        let name = String(describing: content["storeName"]!)
        let photoRef = storageRef.child("RamenImage")
        let imageRef = photoRef.child(name + ".jpg")
        imageRef.delete { error in
            if error != nil {
                print("ファイル削除失敗")
            } else {
                print("ファイル削除")
            }
        }
        
        ref.child("timeline").child((Auth.auth().currentUser?.uid)!).child(contentArray[calc].key).removeValue()
        self.contentArray.remove(at: calc)
    }
    

    @IBAction func sidebar(_ sender: UIBarButtonItem) {
        addChild(sidebarView)
        view.addSubview(sidebarView.view)
        sidebarView.didMove(toParent: self)
        sidebarView.showSidebar(animated: true)
    }
    
}

extension UIColor {
    class func rgba(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor{
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
 }
}

extension ListTable: sidebarViewControllerDelegate {
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
