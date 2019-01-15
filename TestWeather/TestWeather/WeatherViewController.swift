//
//  WeatherViewController.swift
//  TestWeather
//
//  Created by Jakub Iwaszek on 14/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var sunLabel: UILabel! {
        didSet{
            sunLabel.adjustsFontSizeToFitWidth = true
            sunLabel.minimumScaleFactor = 0.2
            sunLabel.numberOfLines = 1
        }
    }
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
        fetchWeatherInfoByJSON()
    }
    
    func fetchWeatherInfoByJSON() {
        let url = URL(string: "https://concise-test.firebaseio.com/weather/\(idUrl).json")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            guard error == nil else { print("error"); return }
            guard let content = data else { print("data error"); return }
            
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: .mutableContainers)) as? [String: Any] else {
                print("json error")
                return
            }
            
            guard let rain = json["rain"] as? Double, let sun = json["sun"] as? Int, let temperature = json["temperature"] as? Int, let wind = json["wind"] as? Int, let storm = json["storm"] as? Bool else {
                print("error")
                return
            }
            
            self.weatherModel = Weather(rain: rain, sun: sun, temperature: temperature, wind: wind, storm: storm)
            
            DispatchQueue.main.async {
                self.updateLabels()
            }
        }
        task.resume()
    }
    
    func updateLabels() {
        let sunNumeric = weatherModel.sun
        var sunText = ""
        switch sunNumeric{
        case sunTextEnum.Cloudy.rawValue: sunText = "Cloudy"
        case sunTextEnum.CloudsSun.rawValue: sunText = "Clouds & Sun"
        case sunTextEnum.SunClouds.rawValue: sunText = "Sun & Clouds"
        case sunTextEnum.Sunny.rawValue: sunText = "Sunny"
        default: sunText = ""
        }
        
        sunLabel.text = sunText
        rainLabel.text = String(weatherModel.rain * 100) + "%"
        tempLabel.text = String(weatherModel.temperature) + "°C"
        windLabel.text = String(weatherModel.wind) + " km/h"
        
        weatherModel.storm ? (stormLabel.text = "YES") : (stormLabel.text = "NO")
    }
    
}

enum sunTextEnum :Int{
    case Cloudy = 0
    case CloudsSun = 1
    case SunClouds = 2
    case Sunny = 3
   
}
