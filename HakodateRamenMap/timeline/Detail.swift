//
//  Detail.swift
//  HakodateRamenMap
//
//  Created by 山田楓也 on 2019/05/04.
//  Copyright © 2019 asahi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseUI

class Detail: UIViewController ,UITableViewDelegate, UITableViewDataSource{
  
    @IBOutlet weak var detailTable: UITableView!
    
    var contentArray: [DataSnapshot] = []
    
    var snap: DataSnapshot!
    var selectedSnap: DataSnapshot!
    
    let ref = Database.database().reference()
    let storage = Storage.storage()
    
    var detailSnap: DataSnapshot! //ListTableからのデータの受け取りのための変数

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgba(red: 242, green: 92, blue: 0, alpha: 1)
        // Do any additional setup after loading the view.
        detailTable.delegate = self as UITableViewDelegate
        detailTable.dataSource = self as UITableViewDataSource
        
        detailTable.register(UITableViewCell.self, forCellReuseIdentifier: "nameCell")
        detailTable.register(UITableViewCell.self, forCellReuseIdentifier: "imageCell")
        detailTable.register(UITableViewCell.self, forCellReuseIdentifier: "storeNameCell")
        detailTable.register(UITableViewCell.self, forCellReuseIdentifier: "tasteCell")
        detailTable.register(UITableViewCell.self, forCellReuseIdentifier: "valueCell")
        
        detailTable.sectionHeaderHeight = 340
        detailTable.rowHeight = 65
        
        detailTable.reloadData()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let namecell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath)
        let storecell = tableView.dequeueReusableCell(withIdentifier: "storeNameCell", for: indexPath)
        let tastecell = tableView.dequeueReusableCell(withIdentifier: "tasteCell", for: indexPath)
        let valuecell = tableView.dequeueReusableCell(withIdentifier: "valueCell", for: indexPath)
        
        
        //受け取ったselectedSnapを辞書型に変換
        let item = detailSnap.value as! Dictionary<String, AnyObject>
          switch indexPath.row{
          case 0:
            namecell.textLabel?.text = "Fuya"
            namecell.imageView?.image = UIImage(named: "acount")
            return namecell
          case 1:
            storecell.textLabel?.text = item["storeName"] as? String
            storecell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            return storecell
          case 2:
            tastecell.textLabel?.text = item["taste"] as? String
            return tastecell
          case 3:
            valuecell.textLabel?.text = item["ramenValue"] as? String
            return valuecell
          default:
            namecell.textLabel?.text = item["storeName"] as? String
            return namecell
        }
    }
    
    //header Image
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let ramenimage = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        //ramenimage.contentMode = UIView.ContentMode.center
        //ramenimage.contentMode = UIView.ContentMode.redraw
        ramenimage.clipsToBounds = true
        ramenimage.contentMode = UIView.ContentMode.scaleAspectFill
        ramenimage.layer.position = CGPoint(x: self.view.frame.width/2, y: 100.0)
        
        let item = detailSnap.value as! Dictionary<String, AnyObject>
        let urlstring = String(describing: item["imageID"]!)
        let urlimage = URL(string: urlstring)
        ramenimage.sd_setImage(with: urlimage)
        return ramenimage
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        detailTable.deselectRow(at: indexPath, animated: true)
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
