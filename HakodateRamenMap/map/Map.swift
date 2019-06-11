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
import Foundation
class Map: UIViewController ,MKMapViewDelegate,CLLocationManagerDelegate{
    var locationManager = CLLocationManager()
    let titlelist: [String] = ["ラーメン炙","らぁめん工房かりんとう"]
    let regionlist: [String] = ["北海道函館市美原5丁目39-1","北海道函館市花園町24-21","北海道河東郡音更町木野大通東１７丁目1番５"]
  

    struct Ramenstore: Codable{
        let id: Int
        let store_name: String
        let latitude : Double
        let longitude: Double
        let created_at : String
        let updated_at: String
        let url: URL
    }
    
    @IBOutlet weak var ramenmap: MKMapView!
    @IBOutlet weak var tracking: UIButton!
    

    let image1 = UIImage(named: "trackingnone")!
    let image2 = UIImage(named: "tracking")!
    let image3 = UIImage(named: "trackingheading")!
       var modecount = 0
    let decoder = JSONDecoder()
 
       //マップ上にあらかじめピンを立てる
    func addAno(_ id: Int,_ latitude:CLLocationDegrees,_ longitude: CLLocationDegrees,_ title:String){
       
         let ano = MKPointAnnotation()
        // 緯度経度を指定
        ano.coordinate = CLLocationCoordinate2DMake(latitude,longitude)
        // タイトル、サブタイトルを設定
        ano.title = title
      //  ano.subtitle = subtitle
        // mapViewに追加
        self.ramenmap.addAnnotation(ano)
        ramenmap.delegate = self
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation)
    -> MKAnnotationView? {
    if annotation is MKUserLocation {
            return nil
        }else{
            // CustomAnnotationの場合に画像を配置
            let identifier = "Pin"
        var pinview = MKAnnotationView(annotation: annotation, reuseIdentifier:nil)
            if pinview == nil {
                pinview = MKAnnotationView.init(annotation: annotation, reuseIdentifier: identifier)
            }
            pinview.image = UIImage.init(named: "ramenpin") // 任意の画像名
            pinview.annotation = annotation
            pinview.canShowCallout = true  // タップで吹き出しを表示
        pinview.rightCalloutAccessoryView = UIButton(type: UIButton.ButtonType.infoLight)
        
        return pinview
        }
        

    }
    func locationManager(_ manager: CLLocationManager,didChangeAuthorization status: CLAuthorizationStatus){
      
        
        switch status {
        case .notDetermined:
              locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            tracking.isEnabled = true
        case .restricted, .denied:
            break
        default:
            tracking.setImage(image1, for: .normal)
        }
    }
    
    @IBAction func Taptracking(_ sender: UIButton) {
         modecount+=1
        if(modecount%3==0){
            ramenmap.userTrackingMode = MKUserTrackingMode.none
           tracking.setImage(image1, for: .normal)
        }else if(modecount%3==1){
        ramenmap.userTrackingMode = MKUserTrackingMode.follow
           tracking.setImage(image2, for: .normal)
        }else if(modecount%3==2){
             ramenmap.userTrackingMode = MKUserTrackingMode.followWithHeading
            tracking.setImage(image3, for: .normal)
        }else{}
    }
  
    
    func getRamenStore(){
        let url = "https://ramen-map-server.herokuapp.com/ramen_stores.json"
        get(url: url)
    }
    
    func get(url urlString: String, queryItems: [URLQueryItem]? = nil) {
        var compnents = URLComponents(string: urlString)
        compnents?.queryItems = queryItems
        let url = compnents?.url
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            if let data = data, let response = response {
                print(response)
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    var array:Array<Dictionary<String,Any>> = json as! Array<Dictionary<String, Any>>
                  
                    DispatchQueue.main.async{
                 for i in 0..<array.count{
                    let js = array[i]
                    let lati = Double(js["latitude"] as? String ?? "0") ?? 0
                    let long = Double(js["longitude"] as? String ?? "0") ?? 0
                    let id = js["id"]! as? Int
                    print(id)
                    if let name = js["store_name"] as? String{
                        self.addAno(id ?? 0,lati,long,name) }
                                         }
                                            }
                }catch {
                    print("Serialize Error")
                }
            } else {
                print(error ?? "Error")
            }
        }
        task.resume()
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()        
       getRamenStore()
        self.navigationController?.navigationBar.barTintColor = .orange
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.title = "マップ"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        let ano = MKPointAnnotation()
        let center = CLLocationCoordinate2D(latitude: 41.7687933, longitude:140.7288103)
        let span : MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region : MKCoordinateRegion = MKCoordinateRegion(center: center, span: span)
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        ramenmap.showsScale = true
        ramenmap.addAnnotation(ano)
        ramenmap.setRegion(region, animated: true)
        ramenmap.delegate = self
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //吹き出しアクササリー押下時の呼び出しメソッド
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let storyboard = UIStoryboard(name: "map", bundle: nil)
        //viewにつけた名前を指定
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailData")
        self.navigationController?.pushViewController(vc, animated: true)
        
        print(control)
    }
}

