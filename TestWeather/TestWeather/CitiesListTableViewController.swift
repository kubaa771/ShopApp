//
//  CitiesListTableViewController.swift
//  TestWeather
//
//  Created by user on 14/01/2019.
//  Copyright © 2019 user. All rights reserved.
//
import SDWebImage
import UIKit
import NVActivityIndicatorView
import UserNotifications
import Alamofire

class CitiesListTableViewController: UITableViewController, buttonTappedDelegate {
    
    var cityArray = [City] ()
    var cellHeights: [IndexPath : CGFloat] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(checkUrl), name: NotificationNames.deepLinkHandler.notification, object: nil)
        AppDelegate.scheduleNotification()
        self.title = NSLocalizedString("Cities", comment: "")
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTable), for: UIControl.Event.valueChanged)
        self.refreshControl = refreshControl
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkUrl()
    }
    
    //MARK - Checking URLS
    
    @objc func checkUrl() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let url = appDelegate.deepLinkUrl {
            fetchCityDataByAlamofire {  [weak self] (error) in
                self?.deepLinkUrlHandler(url: url)
                appDelegate.deepLinkUrl = nil
            }

        } else
        if cityArray.isEmpty {
            Loader.start()
            fetchCityDataByAlamofire { (Error) in
            }
        }
    }
    
    func configureViewController(id: Int) {
        if cityArray.contains(where: { ($0.id == id) }) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let weatherViewController: WeatherViewController = storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
            weatherViewController.idUrl = id
            let result = cityArray.compactMap {
                $0.id == id ? $0.name : nil
            }
            weatherViewController.currentCityTitle = result[0]
            self.navigationController?.popToRootViewController(animated: false)
            self.show(weatherViewController, sender: nil)
            
        }
        
    }

    
    func deepLinkUrlHandler(url: String) {
        if let cityId = Helper.getQueryStringParameter(url: url, param: "id"),
            let cityIdInt = Int(cityId) {
            configureViewController(id: cityIdInt)
        }
        
    }
    
    //MARK - Fetching data by Alamofire
    
    func fetchCityDataByAlamofire(completion: @escaping ((_ error: Error?) -> Void)) {
        let _ = APIManager.shared.sendRequest(url: "https://concise-test.firebaseio.com/cities.json", method: HTTPMethod.get, parameters: nil, successBlock: { (json) in
            self.cityArray.removeAll()
            for itemJson in json.arrayValue {
                let cityObject = City(json: itemJson)
                self.cityArray.append(cityObject)
            }
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
            Loader.stop()
          
            completion(nil)
            
            
        }) { (code, message) in
            self.displayAlert(errorMessage: message ?? "", tryAgainClosure: {
                self.fetchCityDataByAlamofire(completion: completion)
            })
            Loader.stop()
            
            completion(nil)
        }
    }
    
    @objc func refreshTable() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        fetchCityDataByAlamofire { (error) in
        
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! CityTableViewCell
        
        cell.model = cityArray[indexPath.row]
        cell.delegate = self
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.cellHeights[indexPath] = cell.frame.size.height
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? UITableView.automaticDimension
    }
    
    
    //MARK: - Segue
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "pushSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushSegue"{
            let seg = segue.destination as! WeatherViewController
            let city = cityArray[(tableView.indexPathForSelectedRow?.row)!]
            seg.idUrl = city.id
            seg.currentCityTitle = city.name
        }
    }
    
    //MARK: - Protocol Use
    
    func btnCloseTapped(cell: CityTableViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        
        cityArray[indexPath!.row].isExpanded = !cityArray[indexPath!.row].isExpanded
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath!], with: .automatic)
        tableView.endUpdates()
    }
    
}
