//
//  ViewController.swift
//  Weather
//
//  Created by Lyle Lee on 2021/05/30.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate, QueryViewControllerDelegate {
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let weather = Weather(temp: "", icon: "", city: "", adm: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestLocation()
    }
    
    // System call when requesting user location is successful.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lon = locations[0].coordinate.longitude
        let lat = locations[0].coordinate.latitude
//        print(lon, lat)
        
        AF.request(kQWeatherNowPath, parameters: getParams("\(lon),\(lat)")).responseJSON { (response) in
            if let data = response.value {
                let weatherJSON = JSON(data)
                
                self.showWeather(weatherJSON)
            }
        }
        
        AF.request(kQWeatherCityPath, parameters: getParams("\(lon),\(lat)", number: 1)).responseJSON { (response) in
            if let data = response.value {
                let cityJSON = JSON(data)
                
                self.showCity(cityJSON, main: "adm1")
            }
        }
    }
    
    // System call when requesting user location fails
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Failed to get location"
        iconImageView.image = UIImage(named: "999")
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
//        if segue.identifier == "QueryViewControllerSegue" {
//            let vc = segue.destination as! QueryViewController
//            vc.curCity = weather.city
//        }
        if let vc = segue.destination as? QueryViewController {
            vc.curCity = weather.city
            vc.delegate = self
        }
    }
    
    // Obey the user defined delegate and figurate the func from that delegate
    func didChangeCity(city: String) {
        // Fuzzy Search
        AF.request(kQWeatherCityPath, parameters: getParams(city)).responseJSON { (response) in
            if let data = response.value {
                let cityJSON = JSON(data)
                
                self.showCity(cityJSON)
                
                let cityID = cityJSON["location", 0, "id"].stringValue
                
                // Synchronize Query (must after getting city info)
                AF.request(kQWeatherNowPath, parameters: self.getParams(cityID)).responseJSON { (response) in
                    if let data = response.value {
                        let weatherJSON = JSON(data)
                        
                        self.showWeather(weatherJSON)
                    }
                }
            }
        }
    }
}

