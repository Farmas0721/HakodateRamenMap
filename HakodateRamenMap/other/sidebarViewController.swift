//
//  sidebarViewController.swift
//  HakodateRamenMap
//
//  Created by 中村　朝陽 on 2019/04/18.
//  Copyright © 2019年 asahi. All rights reserved.
//

import UIKit

protocol sidebarViewControllerDelegate: class {
    func sidebarViewControllerRequestShow(_ sidebarViewController: sidebarViewController, animated: Bool)
    func sidebarVIewController(_ sidebarViewController: sidebarViewController, didSelectRowAt indexPath: IndexPath)
    func numberOfSection(in sidebarViewController: sidebarViewController) -> Int
    func tableView(_ sidebarViewController: sidebarViewController, numberOfRowsInSection section: Int) -> Int
    func tableView(_ sidebarViewController: sidebarViewController, cellForRowAt indexPath: IndexPath, _ cell: UITableViewCell) -> UITableViewCell
}

class sidebarViewController: UIViewController {
    private let rootView = UIView(frame: .zero)
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    weak var delegate: sidebarViewControllerDelegate?
    private var contentMaxWidth: CGFloat {
        return view.bounds.width * 0.8
    }
    private var rootViewRatio: CGFloat {
        get { return rootView.frame.maxX / contentMaxWidth
            
        }
        set {
            let ratio = min(max(newValue, 0), 1)
            rootView.frame.origin.x = contentMaxWidth * ratio - rootView.frame.width
            rootView.layer.shadowColor = UIColor.black.cgColor
            rootView.layer.shadowRadius = 3.0
            rootView.layer.shadowOpacity = 0.8
            
            view.backgroundColor = UIColor(white: 0, alpha: 0.3 * ratio)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var rootRect = view.bounds
        rootRect.size.width = contentMaxWidth
        rootRect.origin.x = -rootRect.width
        rootView.frame = rootRect
        rootView.backgroundColor = UIColor.white
        rootView.autoresizingMask = .flexibleHeight
        view.addSubview(rootView)
        
        tableView.frame = rootView.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Default")
        rootView.addSubview(tableView)
        tableViewCustom()
        tableView.reloadData()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(sender:)))
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
        }
    
    func showSidebar(animated : Bool){
        navigationController?.setNavigationBarHidden(true, animated: true)
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.rootViewRatio = 1.0
            }
        } else {
            rootViewRatio = 1.0
        }
    }
    
    func hideSidebar(animated : Bool, completion : ((Bool) -> Void)?){
        if animated {
            UIView.animate(withDuration: 0.3, animations:{
                self.rootViewRatio = 0
                
            }, completion: { finished in
                completion?(finished)
            })
        } else {
            rootViewRatio = 0
            completion?(true)
        }
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc private func backgroundTapped(sender: UITapGestureRecognizer){
        hideSidebar(animated: true, completion: { (_) in
            self.willMove(toParent: nil)
            self.removeFromParent()
            self.view.removeFromSuperview()
        })
    }
    
    private func tableViewCustom(){
        tableView.backgroundColor = UIColor.orange
        tableView.separatorStyle = .none
    }
}

extension sidebarViewController: UIGestureRecognizerDelegate {
    internal func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let location = gestureRecognizer.location(in: tableView)
        if tableView.indexPathForRow(at: location) != nil {
            return false
        }
        return true
    }
}

extension sidebarViewController: UITableViewDataSource, UITableViewDelegate {
        func numberOfSections(in tableView: UITableView) -> Int {
            return self.delegate!.numberOfSection(in: self)
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.delegate!.tableView(self, numberOfRowsInSection: section)
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Default", for: indexPath)
            return self.delegate!.tableView(self, cellForRowAt: indexPath, cell)
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            delegate?.sidebarVIewController(self, didSelectRowAt: indexPath)
        }
}
