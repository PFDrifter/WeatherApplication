//
//  WeatherInformation.swift
//  WeatherApplication
//
//  Created by Jennifer Terpstra on 2016-02-19.
//  Copyright © 2016 Jennifer Terpstra. All rights reserved.
//

import Foundation
import CSwiftV

class WeatherInformation {
    
    var weatherUrls: Array<Array<String>> = [[]]
    
    var cityName: String = ""
    
    var provinceName: String = ""
    
    var url: String = ""
    
    init() {
        weatherUrls = self.readWeatherCsv()
    }
    
    //Function to read the feeds.csv file and save the content into an array of array of strings
    func readWeatherCsv() -> Array<Array<String>> {
        guard let path = NSBundle.mainBundle().pathForResource("feeds", ofType: "csv") else {
            return [[]]
        }
        
        var rows: Array<Array<String>> = [[]]
        
        do {
            //reads file into string
            let content = try String(contentsOfFile:path, encoding: NSUTF8StringEncoding)
            //Uses the CSwiftV library in order to parse through a .csv formatted file, returns array of array of its values
            let csv = CSwiftV(String: content, separator: ", ")
            rows = csv.rows
        }
        catch _ as NSError {
            print("An error has occured when reading the file")
        }
        return rows
    }
    
    //Returns the url to get the weather for the selected location
    func getWeatherUrl() -> String {
        if(cityName != "" && provinceName != ""){
            for location: [String] in weatherUrls {
                //If entry has city name and province name then it is the selected location
                if(location.contains(cityName) && location.contains(provinceName)) {
                    return location[0]
                }
            }
        }
        return ""
    }

}