//
//  File.swift
//  HakodateRamenMap
//
//  Created by 宮下翔伍 on 2019/06/04.
//  Copyright © 2019 asahi. All rights reserved.
//

import Foundation
import UIKit

class Store_Detail_View: UIViewController{
    @IBOutlet weak var Ramenname: UILabel!
   
    struct Ramendetail: Codable{
        let id: Int
        let ramen_store_id : Int
        let name: String
        let soup: String
        let taste: String
        let noodle_type : String
        let price: String
        let picture_url : String
        let created_at : String
        let updated_at: String
        let url: URL
    }
    
    func getRamenStore(){
        let url = "https://ramen-map-server.herokuapp.com/ramen.json"
        get(url: url)
    }
    
    func get(url urlString: String, queryItems: [URLQueryItem]? = nil) {
        var compnents = URLComponents(string: urlString)
        compnents?.queryItems = queryItems
        let url = compnents?.url
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            if let data = data, let response = response {
                print(response)
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                var array:Array<Dictionary<String,Any>> = json as! Array<Dictionary<String, Any>>
                   
                } catch {
                    print("Serialize Error")
                }
            } else {
                print(error ?? "Error")
            }
        }
        task.resume()
    }
    override func viewDidLoad(){
        super.viewDidLoad()
        getRamenStore()
    }
}
