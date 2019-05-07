//
//  URLSessionGetClient.swift
//  HakodateRamenMap
//
//  Created by 山田楓也 on 2019/05/07.
//  Copyright © 2019 asahi. All rights reserved.
//

import Foundation
let url = URL(string: "https://images-api.nasa.gov/search?media_type=image")

class Request{
    func get(url urlString:String){
    let url = URL(string: urlString)
    let task = URLSession.shared.dataTask(with: url!) { data, response, error in
        if let data = data, let response = response {
            print("//////response\(response)")
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                print("///////json\(json)")
            } catch {
                print("Serialize Error")
            }
        } else {
            print(error ?? "Error")
        }
    }
    task.resume()
  }
}
