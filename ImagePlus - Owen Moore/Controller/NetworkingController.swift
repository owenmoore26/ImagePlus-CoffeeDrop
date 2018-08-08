//
//  NetworkingController.swift
//  ImagePlus - Owen Moore
//
//  Created by Ashley Moore on 06/08/2018.
//  Copyright © 2018 Owen Moore. All rights reserved.
//

import UIKit
import SwiftyJSON
var i = 1

class NetworkingController: NSObject {

    //MARK: Getting data for the map annotations to be placed.
    
    func parse() {
        
        let urlString = "http://coffeedrop.staging2.image-plus.co.uk/api/locations?page=\(i)"
        if let url = URL(string: urlString) {
            if let data = try? String(contentsOf: url) {
                let json = JSON(parseJSON: data)
                parse(json: json)
            }
        }
    }
    
    //MARK: Parsing data for the map annotations
    
    func parse(json: JSON) {
        
        var loc = String()
        var lat = Float()
        var long = Float()
        var day = String()
        var open = String()
        var closed = String()
        var openingDay = [String]()
        var openingTimesArray = [String]()
        
        for locations in json["data"].arrayValue {
            loc = locations["location"].stringValue
            
            for (key, subJson) in locations {
                print(key, subJson)
                let coordinates = locations["coordinates"]
                lat = coordinates["latitude"].floatValue
                long = coordinates["longitude"].floatValue
            }
            
            for openingTimes in locations["openings"].arrayValue {
                
                day = openingTimes["day"].stringValue
                open = openingTimes["open"].stringValue
                closed = openingTimes["closed"].stringValue
                openingDay.append(contentsOf: [day, open, closed])
                openingTimesArray.append(contentsOf: openingDay)
                openingDay.removeAll()
            }
            
            let object = CoffeeDropData(latitude: lat, longitude: long, locationName: loc, openingTimes: openingTimesArray)
            openingTimesArray.removeAll()
            
            coffeeDropDataArray.append(object)
        }
        i=i+1
    }
    
    //MARK: Query for getting closest shop
    
    func query() {
        
        let urlString = "http://coffeedrop.staging2.image-plus.co.uk/api/location/postcode?postcode=\(storePostcodeArray[0])"
        if let url = URL(string: urlString) {
            if let data = try? String(contentsOf: url) {
                let json = JSON(parseJSON: data)
                parseQuery(json: json)
            }
        }
    }
    
    var closestLocation = String()
    var postcode = String()
    var city = String()
    var line1 = String()
    var line2 = String()
    
    func parseQuery(json: JSON) {
        closestLocation = json["data"]["location"].stringValue
    
        let addressDetails = json["data"]["address"]
        postcode = addressDetails["postcode"].stringValue
        city = addressDetails["city"].stringValue
        line1 = addressDetails["line1"].stringValue
        line2 = addressDetails["line2"].stringValue
        
        closestShop.append(contentsOf: [line1, line2, city, postcode, closestLocation])
    }
    
    //MARK: POST Request For Cash Back
    
    func postRequest() {
        cashbackArray.removeAll()
        let url = URL(string: "http://coffeedrop.staging2.image-plus.co.uk/api/products/quote")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "Ristretto=\(podQuantityArray[0])&Espresso=\(podQuantityArray[1])&Lungo=\(podQuantityArray[2])"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
            }
            
            let response = String(data: data, encoding: .utf8)
            cashbackArray.insert(response!, at: 0)
            DispatchQueue.main.async {
                cashBackTotalLabel.text = "Total Cashback: " + cashbackArray[0] + "p"
            }
        }
        task.resume()
    }
}
