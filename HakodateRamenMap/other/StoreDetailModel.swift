//
//  StoreDetailModel.swift
//  HakodateRamenMap
//
//  Created by asahi nakamura on 2019/06/14.
//  Copyright © 2019 asahi. All rights reserved.
//

class StoreDetailModel: NSObject {
    var id: Int?
    var business_hours: Float?
    var address: Float?
    var url: String?
    var regular_holiday: String?
    var phone_number: String?
    var postal_code: String?
    var ramen_store_id: Int?
    
    override init() {
    }
    
    init(item: Dictionary<String, Any>) {
        self.id = item["id"] as? Int
        self.business_hours = item["business_hours"] as? Float
        self.address = item["address"] as? Float
        self.url = item["url"] as? String
        self.regular_holiday = item["regular_holiday"] as? String
        self.phone_number = item["phone_number"] as? String
        self.postal_code = item["postal_code"] as? String
        self.ramen_store_id = item["ramen_store_id"] as? Int
        
    }
}
