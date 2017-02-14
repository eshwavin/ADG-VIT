//
//  Weather.swift
//  ADG VIT
//
//  Created by Srivinayak Chaitanya Eshwa on 15/02/17.
//  Copyright © 2017 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import RealmSwift

class Weather: Object {
    
    dynamic var weatherLabelText: String = ""
    dynamic var weatherIconName: String = ""
    dynamic var key: String = ""
    
    override static func primaryKey() -> String {
        return "key"
    }
    
}
