//
//  VCHelper.swift
//  Weather
//
//  Created by Lyle Lee on 2021/06/27.
//

import Foundation
import UIKit
import SwiftyJSON

extension ViewController {
    func showWeather(_ weatherJSON: JSON) {
        // stringValue returns an empty string when request fails, but not nil as string does
        weather.temp = "\(weatherJSON["now", "temp"].stringValue)˚"
        weather.icon = weatherJSON["now", "icon"].stringValue
        
        tempLabel.text = weather.temp
        iconImageView.image = UIImage(named: weather.icon)
    }
    
    func showCity(_ cityJSON: JSON, main: String = "name") {
        weather.city = cityJSON["location", 0, main].stringValue
        weather.adm = cityJSON["location", 0, "adm2"].stringValue
        if main == "name" {
            cityLabel.text = weather.city
        } else {
            cityLabel.text = weather.city + ", " + weather.adm
        }
    }
    
    func getParams(_ location: String, number: Int = 0, lang: String = "en") -> [String: Any] {
        if number == 0 {
            return ["location": location, "key": kQWeatherWebKey, "lang": lang]
        } else {
            return ["location": location, "key": kQWeatherWebKey, "number": number, "lang": lang]
        }
    }
}

extension String {
    func replace(string: String, replacement: String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }

    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
}
