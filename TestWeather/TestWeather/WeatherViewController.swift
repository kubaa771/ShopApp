//
//  WeatherViewController.swift
//  TestWeather
//
//  Created by Jakub Iwaszek on 14/01/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

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
        var sunText :String = ""
        switch sunNumeric {
        case 0:
            sunText = "Cloudy"
        case 1:
            sunText = "Clouds & Sun"
        case 2:
            sunText = "Sun & Clouds"
        case 3:
            sunText = "Sunny"
        default:
            sunText = "Lack info"
        }
        
        sunLabel.text = sunText
        rainLabel.text = String(weatherModel.rain * 100) + "%"
        tempLabel.text = String(weatherModel.temperature) + "°C"
        windLabel.text = String(weatherModel.wind) + " km/h"
        
        weatherModel.storm ? (stormLabel.text = "YES") : (stormLabel.text = "NO")
    }
    
}
