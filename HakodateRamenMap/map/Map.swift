//
//  ViewController.swift
//  Mapping
//
//  Created by 宮下翔伍 on 2019/02/27.
//  Copyright © 2019 宮下翔伍. All rights reserved.
//

import UIKit
import MapKit

class Map: UIViewController ,MKMapViewDelegate{
    
    var anolist = Array<MKPointAnnotation>()
   
    @IBOutlet weak var ramenmap: MKMapView!
    
   
    @IBAction func LongPressPin(_ sender: UILongPressGestureRecognizer) {
    
    guard sender.state == UIGestureRecognizer.State.ended else{
            return
        }
        let pressPoint = sender.location(in: ramenmap)
        let pressCoordinate = ramenmap.convert(pressPoint,toCoordinateFrom: ramenmap)
        let ano = MKPointAnnotation()
        ano.coordinate = pressCoordinate
        anolist.append(ano)
        ramenmap.addAnnotation(ano)
        
    }
    func mapView(_ mapView: MKMapView, viewFor ano:MKAnnotation) -> MKAnnotationView? {
        let pinview = MKPinAnnotationView()
        pinview.animatesDrop = true
        pinview.isDraggable = true
        pinview.pinTintColor = UIColor.orange
        pinview.canShowCallout = true
        return pinview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = .orange
        self.navigationController?.navigationBar.tintColor = .white

       //let ano = MKPointAnnotation()
        let center = CLLocationCoordinate2D(latitude: 41.7687933, longitude:140.7288103)
        let span : MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region : MKCoordinateRegion = MKCoordinateRegion(center: center, span: span)
        
        //ramenmap.addAnnotation(ano)
        ramenmap.setRegion(region, animated: true)
    }
    
    
}


