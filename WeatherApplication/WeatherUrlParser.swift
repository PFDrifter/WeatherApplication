//
//  WeatherUrlParser.swift
//  WeatherApplication
//
//  Created by Jennifer Terpstra on 2016-02-20.
//  Copyright © 2016 Jennifer Terpstra. All rights reserved.
//

import Foundation

class WeatherUrlParser: NSObject, NSXMLParserDelegate {
    
    var xmlData: String = ""
    var parser = NSXMLParser()
    
    var entryTitle: String!
    var entryCategory: String!
    var entrySummary: String!
    
    var parsedEntry = String()
    var withinEntry = false
    
    var entries = [WeatherEntry]()
    
    func parseUrl(url: String) -> [WeatherEntry] {
        let urlToUse: NSURL = NSURL(string: url)!
        
        // Parse the XML
        parser = NSXMLParser(contentsOfURL: urlToUse)!
        parser.delegate = self
        
        parser.parse()
        
        return entries
        
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        //Identifes entry elements within the xml
        if elementName == "entry" {
            withinEntry = true
        }
        //Moves to parse elements within the entry element within the xml
        if withinEntry {
            switch elementName {
            case "title":
                entryTitle = String()
                parsedEntry = "title"
            case "category":
                entryCategory = attributeDict["term"]! as String
                parsedEntry = "category term"
            case "summary":
                entrySummary = String()
                parsedEntry = "summary"
                
            default: break
                
            }
        }
        
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if withinEntry {
            switch elementName {
            case "title":
                parsedEntry = ""
            case "category":
                parsedEntry = ""
            case "summary":
                parsedEntry = ""
            default: break
            }
        }
        //Once the xml is done parsing save all the values into the WeatherEntry data structure
        if elementName == "entry" {
                let weatherEntry = WeatherEntry()
                weatherEntry.title = entryTitle
                weatherEntry.category = entryCategory
                weatherEntry.summary = entrySummary
                entries.append(weatherEntry)
                withinEntry = false
            
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        
        if withinEntry {
            switch parsedEntry {
            case "title":
                entryTitle = entryTitle + string
            case "category":
                entryCategory = entryCategory + string
            case "summary":
                entrySummary = entrySummary + string
            default: break
            }
        }
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        
    }
    
    
    
}