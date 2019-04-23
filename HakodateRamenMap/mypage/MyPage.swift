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
    
    @IBAction func button(_ sender: Any) {
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
}
