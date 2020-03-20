//
//  GroupsViewController.swift
//  Locations Client
//
//  Created by rb on 6/20/19.
//  Copyright © 2019 premBhanderi. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class GroupsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var groups = [String]()
    var locations = [(name: String, groupName: String)]()
    var diagramArray = [[String: AnyObject]]()
    var currentGroup = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        APIClient.getLocations { [weak self] (locations) in
            self?.locations = locations
            self?.addGroups()
            self?.createDiagramArray()
            self?.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let locations = diagramArray[section]["locations"] as? [(name: String, groupName: String)] {
            print(locations.count)
            return locations.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        if let locations = diagramArray[indexPath.section]["locations"] as? [(name: String, groupName: String)] {
            cell.textLabel?.text = locations[indexPath.row].name
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return groups[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Set selected location to var
//        selectedLocation = feedItems[indexPath.row] as! LocationModel
        // Manually call segue to detail view controller
        self.performSegue(withIdentifier: "detailSegue", sender: self)
        
    }
    
    
    @IBAction func btnAddGroup(_ sender: UIButton) {
        print("test")
        
        let alert = UIAlertController(title: "Create group", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input group name here"
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            if let name = alert.textFields?.first?.text {
                APIClient.addGroup(groupName: name)
            }
        }))
        
        self.present(alert, animated: true)
        
        self.tableView.reloadData()
    }
    
    @IBAction func btnAddLocation(_ sender: UIButton) {
        print("test")
        
        let alert = UIAlertController(title: "Create location", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input location name here"
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            if let name = alert.textFields?.first?.text {
                APIClient.addLocation(locationName: name)
            }
        }))
        
        self.present(alert, animated: true)
        
        self.tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get reference to the destination view controller
        let detailVC  = segue.destination as! DetailViewController
        // Set the property to the selected location so when the view for
        // detail view controller loads, it can access that property to get the feeditem obj
//        detailVC.selectedLocation = selectedLocation
//        let index = tableView.indexPathForSelectedRow?.row
    }
    
    func addGroups() {
        for location in locations {
            if !groups.contains(location.groupName) {
                groups.append(location.groupName)
            }
        }
    }
    
    func createDiagramArray() {
        for group in groups {
            var groupLocations = [(name: String, groupName: String)]()
            for location in locations {
                if location.groupName == group {
                    groupLocations.append(location)
                }
            }
            diagramArray.append(["group": group as AnyObject, "locations": groupLocations as AnyObject])
        }
    }
}
