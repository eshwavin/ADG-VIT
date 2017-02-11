//
//  Events.swift
//  ADG VIT
//
//  Created by Srivinayak Chaitanya Eshwa on 11/02/17.
//  Copyright © 2017 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import RealmSwift

class Events: Object {
    
    dynamic var name: String = ""
    dynamic var attended: Bool = false
    dynamic var date: String = ""
    dynamic var hours: Float = 0.0
    
}
