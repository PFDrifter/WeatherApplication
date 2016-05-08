//
//  DetailsViewController.swift
//  WeatherApplication
//
//  Created by Jennifer Terpstra on 2016-02-19.
//  Copyright © 2016 Jennifer Terpstra. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var summaryContent: UITextView!
    
    var weatherInformation: WeatherInformation?
    
    var weekForcast: [WeatherEntry] = []
    
    var clickedRow: Int = -1
    
    var currentWeather: WeatherEntry?
    
    var warnings: WeatherEntry?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        summaryContent.text = ""
        //Disable the editing in the UITextView
        summaryContent.editable = false
        
        fillLabel()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fillLabel() {
        //case for if the user clicked on current weather or warnings
        if weekForcast.count == 0 && clickedRow == -1 {
            //user cicked on current weather
            if currentWeather != nil {
                do {
                    //This string allows the UITextView to display HTML
                    let str = try NSAttributedString(data: (currentWeather?.summary.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                    summaryContent.attributedText = str
                } catch {
                    print(error)
                }
            }
            //user clicked on warnings
            if warnings != nil {
                do {
                    //This string allows the UITextView to display HTML
                    let str = try NSAttributedString(data: (warnings?.summary.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                    summaryContent.attributedText = str
                } catch {
                    print(error)
                }
            }
        }
        //case for if user clicked on an element within the week forcast UITable
        else if weekForcast.count != 0 && clickedRow != -1 {
            do {
                //This string allows the UITextView to display HTML
                let str = try NSAttributedString(data: (weekForcast[clickedRow].summary.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!), options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                summaryContent.attributedText = str
            } catch {
                print(error)
            }

        }
    }

}
