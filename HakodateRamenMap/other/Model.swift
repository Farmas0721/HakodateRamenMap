//
//  Model.swift
//  HakodateRamenMap
//
//  Created by 山田楓也 on 2019/05/06.
//  Copyright © 2019 asahi. All rights reserved.
//

import Foundation

struct ranmenDetail:Codable{
    var ramen_name:String
    var soup:String
    var taste:String
    var noodle_type:String
    var address:Int
}

struct ramenStore:Codable {
    var store_name:String
    var store_number:Int
    var latitude:Int
    var longitude:Int
}

struct storeDetail:Codable {
    var store_name:String
    var store_number:Int
    var address:Int
    var postal_code:Int
    var phone_number:Int
}
