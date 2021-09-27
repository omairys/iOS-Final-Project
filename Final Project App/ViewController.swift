//
//  ViewController.swift
//  Final Project App
//
//  Created by Omairys Uzcátegui on 2021-09-14.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let addSegueIdentifier = "addItem"
    @IBOutlet weak var tableViewEmbeded: UIView!
    @IBOutlet weak var mapViewEmbeded: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier! {
        case addSegueIdentifier:
            guard let navController = segue.destination as? UINavigationController,
            let addVC = navController.topViewController as? LocationDetailsViewController else {
                return
            }
            addVC.managedObjectContext = managedObjectContext
        default:
                break
            }
    }
    
    // MARK: - Actions
    @IBAction func switchSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            tableViewEmbeded.alpha = 1
            mapViewEmbeded.alpha = 0
        }else{
            tableViewEmbeded.alpha = 0
            mapViewEmbeded.alpha = 1
        }
    }
    
}

