//
//  WaadsuAPI.swift
//  TestAppForWaadsu
//
//  Created by Михаил Липунцов on 09.07.2021.
//

import MapKit

class WaadsuAPI {
    
    func getOverlays(complition: @escaping ([MKOverlay], [CLLocationCoordinate2D]) -> ()) {
        let urlName = "https://waadsu.com/api/russia.geo.json"
        guard let url = URL(string: urlName) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            do {
                let object = try JSONDecoder().decode(Model.self, from: data!)
                let overlays = [object.multiPolygon]
                let coordinats = object.coordinates
                
                complition(overlays, coordinats)
            }
            catch {
                print(error)
            }
        }.resume()
    }
}
