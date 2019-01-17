//
//  WeatherViewController.swift
//  TestWeather
//
//  Created by Jakub Iwaszek on 14/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class WeatherViewController: UIViewController {

    //MARK - Variables initialization
    
    @IBOutlet weak var sunLabel: UILabel!
    @IBOutlet weak var rainLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var stormLabel: UILabel!
    
    var weatherModel :Weather!
    var idUrl :Int = 0
    var currentCityTitle :String = "" {
        didSet {
            title = currentCityTitle
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Loader.start()
        fetchWeatherInfoByJSON()
    }
    
    //MARK - Fetching weather data info
    
    func fetchWeatherInfoByJSON() {
        let url = URL(string: "https://concise-test.firebaseio.com/weather/\(idUrl).json")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            Loader.stop()
            guard error == nil else {
                self.displayAlert(errorMessage: error!.localizedDescription, tryAgainClosure: {
                    self.fetchWeatherInfoByJSON()
                })
                return
            }
            guard let content = data else {
                self.displayAlert(errorMessage: "Error while updating content", tryAgainClosure: {
                    self.fetchWeatherInfoByJSON()
                })
                return
            }
            
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: .mutableContainers)) as? [String: Any] else {
                self.displayAlert(errorMessage: "Error while fetching data", tryAgainClosure: {
                    self.fetchWeatherInfoByJSON()
                })
                return
            }
            
            guard let rain = json["rain"] as? Double, let sun = json["sun"] as? Int, let temperature = json["temperature"] as? Int, let wind = json["wind"] as? Int, let storm = json["storm"] as? Bool else {
                self.displayAlert(errorMessage: "Error, missing data", tryAgainClosure: {
                    self.fetchWeatherInfoByJSON()
                })
                return
            }
            
            self.weatherModel = Weather(rain: rain, sun: sun, temperature: temperature, wind: wind, storm: storm)
            
            DispatchQueue.main.async {
                self.updateLabels()
            }
        }
        task.resume()
    }
    
    //MARK - Update labels info (storyboard)
    
    func updateLabels() {
        let sunNumeric = weatherModel.sun
        let sunEnum = SunTextEnum(rawValue: sunNumeric)
       
        
        sunLabel.text = sunEnum?.stringDescription
        rainLabel.text = String(weatherModel.rain * 100) + "%"
        tempLabel.text = String(weatherModel.temperature) + "°C"
        windLabel.text = String(weatherModel.wind) + " km/h"
        
        weatherModel.storm ? (stormLabel.text = "YES") : (stormLabel.text = "NO")
    }
    
}

enum SunTextEnum: Int {
    case cloudy = 0
    case cloudsSun = 1
    case sunClouds = 2
    case sunny = 3
    
    var stringDescription: String {
        switch self{
        case .cloudy: return NSLocalizedString("Cloudy", comment: "")
        case .cloudsSun: return NSLocalizedString("Clouds & Sun", comment: "")
        case .sunClouds: return NSLocalizedString("Sun & Clouds", comment: "")
        case .sunny: return NSLocalizedString("Sunny", comment: "")
        }
    }
   
}
