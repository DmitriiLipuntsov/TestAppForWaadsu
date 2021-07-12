//
//  WaadsuAPI.swift
//  TestAppForWaadsu
//
//  Created by Михаил Липунцов on 09.07.2021.
//

import MapKit

protocol NetworkServiceProtocol {
    func getOverlays(complition: @escaping (Result<([MKOverlay], [CLLocationCoordinate2D]), Error>) -> ())
}

struct WaadsuAPI: NetworkServiceProtocol {
    
    func getOverlays(complition: @escaping (Result<([MKOverlay], [CLLocationCoordinate2D]), Error>) -> ()) {
        let urlName = "https://waadsu.com/api/russia.geo.json"
        guard let url = URL(string: urlName) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            do {
                let object = try JSONDecoder().decode(Model.self, from: data!)
                let overlays = [object.multiPolygon]
                let coordinats = object.coordinates
                
                complition(.success((overlays, coordinats)))
            }
            catch {
                complition(.failure(error))
            }
        }.resume()
    }
}
