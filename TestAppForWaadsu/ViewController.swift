//
//  ViewController.swift
//  TestAppForWaadsu
//
//  Created by Михаил Липунцов on 09.07.2021.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    //MARK: - Properties
    var mapView: MKMapView!
    var widthRouteLabel: UILabel!
    
    var presenter: PresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        createMapView()
        createWidthRouteLabel()
        
        presenter.getOverlaysAndCoordinates()
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
    
    private func createWidthRouteLabel() {
        widthRouteLabel = UILabel()
        widthRouteLabel.textColor = .red
        widthRouteLabel.font = widthRouteLabel.font.withSize(30)
        widthRouteLabel.text = "000"
        widthRouteLabel.textAlignment = .left
        widthRouteLabel.numberOfLines = 0
        
        view.addSubview(widthRouteLabel)
        
        widthRouteLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            widthRouteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            widthRouteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            widthRouteLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
            
        ])
        
    }
}


//MARK: Presenter delegate
extension ViewController: ViewProtocol {
    func success(overlays: [MKOverlay], widthRoute: String) {
        DispatchQueue.main.async {
            self.mapView.addOverlays(overlays)
            self.widthRouteLabel.text = widthRoute
        }
    }
    
    func failure(error: Error) {
        print(error) // в этом месте можно обработать ошибку, например вызывать алерт
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
