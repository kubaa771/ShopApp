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
        AppDelegate.scheduleNotification()
        self.title = NSLocalizedString("Cities", comment: "")
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTable), for: UIControl.Event.valueChanged)
        self.refreshControl = refreshControl
        Loader.start()
        fetchCityDataByAlamofire()
        tableView.tableFooterView = UIView()
    }
    
    //MARK - Fetching data
    
    func fetchCityDataByAlamofire() {
        let _ = APIManager.shared.sendRequest(url: "https://concise-test.firebaseio.com/cities.json", method: HTTPMethod.get, parameters: nil, successBlock: { (json) in
            self.cityArray.removeAll()
            for itemJson in json.arrayValue {
                let cityObject = City(json: itemJson)
                self.cityArray.append(cityObject)
            }
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
            Loader.stop()
            
        }) { (code, message) in
            self.displayAlert(errorMessage: message ?? "", tryAgainClosure: {
                self.fetchCityDataByAlamofire()
            })
            Loader.stop()
        }
    }
    
    
    @objc func refreshTable() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        fetchCityDataByAlamofire()
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
