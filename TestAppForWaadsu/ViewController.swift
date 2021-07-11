//
//  ViewController.swift
//  TestAppForWaadsu
//
//  Created by Михаил Липунцов on 09.07.2021.
//

import UIKit
import MapKit
import CoreLocation

/*
 Нужно бы поработать над архитектурой и чистотой кода, но на это не хватило времени.
 */
class ViewController: UIViewController {

    //MARK: - Properties
    var mapView: MKMapView!
    let waadsuAPI = WaadsuAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        createMapView()
        waadsuAPI.getOverlays { overlays in
            DispatchQueue.main.async {
                self.mapView.addOverlays(overlays)
            }
        }
    }
    
    //MARK: - UI creation
    private func createMapView() {
        mapView = MKMapView()
        view.addSubview(mapView)
        
        mapView.delegate = self
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    private func calculate() {
        
    }
}

//MARK: - MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        guard let polygon = overlay as? MKMultiPolygon else { return MKOverlayRenderer() }
        let renderer = MKMultiPolygonRenderer(multiPolygon: polygon)
        renderer.strokeColor = .blue
        return renderer
        
    }
}
