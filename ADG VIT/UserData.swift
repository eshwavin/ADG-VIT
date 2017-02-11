//
//  UserData.swift
//  ADG VIT
//
//  Created by Srivinayak Chaitanya Eshwa on 11/02/17.
//  Copyright © 2017 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import RealmSwift

class UserData: Object {
    
    dynamic var name: String = ""
    dynamic var email: String = ""
    var events = List<Events>()
    
    override static func primaryKey() -> String {
        return "email"
    }
    
}
