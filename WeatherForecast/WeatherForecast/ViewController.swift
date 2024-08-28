//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Oliver Blass on 13.08.24.
//

import UIKit
// 1
import CoreLocation
import SwiftUI

class ViewController: UIViewController {

    var locationManager: CLLocationManager?
    var location: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 2
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        

        // 3
        locationManager?.requestWhenInUseAuthorization()
        location = locationManager?.location
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            print("When user did not yet determined")
        case .restricted:
            print("Restricted by parental control")
        case .denied:
            print("When user select option Dont't Allow")
        case .authorizedWhenInUse:
            print("When user select option Allow While Using App or Allow Once")
        default:
            print("default")
        }
    }
}

struct locationView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> ViewController {
        return ViewController()
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        //todo
    }
    
    typealias UIViewControllerType = ViewController

    
}
