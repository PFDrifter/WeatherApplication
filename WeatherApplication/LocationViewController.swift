//
//  LocationViewController.swift
//  WeatherApplication
//
//  Created by Jennifer Terpstra on 2016-02-19.
//  Copyright © 2016 Jennifer Terpstra. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var save: UIButton!
    
    var weatherInformation: WeatherInformation?
    
    //Information to fill the UIPickerView with the provinces and territories of Canada
    let provinceData: [String] = [
        "","Alberta", "British Columbia", "Manitoba", "New Brunswick", "Newfoundland and Labrodor", "Nova Scotia", "Northwest Territories", "Nunavut", "Ontario", "Prince Edward Island", "Quebec", "Saskatchewan", "Yukon"]
    
    //Once the user picks a province or territory, this is filled with all the valid cities for that area
    var cityData: [String] = [""]
    
    @IBOutlet weak var province: UITextField!
    @IBOutlet weak var city: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let provinceSelect = UIPickerView()
        provinceSelect.dataSource = self
        provinceSelect.delegate = self
        //Identifier for the UIPickerView in order to select the province
        provinceSelect.tag = 0
        
        let citySelect = UIPickerView()
        citySelect.dataSource = self
        citySelect.delegate = self
        //Identifier for the UIPickerView in order to select the city
        citySelect.tag = 1
        
        self.city.inputView = citySelect
        self.province.inputView = provinceSelect
        
        province.delegate = self
        city.delegate = self
        
        // Enable the Save button only when values entered
        checkValidInput()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return self.provinceData.count
        }
        else if pickerView.tag == 1 {
            return self.cityData.count
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 0 {
            return self.provinceData[row]
        }
        else if pickerView.tag == 1 {
            return self.cityData[row]
        }
        return ""
    }
    
    func pickerView(
        pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int) {
        //selecting the province
        if pickerView.tag == 0 {
            self.province.text = self.provinceData[row]
            self.province.endEditing(true)
            
            //If the user edits the province, clear the city name as the new city might not be in the province
            self.city.text = ""
            //Set the background of the UIPicker for the city red to indicate needed input
            self.city.backgroundColor = UIColor.redColor()
            save.enabled = false
            weatherInformation?.cityName = ""
            //Populates the array for all the cities within the province
            chooseCityFromProvince()
            
            weatherInformation?.provinceName = province.text!
        }
        //selecting the city
        else if pickerView.tag == 1 {
            self.city.text = self.cityData[row]
            self.city.endEditing(true)
            weatherInformation?.cityName = city.text!
            
        }
       
    }
    
    func chooseCityFromProvince() {
        cityData = [""]
        let provinceName: String = province.text!
        //Loop through all the arrays of strings which were optained from the feeds.csv
        //These contain the url, city and province name
        for location: [String] in (weatherInformation?.weatherUrls)! {
            if location.contains(provinceName) {
                //index for city name
                cityData.append(location[1])
            }
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        save.enabled = false
    }
    
    func checkValidInput() {
        // Disable the Save button if the text field is empty.
        let provinceBox = province.text ?? ""
        let cityBox = city.text ?? ""
        
        if(provinceBox.isEmpty || cityBox.isEmpty) {
            save.enabled = false
            //Changing the UITextField background color to reflect if the user needs to put in input
            if(provinceBox.isEmpty) {
                province.backgroundColor = UIColor.redColor()
            }
            else{
                province.backgroundColor = UIColor.whiteColor()
            }
            if(cityBox.isEmpty) {
                city.backgroundColor = UIColor.redColor()
            }
            else{
                city.backgroundColor = UIColor.whiteColor()
            }
        }
        //The user has put in values for both the province and the city
        else{
            save.enabled = true
            province.backgroundColor = UIColor.whiteColor()
            city.backgroundColor = UIColor.whiteColor()
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidInput()
    }
}
