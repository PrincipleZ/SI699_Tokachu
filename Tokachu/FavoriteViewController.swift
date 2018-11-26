//
//  FavoriteViewController.swift
//  Tokachu
//
//  Created by Shaung Cheng on 11/10/18.
//  Copyright © 2018 Tokachu. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController)
    }
    
    
    @IBOutlet weak var eventTable: UITableView!
    
    var resultView: searchResultController!
    var searchController: UISearchController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        resultView = searchResultController()
        searchController = UISearchController(searchResultsController: resultView)
        resultView.tableView.delegate = self
        resultView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
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
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
