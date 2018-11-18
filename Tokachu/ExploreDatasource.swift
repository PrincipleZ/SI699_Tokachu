//
//  ExploreDatasource.swift
//  Tokachu
//
//  Created by Shaung Cheng on 11/15/18.
//  Copyright © 2018 Tokachu. All rights reserved.
//

import UIKit

class ExploreDatasource: NSObject, UICollectionViewDataSource {
    
    var objects: [Explore] = []
    
    // Mark: mock data
    func fill() {
//        objects = [Explore(title: "Happy Hour", location: "North Quad", image: UIImage(name: ""))]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ExploreCell
        return cell
    }

}
