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
    
    var photo = UIImageView()
    var urlIamge:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        table.delegate = self //デリゲートをセット
        table.dataSource = self //デリゲートをセット
        
        self.navigationController?.navigationBar.barTintColor = UIColor.rgba(red: 242, green: 92, blue: 0, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .white
        // Do any additional setup after loading the view.
        table.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.read()
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
        
        //配列の該当のデータをitemという定数に代入
        let item = contentArray[indexPath.row]
        //itemの中身を辞書型に変換
        let content = item.value as! Dictionary<String, AnyObject>
        //contentという添字で保存していた投稿内容を表示
        cell.content.text = String(describing: content["storeName"]!)
        let urlstring = String(describing:content["imageID"]!)
        let urlimage = URL(string: urlstring)
        print("urliamge=\(urlimage!)")
        //直入れ
        //let gsReference = Storage.storage().reference(forURL: "gs://hakodateramenapp.appspot.com").child("RamenImage")
        //let reference = gsReference.child("image.jpg")
        cell.ramenphoto.sd_setImage(with: urlimage)
        
        //dateという添字で保存していた投稿時間をtimeという定数に代入
        let time = content["date"] as! TimeInterval
        //getDate関数を使って、時間をtimestampから年月日に変換して表示
        cell.date.text = self.getDate(number: time/1000)
        return cell
    }
    
    func tableView(_ table: UITableView,heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  200
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
        self.selectedSnap = contentArray[indexPath.row]
        self.transition()
    }
    
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
    }
    
    ///dalete///
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
        ref.child("timeline").child((Auth.auth().currentUser?.uid)!).child(contentArray[indexPath.row].key).removeValue()
        self.contentArray.remove(at: indexPath.row)
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
