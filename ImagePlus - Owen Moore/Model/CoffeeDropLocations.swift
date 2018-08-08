//
//  CoffeeDropLocations.swift
//  ImagePlus - Owen Moore
//
//  Created by Ashley Moore on 06/08/2018.
//  Copyright © 2018 Owen Moore. All rights reserved.
//

import UIKit

// Data structure for the map locations

struct CoffeeDropData {
    var latitude: Float
    var longitude: Float
    var locationName: String
    var openingTimes: [String]
}

// Arrays for the opening times for the click through controller

var tempOpeningTimes = [String]()
var coffeeDropDataArray = [CoffeeDropData]()

// Arrays for the search closest shop method

var storePostcodeArray = [String]()
var closestShop = [String]()

// Arrays for the cashback method

var podQuantityArray = [String]()
var cashbackArray = [String]()
