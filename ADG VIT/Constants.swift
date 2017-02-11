//
//  Constants.swift
//  ADG VIT
//
//  Created by Srivinayak Chaitanya Eshwa on 29/01/17.
//  Copyright © 2017 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import Foundation

// MARK: - Color funnction to make it easy

func color(red r: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
}

// MARK: - Weather

let newsInactiveColor = color(red: 110, green: 108, blue: 108, alpha: 1.0)

let openWeatherAPIKey = "e343a75897575e20579e9b66cfafdcd5"

// MARK: - General

typealias JSONDictionary = [String : AnyObject]

typealias JSONArray = Array<AnyObject>

func showAlert(_ title: String!, message: String!) -> UIAlertController {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    return alertController
}


// MARK: - Reachability

let WIFI = "WIFI Available"

let NOACCESS = "No Internet Access"

let WWAN = "Cellular Access Available"

func noInternetAccessAlert() -> UIAlertController {
    return showAlert("No internet access!", message: "Please connect to the internet and try again")
}

// MARK: - SWRevealViewController

let SWRevealWidth: CGFloat = 150.0

// MARK: - Projects Colors

//let projectColors: [UIColor] = [UIColor.blue, UIColor.red, UIColor.green, UIColor.yellow]

let projectColors: [UIColor] = [color(red: 0, green: 118, blue: 255, alpha: 1.0), color(red: 37, green: 207, blue: 155, alpha: 1.0), color(red: 119, green: 60, blue: 170, alpha: 1.0)]

let projectDetailsBackgroundColor = color(red: 12, green: 20, blue: 30, alpha: 1.0)

// MARK: - Events Colors

let eventColors: [UIColor] = [color(red: 0, green: 118, blue: 255, alpha: 1.0), color(red: 37, green: 207, blue: 155, alpha: 1.0), color(red: 119, green: 60, blue: 170, alpha: 1.0)]

let eventDetailsBackgroundColor = color(red: 12, green: 20, blue: 30, alpha: 1.0)

// MARK: - Two Credit Course

let borderColor = color(red: 2, green: 128, blue: 186, alpha: 1.0)

let attendedColor = color(red: 120, green: 202, blue: 212, alpha: 1.0)
let absentColor = color(red: 231, green: 78, blue: 97, alpha: 1.0)

// MARK: - Team

let teamColor = color(red: 37, green: 207, blue: 155, alpha: 1.0)


