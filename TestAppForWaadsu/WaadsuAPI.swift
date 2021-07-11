//
//  WaadsuAPI.swift
//  TestAppForWaadsu
//
//  Created by Михаил Липунцов on 09.07.2021.
//

import MapKit

class WaadsuAPI {
    
    func getOverlays(complition: @escaping ([MKOverlay]) -> ()) {
        let urlName = "https://waadsu.com/api/russia.geo.json"
        guard let url = URL(string: urlName) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            do {
                let object = try JSONDecoder().decode(Model.self, from: data!)
                var overlays = [MKOverlay]()
                overlays.append(object.multiPolygon)
                complition(overlays)
            }
            catch {
                print(error)
            }
        }.resume()
    }
}
