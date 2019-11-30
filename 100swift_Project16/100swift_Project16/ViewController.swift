//
//  ViewController.swift
//  100swift_Project16
//
//  Created by MAC on 25/11/2019.
//  Copyright © 2019 Gera Volobuev. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map look", style: .plain, target: self, action: #selector(changeMap))
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home of the 2012 Summer Olympics")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded a 100 years ago")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 45.8567, longitude: 2.3508), info: "Often city of light")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it")
        let washington = Capital(title: "Washington", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself")
        
        mapView.addAnnotations([london,oslo,paris,rome,washington])
    }

    @objc func changeMap() {
        let ac = UIAlertController(title: "Change map look", message: "What view do you want to choose?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Satellite", style: .default, handler: { action in
            //run your function here
            self.mapView.mapType = .satellite
        }))
        ac.addAction(UIAlertAction(title: "Standard", style: .default, handler: { action in
            //run your function here
            self.mapView.mapType = .standard
        }))
        present(ac, animated: true)

    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.tintColor = UIColor.cyan
        
        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        let cityName = capital.title!
//        let placeInfo = capital.info
//        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "Ok", style: .default))
//        present(ac, animated: true)
        if let WVC = storyboard?.instantiateViewController(withIdentifier: "WebView") as? WebViewController {
            WVC.wikiCity = cityName
            navigationController?.pushViewController(WVC, animated: true)
        }
        print(cityName)

    }
}

