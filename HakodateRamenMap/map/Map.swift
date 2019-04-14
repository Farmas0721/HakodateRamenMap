//
//  ViewController.swift
//  Mapping
//
//  Created by 宮下翔伍 on 2019/02/27.
//  Copyright © 2019 宮下翔伍. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class Map: UIViewController ,MKMapViewDelegate{
    
    let titlelist: [String] = ["ラーメン炙","らぁめん工房かりんとう"]
   
    @IBOutlet weak var ramenmap: MKMapView!
    
   
    @IBAction func LongPressPin(_ sender: UILongPressGestureRecognizer) {
    
    guard sender.state == UIGestureRecognizer.State.ended else{
            return
        }
        let pressPoint = sender.location(in: ramenmap)
        let pressCoordinate = ramenmap.convert(pressPoint,toCoordinateFrom: ramenmap)
        let ano = MKPointAnnotation()
        ano.coordinate = pressCoordinate
        ramenmap.addAnnotation(ano)
        
    }
    func addAno(_ num:Int,_ latitude:CLLocationDegrees,_ longitude: CLLocationDegrees,_ title:String,_ subtitle:String){
       
         let anno = MKPointAnnotation()
        // 緯度経度を指定
        anno.index(ofAccessibilityElement: num)
        anno.coordinate = CLLocationCoordinate2DMake(latitude,longitude)
        // タイトル、サブタイトルを設定
        anno.title = title
        anno.subtitle = subtitle
        // mapViewに追加
        self.ramenmap.addAnnotation(anno)
        ramenmap.delegate = self
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation)
    -> MKAnnotationView? {
        let pinview = MKPinAnnotationView(annotation: annotation, reuseIdentifier:nil)
         let stackView = UIStackView()
        let titlelabel:UILabel = UILabel()
        
        pinview.animatesDrop = true
        pinview.isDraggable = true
        pinview.pinTintColor = UIColor.orange
        pinview.canShowCallout = true
        
        //左ボタンをアノテーションビューに追加する。
        let button = UIButton()
        button.frame = CGRect(x:0,y:0,width:100,height:50)
        button.setTitle("詳細を表示", for: .normal)
        button.setTitleColor(UIColor.black, for:.normal)
        button.backgroundColor = UIColor.yellow
        pinview.leftCalloutAccessoryView = button
        pinview.detailCalloutAccessoryView = stackView
        return pinview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addAno(1,41.8268,140.7518,"ラーメン炙" ,"北海道函館市美原5丁目39-1")
        addAno(2,41.7913,140.7794,"らぁめん工房かりんとう","北海道函館市花園町24-21")
        self.navigationController?.navigationBar.barTintColor = .orange
        self.navigationController?.navigationBar.tintColor = .white

        let ano = MKPointAnnotation()
        let center = CLLocationCoordinate2D(latitude: 41.7687933, longitude:140.7288103)
        let span : MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region : MKCoordinateRegion = MKCoordinateRegion(center: center, span: span)
        
        ramenmap.addAnnotation(ano)
        ramenmap.setRegion(region, animated: true)
        ramenmap.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //吹き出しアクササリー押下時の呼び出しメソッド
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if(control == view.leftCalloutAccessoryView) {
            //左のボタンが押された場合はピンの色をランダムに変更する。
     func change(_ sender:UIButton) {
                let next = storyboard!.instantiateViewController(withIdentifier: "timeline")
                self.present(next,animated: true, completion: nil)
            }
    }
}
}
