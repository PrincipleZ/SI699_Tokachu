//
//  ExploreViewController.swift
//  Tokachu
//
//  Created by Shaung Cheng on 11/10/18.
//  Copyright © 2018 Tokachu. All rights reserved.
//

import Foundation
import UIKit

class ExploreViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var datasource: ExploreDatasource = ExploreDatasource()
    let presenter: ExplorePresenter = ExplorePresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Explore Events"
        
        setup()
        
        datasource.fill()
        collectionView.reloadData()
    }
    
    func setup() {
        collectionView.dataSource = datasource
        collectionView.delegate = presenter as UICollectionViewDelegate
    }
}
