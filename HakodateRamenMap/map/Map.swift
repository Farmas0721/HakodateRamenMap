//
//  ViewController.swift
//  Mapping
//
//  Created by 宮下翔伍 on 2019/02/27.
//  Copyright © 2019 宮下翔伍. All rights reserved.
//

import UIKit
import MapKit

class Map: UIViewController {
    //マップビュー
    
    @IBOutlet weak var myMap: MKMapView!
    //ツールバー
    
    @IBOutlet weak var toolBar: UIToolbar!
    var defaultColor:UIColor!
    
    //横浜の領域を表示
    @IBAction func gospot(_ sender: Any) {
        //緯度と経度
        let ido = 35.454954
        let keido = 139.6313859
        //中央を表示する領域
        let center = CLLocationCoordinate2D(latitude : ido, longitude : keido)
        //スパン（約2.22km*2.22kmの範囲)
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        //表示する領域
        let theRegion = MKCoordinateRegion(center: center, span: span)
        //領域の地図を表示する
        myMap.setRegion(theRegion,animated: true)
        
    }
    
    @IBAction func changemap(_ sender: UISegmentedControl) {
        //地図のタイプを切り替え
        switch sender.selectedSegmentIndex {
        case 0 :
            myMap.mapType = .standard
            myMap.camera.pitch = 0.0
            //ツールバーを標準化
            toolBar.tintColor = defaultColor
            toolBar.alpha = 1.0
        case 1 :
            myMap.mapType = .satellite
            toolBar.tintColor = UIColor.black
            toolBar.alpha = 1.0
        case 2 :
            myMap.mapType = .hybrid
            toolBar.tintColor = UIColor.black
            toolBar.alpha = 0.8
        case 3 :
            myMap.mapType = .standard
            toolBar.tintColor = defaultColor
            toolBar.alpha = 1.0
            //3Dビュー
            myMap.camera.pitch = 70 //俯角(見下ろす角度)
            myMap.camera.altitude = 700 //標高
            
        default :
            break
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultColor = toolBar.tintColor
        //スケールを表示する
        myMap.showsScale = true
        
    }
    
    
}

