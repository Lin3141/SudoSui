//
//  HospitalData.swift
//  SudoSui
//
//  Created by lingxinchen on 4/26/22.
//

protocol HospitalDataDelegate {
    func hospitalDataDidUpdate (_ hospitalDataModel: [HospitalDataModel?])
    func hospitalDataDidFailWithError (error: Error)
}

import Foundation
import CoreLocation

struct HospitalData {
    var delegate: HospitalDataDelegate?
    let hospitalURL = "https://api.tomtom.com/search/2/search/psychiatric%20hospital.json?radius=30000&minFuzzyLevel=1&maxFuzzyLevel=2&categorySet=7321&view=Unified&relatedPois=off&key=QCH8EKDfW0o4bLXnfA0WDGGkB0adM058&limit=5"
    
    func getHospital(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        performRequest(urlString: "\(hospitalURL)&lat=\(lat)&lon=\(lon)")
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: handleCompletion(data:response:error:))
            task.resume()
        }
    }
    
    func handleCompletion(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
        guard let data = data else {
            return
        }
        let model = parseData(hospitalData: data)
        if model.count > 0 {
            delegate?.hospitalDataDidUpdate(model)
        }
    }
    
    func parseData(hospitalData: Data) -> [HospitalDataModel?] {
        do {
            let parsedData = try JSONDecoder().decode(HospitalDataStructure.self, from: hospitalData)
            var models: [HospitalDataModel] = []
            var model: HospitalDataModel
            var poi: Poi
            for r in parsedData.results {
                poi = r.poi
                model = HospitalDataModel(name: poi.name, url: poi.url, address: r.address.freeformAddress, phone: poi.phone)
                models.append(model)
            }
            return models
        } catch {
            print(error.localizedDescription)
            delegate?.hospitalDataDidFailWithError(error: error)
            return []
        }
    }
}
