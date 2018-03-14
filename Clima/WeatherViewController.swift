//
//  ViewController.swift
//  WeatherApp
//
//

import UIKit
// coreLocation helps us tap into GPS functionality of iPhone
import CoreLocation


class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "dc610b4bd5ea11a129a058857048ef1d"
    

    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()

    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO:Set up the location manager here.
        locationManager.delegate = self
            //set the appropriate accuracy of the GPS
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            //Ask users to verify GPS use when app is used. 
        locationManager.requestWhenInUseAuthorization()
            //When GPS is authorized, get the GPS data (asynchronous)
            //because we conformed to the CLLocationManagerDelegate, the
            //location data will be sent to the class itself.
        locationManager.startUpdatingLocation()
    
        
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    

    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // If location is found, it is stored in the locations array in the parameter
        // The last element of the array is the most accurate.
        let location = locations[locations.count - 1]
        //check the validity of the location
        if location.horizontalAccuracy > 0 {
            // once you get the location, stop updating/hogging battery
            locationManager.stopUpdatingLocation()
            
            print("longitude = \(location.coordinate.longitude)")
            print ("latitude = \(location.coordinate.latitude)")
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        cityLabel.text = "Location not available"
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    

    
    //Write the PrepareForSegue Method here
    
    
    
    
    
}


