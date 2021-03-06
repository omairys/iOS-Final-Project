//
//  ViewController.swift
//  Final Project App
//
//  Created by Omairys Uzcátegui on 2021-09-14.
//

import UIKit
import CoreData

class FirstViewController: UIViewController, UISearchBarDelegate {
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let addSegueIdentifier = "addItem"
    var searchResults = [SearchResult]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    private lazy var listViewController: ListViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var mapViewController:  MapViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    static func FirstViewController() -> FirstViewController {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstView") as! FirstViewController
    }
    
    func setupView() {
        updateView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier! {
        case addSegueIdentifier:
            let destinationVC = segue.destination as! LocationDetailsViewController
            destinationVC.managedObjectContext = managedObjectContext
        default:
                break
            }
    }
    // MARK: - Prviate Methods
    //
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        //searchResults = []
        if searchBar.text! != "A" {
            for i in 0...2 {
                let searchResult = SearchResult()
                searchResult.name = searchBar.text!
                searchResult.gender = "Male"
                searchResult.country = "Venezuela"
                searchResults.append(searchResult)
            }
        }
        listViewController.hasSearched = true
        listViewController.searchResults = searchResults
        listViewController.tableViewEmbeded.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text =  searchController.searchBar.text else {
            return
        }
        
        print (text)
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    private func updateView() {
        if segmentedControl.selectedSegmentIndex == 0 {
            remove(asChildViewController: mapViewController)
            add(asChildViewController: listViewController)
        } else {
            remove(asChildViewController: listViewController)
            add(asChildViewController: mapViewController)
        }
    }
    
    // MARK: - Actions
    @IBAction func didTapSegment(_ sender: UISegmentedControl) {
        updateView()
    }
}

