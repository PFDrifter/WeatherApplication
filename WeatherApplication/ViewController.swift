//
//  ViewController.swift
//  WeatherApplication
//
//  Created by Jennifer Terpstra on 2016-02-19.
//  Copyright © 2016 Jennifer Terpstra. All rights reserved.
//

import UIKit
import CSwiftV

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var warnings: UIButton!
    
    @IBOutlet weak var weekForcastTitle: UILabel!
    
    @IBOutlet weak var weekForcastTable: UITableView!
    
    @IBOutlet weak var todaysWeather: UIButton!
    
    @IBOutlet weak var locationNameLabel: UILabel!
    
    var weatherEntries = [WeatherEntry]()
    
    var weatherInformation: WeatherInformation?
    
    var weatherUrlParser: WeatherUrlParser?
    
    var weekForcast: [WeatherEntry] = []
    
    var clickedRow: Int = -1
    
    var currentWeather: WeatherEntry?
    
    var warningEntry: WeatherEntry?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationNameLabel.text = ""
        
        todaysWeather.enabled = false
        //By default when no location has been selected, display this text and disable button
        todaysWeather.setTitle("Please choose a location to view the weather", forState: .Disabled)
        //By default when no location has been selected, display this text and disable button
        warnings.enabled = false
        warnings.setTitle("", forState: .Disabled)
        warnings.titleLabel?.adjustsFontSizeToFitWidth = true
        
        //Reads in the feeds.csv file and saves information into an Array
        weatherInformation = WeatherInformation()
        //Parses the weather XML files for the selected location
        weatherUrlParser = WeatherUrlParser()
        
        weekForcastTable.delegate = self
        weekForcastTable.dataSource = self
        weekForcastTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "TextCell")
        // Removes extra separators from tableview
        weekForcastTable.tableFooterView = UIView(frame: CGRectZero)
        
        weekForcastTitle.hidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Deals with the transitions between views
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? LocationViewController {
            dest.weatherInformation = weatherInformation
        }
        else if let dest = segue.destinationViewController as? DetailsViewController {
            dest.weatherInformation = weatherInformation
            if segue.identifier == "WeekWeather" {
                dest.weekForcast = weekForcast
                dest.clickedRow = clickedRow
            }
            if segue.identifier == "CurrentWeather" {
                dest.currentWeather = currentWeather
            }
            if segue.identifier == "Warnings" {
                dest.warnings = warningEntry
            }
            
            
        }
    }
    
    //Called when the user presses "Save" inside the location picking view
    @IBAction func unwindToMainMenu(sender: UIStoryboardSegue) {
        if let dest = sender.sourceViewController as? LocationViewController {
            //Sets the current location name into the label
            locationNameLabel.text = dest.city.text! + ", " + dest.province.text!
            //Parses the xml into an an array of WeatherEntry objects
            weatherEntries = (weatherUrlParser?.parseUrl((weatherInformation?.getWeatherUrl())!))!
            //show the title for the 7 week forcast
            weekForcastTitle.hidden = false
            //Displays all the current weather data for the chosen location
            fillWeather()
        }
    }
    
    func fillWeather() {
        for entry: WeatherEntry in weatherEntries {
            //Setting the current conditions for the location
            if(entry.category == "Current Conditions") {
                todaysWeather.enabled = true
                todaysWeather.setTitle(entry.title, forState: .Normal)
                currentWeather = entry
            }
            //Saving all weather forcasts (for the week forcast) into an array
            if(entry.category == "Weather Forecasts") {
                weekForcast.append(entry)
            }
            //Setting the current warnings for that location
            if(entry.category == "Warnings and Watches") {
                warnings.enabled = true
                warnings.setTitle(entry.title, forState: .Normal)
                warnings.sizeToFit()
                if(entry.summary.containsString("No watches or warnings in effect")) {
                    warnings.backgroundColor = UIColor.whiteColor()
                }
                else{
                    //If a weather warning is in effect set the buttion red
                    warnings.backgroundColor = UIColor.redColor()
                }
                warningEntry = entry
            }
        }
        //If no daily forcast was found, put in filler text
        if todaysWeather.currentTitle == "Please choose a location to view the weather" {
            todaysWeather.setTitle("Current forcast for this location unavilable", forState: .Disabled)
        }
        
        //Force the UITableView to reload its data to reflect the week forcast
        addIcons()
        weekForcastTable.reloadData()
    }
    
    //Add emoji Icons to represent weather
    func addIcons() {
        for entry: WeatherEntry in weekForcast {
            if entry.title.lowercaseString.containsString("rain") ||
                entry.title.lowercaseString.containsString("drizzle") ||
                entry.title.lowercaseString.containsString("showers") {
                entry.title = "🌧 " + entry.title
            }
            else if entry.title.lowercaseString.containsString("storm") ||
                entry.title.lowercaseString.containsString("thunder") {
                entry.title = "⛈ " + entry.title
            }
            else if entry.title.lowercaseString.containsString("sun") &&
                entry.title.lowercaseString.containsString("cloud") {
                entry.title = "⛅ " + entry.title
            }
            else if entry.title.lowercaseString.containsString("cloud") ||
                entry.title.lowercaseString.containsString("overcast") {
                entry.title = "☁️ " + entry.title
            }
            else if entry.title.lowercaseString.containsString("cloud") ||
                entry.title.lowercaseString.containsString("overcast") {
                entry.title = "☁️ " + entry.title
            }
            else if entry.title.lowercaseString.containsString("sun") ||
                entry.title.lowercaseString.containsString("clear") {
                entry.title = "☀️ " + entry.title
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekForcast.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TextCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.minimumScaleFactor = 0.2
        cell.textLabel?.font = UIFont.systemFontOfSize(9)
        
        cell.textLabel?.text = weekForcast[indexPath.item].title
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        clickedRow = row
        self.performSegueWithIdentifier("WeekWeather", sender: self)
    }

}

