//
//  countryPickerViewController.swift
//  Final Project App
//
//  Created by Omairys Uzcátegui on 2021-09-23.
//


import UIKit

class CountryPickerViewController: UITableViewController {
    var selectedCountry = ""
    
    let country = [
        "No Selected",
        "Canada",
        "Venezuela",
        "Chile",
        "Mexico",
        "Colombia",
        "España",
        "Argentina"
    ]
    var selectedIndexPath = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0..<country.count {
            if country[i] == selectedCountry {
                selectedIndexPath = IndexPath(row: i, section: 2)
                break
            }
        }
    }
    
    // MARK:- Table View Delegates
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return country.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell( withIdentifier: "CountryCell",
            for: indexPath)
        let countryName = country[indexPath.row]
        cell.textLabel!.text = countryName
        
        if countryName == selectedCountry {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != selectedIndexPath.row {
            if let newCell = tableView.cellForRow(at: indexPath) {
                newCell.accessoryType = .checkmark
            }
            if let oldCell = tableView.cellForRow( at: selectedIndexPath) {
                oldCell.accessoryType = .none
            }
            selectedIndexPath = indexPath
        }
    }
    
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?) {
        if segue.identifier == "PickCountry" {
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: cell) {
                selectedCountry = country[indexPath.row]
            }
        }
        
    }
    
    
    
}
