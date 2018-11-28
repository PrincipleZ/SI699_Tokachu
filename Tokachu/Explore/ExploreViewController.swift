//
//  ExploreViewController.swift
//  Tokachu
//
//  Created by Shaung Cheng on 11/10/18.
//  Copyright © 2018 Tokachu. All rights reserved.
//

import Foundation
import UIKit
import os.log

class ExploreViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating, eventSearchDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var resultView: searchResultController!
    var searchController: UISearchController!
    var categories: [String] = []
    var start_time: Date = Date()
    var end_time: Date = Date(timeIntervalSinceNow: 10800)
    var searchText = ""
    
    var datasource: ExploreDatasource = ExploreDatasource()
    let presenter: ExplorePresenter = ExplorePresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Explore"
        
        setup()
        
        datasource.fill()
        collectionView.reloadData()
        
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
            
        }
    }
    
    func setup() {
        collectionView.dataSource = datasource
        collectionView.delegate = presenter as UICollectionViewDelegate
    }
    
    //MARK: Actions
    @IBAction func unwindToExploreList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddViewController,
            let incomingExplore = sourceViewController.explore {
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first  {
                self.datasource.objects[selectedIndexPath.row] = incomingExplore
                self.collectionView.reloadItems(at: [selectedIndexPath])
                
            }
            else {
                self.collectionView.performBatchUpdates({
                    let newExploreIndexPath = IndexPath(row: self.datasource.objects.count, section: 0)
                    self.datasource.objects.append(incomingExplore)
                    collectionView.insertItems(at: [newExploreIndexPath])
                }, completion: nil)
            }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.identifier  ?? "" {
        case "AddExplore":
            os_log("Adding new explore event", log: OSLog.default, type: .debug)
        case "ShowExploreDetail":
            guard let exploreDetailViewController = segue.destination as? AddViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedExploreCell = sender as? ExploreCell  else {
                fatalError("Unexpected sender: \(sender ?? "")")
            }
            
            guard let indexPath = collectionView.indexPath(for: selectedExploreCell) else {
                fatalError("The selected cell is not being displayed by the collectionView")
            }
            
            let selectedExplore = self.datasource.objects[indexPath.row]
            exploreDetailViewController.explore = selectedExplore
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "empty segue identifier")")
        }
    }
}
