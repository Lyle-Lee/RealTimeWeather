//
//  Weather.swift
//  Weather
//
//  Created by Lyle Lee on 2021/06/24.
//

import Foundation

class Weather {
    var temp: String
    var icon: String
    var city: String
    var adm: String
    
    init(temp: String, icon: String, city: String, adm: String) {
        self.temp = temp
        self.icon = icon
        self.city = city
        self.adm = adm
    }
}
