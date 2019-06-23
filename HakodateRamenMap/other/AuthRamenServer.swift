//
//  AuthRamenServer.swift
//  HakodateRamenMap
//
//  Created by asahi nakamura on 2019/06/12.
//  Copyright © 2019 asahi. All rights reserved.
//

import Foundation
import Kanna

class AuthRamenServer{
    //static variable
    static var isLogin: Bool = false
    
    //
    private let root = "https://ramen-map-server.herokuapp.com"
    private var cookieKey = "_ramen_map_server_session"
    //variable
    private var cookie = HTTPCookieStorage()
    
    private func post(url: String, json: Data, cookies: HTTPCookie?, completion: @escaping ((_ data: Data, _ response: HTTPURLResponse, _ error: Error?) -> Void)){
        var request = URLRequest(url: URL(string:  url)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json
        request.setCookieField([cookies!])
        
        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let response = response as? HTTPURLResponse {
                self.loadCookie(name: self.cookieKey, response: response)
                completion(data, response, error)
                semaphore.signal()
            }
        }.resume()
        semaphore.wait()

    }
    
    private func get(url urlString: String, cookie: HTTPCookie? = nil, completion: @escaping ((_ data: Data, _ response: HTTPURLResponse, _ error: Error?) -> Void)){
        var request = URLRequest(url: URL(string:  urlString)!)
        if cookie != nil {
            request.setCookieField([cookie!])
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let response = response as? HTTPURLResponse {
                self.loadCookie(name: self.cookieKey, response: response)
                completion(data, response, error)
                semaphore.signal()
            }
        }.resume()
        semaphore.wait()
    }
    
    func login(email: String, password: String){
        let url = "https://ramen-map-server.herokuapp.com/login"
        var token: String?
        
        get(url: url, completion: { data, response, error in
            token = self.createKannaObj(data: data)
            })
        
        let jsonurl = "https://ramen-map-server.herokuapp.com/login.json"
        let json = toSessionJSON(email: email, password: password, token: token!)!
        let cookies = getCookie(name: cookieKey, url: URL(string: url)!)
        
        post(url: jsonurl, json: json, cookies: cookies, completion: { data , responce, error in
            do {
                _ = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            } catch {
                //NSCocoaErrorDomain
                print("loginでerror")
            }
        })
        AuthRamenServer.isLogin = true
    }
    
    func getRamenStore(id :Int? = nil) -> Array<RamenStoreModel>{
        let ramenStoreUrl = "https://ramen-map-server.herokuapp.com/ramen_stores.json"
        let cookie = getCookie(name: self.cookieKey, url: URL(string: self.root)!)
        var ramenStoreModels = Array<RamenStoreModel>()
        get(url: ramenStoreUrl, cookie: cookie, completion: { data, response, error in
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                let array:Array<Dictionary<String,Any>> = json as! Array<Dictionary<String, Any>>
                
                for item in array{
                    ramenStoreModels.append(RamenStoreModel(item: item))
                }
            } catch {
                print("getramenstoreでeroor\(error)")
            }
        })
        
        return ramenStoreModels
    }
    
    func getStoreDetail(id :Int? = nil) -> Array<StoreDetailModel>{
        let ramenStoreUrl = "https://ramen-map-server.herokuapp.com/store_details.json"
        let cookie = getCookie(name: self.cookieKey, url: URL(string: self.root)!)
        var storeDetailModels = Array<StoreDetailModel>()
        get(url: ramenStoreUrl, cookie: cookie, completion: { data, response, error in
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                let array:Array<Dictionary<String,Any>> = json as! Array<Dictionary<String, Any>>
                
                for item in array{
                    storeDetailModels.append(StoreDetailModel(item: item))
                }
            } catch {
                print(error)
            }
        })
        
        return storeDetailModels
    }
    
    func getRamen(id :Int? = nil) -> Array<RamenModel>{
        let ramenStoreUrl = "https://ramen-map-server.herokuapp.com/ramen.json"
        let cookie = getCookie(name: self.cookieKey, url: URL(string: self.root)!)
        var ramenModels = Array<RamenModel>()
        get(url: ramenStoreUrl, cookie: cookie, completion: { data, response, error in
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                let array:Array<Dictionary<String,Any>> = json as! Array<Dictionary<String, Any>>
                
                for item in array {
                    ramenModels.append(RamenModel(item: item))
                }
            } catch {
                print(error)
            }
            
        })
        return ramenModels
    }
    
    private func toSessionJSON(email: String, password: String, token: String) -> Data?{
        do{
            let session  = ["email": email, "password": password]
            let json = ["session": session, "authenticity_token": token] as [String : Any]
            let jsonData = try JSONSerialization.data(withJSONObject: json)
            return jsonData
        } catch {
            print("ERROR")
            return nil
        }
        
    }
    
    private func createKannaObj(data: Data) -> String{
        do{
        let obj = try HTML(html: data, encoding: String.Encoding.utf8)
            for node in obj.xpath("//meta"){
                if node["name"]! == "csrf-token" {
                    return node["content"]!
                }
            }
        } catch {
            print("not .html")
        }
        return ""
    }
    
    // HTTPURLResponseから特定のCookieを探し、HTTPCookieStorageに保存する
    private func loadCookie(name: String, response: HTTPURLResponse) {
        if let fields = response.allHeaderFields as? [String: String], let url = response.url {
            for cookie in HTTPCookie.cookies(withResponseHeaderFields: fields, for: url) {
                if (cookie.name == name) {
                    HTTPCookieStorage.shared.setCookie(cookie)
                }
            }
        }
    }
    
    
    
    // HTTPCookieStorageから特定のCookieを取得する
    private func getCookie(name: String, url: URL) -> HTTPCookie? {
        if let cookies = HTTPCookieStorage.shared.cookies(for: url) {
            for cookie in cookies {
                if (cookie.name == name) {
                    return cookie
                }
            }
        }
        
        return nil
    }
    
}

extension URLRequest {
    mutating func setCookieField(_ cookies: [HTTPCookie]) {
        let cookiesString = cookies
            .map { "\($0.name)=\($0.value)" }
            .joined(separator: "; ")
        setValue(cookiesString, forHTTPHeaderField: "Cookie")
    }
}
