//
//  CitiesListTableViewController.swift
//  TestWeather
//
//  Created by user on 14/01/2019.
//  Copyright © 2019 user. All rights reserved.
//
import SDWebImage
import UIKit

class CitiesListTableViewController: UITableViewController, buttonTappedDelegate {
    
    var cityArray = [City] ()
    var cellHeights: [IndexPath : CGFloat] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCityDataByJSON()
        tableView.tableFooterView = UIView()
    }
    
    func fetchCityDataByJSON() {
        let url = URL(string: "https://concise-test.firebaseio.com/cities.json")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            guard error == nil else { print("error"); return }
            guard let content = data else { print("data error"); return }
            
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: .mutableContainers)) as? [[String: Any]] else {
                print("Not containing JSON")
                return
            }
            
            for object in json {
                guard let id = object["id"] as? Int, let name = object["name"] as? String, let image = object["image"] as? String, let description = object["description"] as? String else {
                    print("error")
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
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
