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

class CitiesListTableViewController: UITableViewController, buttonTappedDelegate {
    
    var cityArray = [City] ()
    var cellHeights: [IndexPath : CGFloat] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Cities", comment: "")
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTable), for: UIControl.Event.valueChanged)
        self.refreshControl = refreshControl
        Loader.start()
        fetchCityDataByJSON()
        tableView.tableFooterView = UIView()
    }
    
    //MARK - Fetching data
    
    func fetchCityDataByJSON() {
        let url = URL(string: "https://concise-test.firebaseio.com/cities.json")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            Loader.stop()
            guard error == nil else {
                self.displayAlert(errorMessage: error!.localizedDescription, tryAgainClosure: {
                    self.fetchCityDataByJSON()
                })
                return
            }
            guard let content = data else {
                self.displayAlert(errorMessage: "Error while updating content", tryAgainClosure: {
                    self.fetchCityDataByJSON()
                })
                return
            }
            
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: .mutableContainers)) as? [[String: Any]] else {
                self.displayAlert(errorMessage: "Error while fetching data", tryAgainClosure: {
                    self.fetchCityDataByJSON()
                })
                return
            }
            
            self.cityArray.removeAll()
            for object in json {
                guard let id = object["id"] as? Int, let name = object["name"] as? String, let image = object["image"] as? String, let description = object["description"] as? String else {
                    self.displayAlert(errorMessage: "Error, missing data", tryAgainClosure: {
                        self.fetchCityDataByJSON()
                    })
                    return
                }

                self.cityArray.append(City(name: name, id: id, image: image, description: description, isExpanded: false))
                
            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    @objc func refreshTable() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        fetchCityDataByJSON()
        refreshControl?.endRefreshing()
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
