//
//  ViewController.swift
//  WeatherApp
//
//

import UIKit
// coreLocation helps us tap into GPS functionality of iPhone
import CoreLocation
import Alamofire
import SwiftyJSON


class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "dc610b4bd5ea11a129a058857048ef1d"
    

    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    var tempCelsius = 0.0

    var num = 0
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
   
    @IBOutlet weak var unitChangeSwitch: UISwitch!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set the unitChangeSwitch to off position
        unitChangeSwitch.isOn = false
        
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
    
    
    @IBAction func unitSwitch(_ sender: Any) {
        if unitChangeSwitch.isOn == true {
           // temperatureLabel.text = ""
            temperatureLabel.text = "\(Int((1.8 * tempCelsius) + 32))"
            temperatureLabel.text?.append("°F")
        }
        if unitChangeSwitch.isOn == false {
            //temperatureLabel.text = ""
            temperatureLabel.text = "\(Int(tempCelsius))"
            //temperatureLabel.text = "\((Int((Double(temperatureLabel.text!)! - 32)/1.8)))"
            temperatureLabel.text?.append("°C")
        }
    }
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
//    request(
//    _ url: URLConvertible,
//    method: HTTPMethod = .get,
//    parameters: Parameters? = nil,
//    encoding: ParameterEncoding = URLEncoding.default,
//    headers: HTTPHeaders? = nil)
    
    func getWeatherData(url: String, parameters: [String: String]) {
        //get request
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success, got the weather data")
                let weatherJSON: JSON = JSON(response.result.value!)
               // print(weatherJSON)
                self.updateWeatherData(json: weatherJSON)
            }
            else {
                print("Error: \(response.result.error)")
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    func updateWeatherData(json: JSON) {
        // if data was not returned properly, tempResult would be nil & else statement would execute
        if let tempResult = json["main"]["temp"].double {
        print(tempResult)
        tempCelsius = tempResult - 273.15
        weatherDataModel.temp = Int(tempResult - 273.15)
        weatherDataModel.city = json["name"].stringValue
        weatherDataModel.condition = json["weather"][0]["id"].intValue
        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            //display info in the UI
            updateUIWithWeatherData()
        
        }
        else {
            cityLabel.text = "Weather unavailabe"
        }
    }

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    func updateUIWithWeatherData() {
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temp)°C"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    
    
    
    
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
            locationManager.delegate = nil
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            let params : [String:String] = ["lat": latitude, "lon": longitude, "appID": APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
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
    func userEnteredANewCityName(city: String) {
        //print(city)
        let params: [String: String] = ["q": city, "appid": APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
        print("Got Data from my city")
    }
    

    
    //Write the PrepareForSegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "changeCityName") {
            // Set back to celsius because this VC always starts at celsius
            unitChangeSwitch.isOn = false
            //create a temporary variable to refer to the ChangeCityViewController
            let destinationVC = segue.destination as! ChangeCityViewController
            //set the delegate of WeatherViewController.swift to the delegate that you just created
            destinationVC.delegate = self
        }
    }
    
    
    
    
    
}


