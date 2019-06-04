//
//  FollowPageViewController.swift
//  HakodateRamenMap
//
//  Created by 中村　朝陽 on 2019/06/04.
//  Copyright © 2019 asahi. All rights reserved.
//

import UIKit

class FollowBaseViewController: UIViewController {
    
    var tableView: UITableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "FollowTableViewCell", bundle: nil), forCellReuseIdentifier: "FollowTableViewCell")
        tableView.frame = self.view.bounds
        view.addSubview(tableView)
        self.tableView.rowHeight = 45
        

    }
    
}

extension FollowBaseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowTableViewCell", for: indexPath) as! FollowTableViewCell
        
        cell.nameLabel.text = "\(indexPath.row)" + "chonpo"
        return cell
    }
    
}
