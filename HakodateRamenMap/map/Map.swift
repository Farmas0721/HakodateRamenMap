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
class Map: UIViewController ,MKMapViewDelegate,UIPopoverControllerDelegate{
    
    let titlelist: [String] = ["ラーメン炙","らぁめん工房かりんとう"]
    let regionlist: [String] = ["北海道函館市美原5丁目39-1","北海道函館市花園町24-21"]
   
    @IBOutlet weak var ramenmap: MKMapView!
    
   
    
    @IBAction func LongPress(_ sender: UILongPressGestureRecognizer) {
    
    guard sender.state == UIGestureRecognizer.State.ended else{
            return
        }
        let pressPoint = sender.location(in: ramenmap)
        let pressCoordinate = ramenmap.convert(pressPoint,toCoordinateFrom: ramenmap)
        let ano = MKPointAnnotation()
        ano.coordinate = pressCoordinate
        ramenmap.addAnnotation(ano)
        
    }
    func addAno(_ latitude:CLLocationDegrees,_ longitude: CLLocationDegrees,_ title:String,_ subtitle:String){
       
         let anno = MKPointAnnotation()
        // 緯度経度を指定
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
        if annotation is MKUserLocation {
            return nil
        }
        let pinview = MKPinAnnotationView(annotation: annotation, reuseIdentifier:nil)
        
        pinview.animatesDrop = true
        pinview.pinTintColor = UIColor.orange
        
        //左ボタンをアノテーションビューに追加する。
         pinview.canShowCallout = true
        pinview.rightCalloutAccessoryView = UIButton(type: UIButton.ButtonType.infoLight)
        
        return pinview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addAno(41.8268,140.7518,titlelist[0] ,regionlist[0])
        addAno(41.7913,140.7794,titlelist[1],regionlist[1])
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
        let storyboard = UIStoryboard(name: "Map", bundle: nil)
        //viewにつけた名前を指定
        let vc = storyboard.instantiateViewController(withIdentifier: "DatailData")
        //popoverを指定する
        vc.modalPresentationStyle = UIModalPresentationStyle.popover
        
        present(vc, animated: true, completion: nil)
        
        let popoverPresentationController = vc.popoverPresentationController
        popoverPresentationController?.sourceView = view
        popoverPresentationController?.sourceRect = view.bounds
     
    }
}

