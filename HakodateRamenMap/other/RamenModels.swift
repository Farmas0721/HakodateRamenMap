//
//  ramenModels.swift
//  HakodateRamenMap
//
//  Created by asahi nakamura on 2019/06/14.
//  Copyright © 2019 asahi. All rights reserved.
//

class RamenModel: NSObject {
    var id:Int?
    var name: String?
    var price: Int?
    var taste: String?
    var soup: String?
    var noodle_type: String?
    var ramen_store_id: Int?
    var url: String?
    var picture_url: String?
    
    
    override init() {
    }
    
    init(item: Dictionary<String, Any>) {
        self.id = item["id"] as? Int
        self.name = item["name"] as? String
        self.price = item["price"] as? Int
        self.taste = item["taste"] as? String
        self.soup = item["soup"] as? String
        self.noodle_type = item["noodle_type"] as? String
        self.ramen_store_id = item["ramen_store_id"] as? Int
        self.url = item["url"] as? String
        self.picture_url = item["picture_url"] as? String
    }
}

