//
//  FavoriteViewController.swift
//  Tokachu
//
//  Created by Shaung Cheng on 11/10/18.
//  Copyright © 2018 Tokachu. All rights reserved.
//

import UIKit



class FavoriteViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating, eventSearchDelegate {
    
    
    
    
    
    @IBOutlet weak var eventTable: UITableView!
    
    var resultView: searchResultController!
    var searchController: UISearchController!
    var categories: [String] = []
    var start_time: Date = Date()
    var end_time: Date = Date(timeIntervalSinceNow: 10800)
    var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupSearchControl()
    }
    
    func setupSearchControl() {
        resultView = searchResultController()
        searchController = UISearchController(searchResultsController: resultView)
        resultView.tableView.delegate = self
        resultView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        resultView.delegate = self
        
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.autocapitalizationType = .none
        
        self.definesPresentationContext = true
        if #available(iOS 11.0, *) {
            // For iOS 11 and later, place the search bar in the navigation bar.
            navigationItem.searchController = searchController
            
            // Make the search bar always visible.
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // For iOS 10 and earlier, place the search controller's search bar in the table view's header.
            self.eventTable.tableHeaderView = searchController.searchBar
        }
    }
    func performSearch() {
        WebServiceUtils.sharedInstance.searchEvent(searchTerm: self.searchText, category: self.categories, start_time: self.start_time, end_time: self.end_time, completion: {(a, b) in
            print(b) })
        // TODO: Display search result
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        searchController.searchResultsController?.view.isHidden = false

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        performSearch()
    }
    
    func updateFilter(categories: [String], start_time: Date, end_time: Date) {
        self.categories = categories
        self.start_time = start_time
        self.end_time = end_time
        performSearch()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
