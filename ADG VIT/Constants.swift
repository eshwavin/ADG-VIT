//
//  Constants.swift
//  ADG VIT
//
//  Created by Srivinayak Chaitanya Eshwa on 29/01/17.
//  Copyright © 2017 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import Foundation

func color(red r: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
}

let newsInactiveColor = color(red: 110, green: 108, blue: 108, alpha: 1.0)

let openWeatherAPIKey = "e343a75897575e20579e9b66cfafdcd5"

typealias JSONDictionary = [String : AnyObject]

typealias JSONArray = Array<AnyObject>

let WIFI = "WIFI Available"

let NOACCESS = "No Internet Access"

let WWAN = "Cellular Access Available"

func showAlert(_ title: String, message: String) -> UIAlertController {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    return alertController
}

func noInternetAccessAlert() -> UIAlertController {
    return showAlert("No internet access!", message: "Please connect to the internet and try again")
}
