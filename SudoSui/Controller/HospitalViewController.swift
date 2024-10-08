//
//  MeViewController.swift
//  SudoSui
//
//  Created by lingxinchen on 4/24/22.
//

import UIKit
import CoreLocation

class HospitalViewController: UIViewController {
    var locationManager = CLLocationManager()
    var hospitalData = HospitalData()
    var hospitalDataModels: [HospitalDataModel?] = []
    @IBOutlet weak var hospitalCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        hospitalData.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        hospitalCollectionView.delegate = self
        hospitalCollectionView.dataSource = self
        
    }
    
    @IBAction func findButton(_ sender: UIButton) {
        locationManager.requestLocation()
        let lat = locationManager.location?.coordinate.latitude
        let lon = locationManager.location?.coordinate.longitude
        if let lat = lat, let lon = lon {
            hospitalData.getHospital(lat: lat, lon: lon)
        }
    }
}

//MARK: Location functions
extension HospitalViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            hospitalData.getHospital(lat: lat, lon: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

//MARK: HospitalDataDelegate
extension HospitalViewController: HospitalDataDelegate {
    func hospitalDataDidUpdate(_ hospitalDataModel: [HospitalDataModel?]) {
        DispatchQueue.main.async {
            self.hospitalDataModels = hospitalDataModel
            self.hospitalCollectionView.reloadData()
        }
    }
    
    func hospitalDataDidFailWithError(error: Error) {
        print(error.localizedDescription)
    }
}

//MARK: CollectionView Functions
extension HospitalViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hospitalDataModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
        if let aCell = cell as? HospitalCollectionViewCell {
            let index = indexPath.item
            var info: String = "\(index+1): "
            if let name = hospitalDataModels[index]?.name {
                info += "Name: \(name)\n"
            }
            if let address = hospitalDataModels[index]?.address {
                info += "Address: \(address)\n"
            }
            if let phone = hospitalDataModels[index]?.phone {
                info += "Phone: \(phone)\n"
            }
            if let url = hospitalDataModels[index]?.url {
                info += "Website: \(url)\n"
            }
            aCell.nameLabel.text = info
        }
        return cell
    }
}

