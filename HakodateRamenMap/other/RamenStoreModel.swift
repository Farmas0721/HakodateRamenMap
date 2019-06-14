//
//  RamenStoreModel.swift
//  HakodateRamenMap
//
//  Created by asahi nakamura on 2019/06/14.
//  Copyright © 2019 asahi. All rights reserved.
//

class RamenStoreModel: NSObject {
    var id: Int?
    var store_name: String?
    var longitude: Float?
    var latitude: Float?
    var url: String?
    
    override init() {
        
    }
    
    init(item: Dictionary<String, Any>)  {
        self.id = item["id"] as? Int
        self.store_name = item["store_name"] as? String
        self.latitude = item["latitude"] as? Float
        self.longitude = item["logitude"] as? Float
        self.url = item["url"] as? String
    }
    
}
