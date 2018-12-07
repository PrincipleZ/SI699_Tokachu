//
//  ExploreDatasource.swift
//  Tokachu
//
//  Created by Shaung Cheng on 11/15/18.
//  Copyright © 2018 Tokachu. All rights reserved.
//

import UIKit

class ExploreDatasource: NSObject, UICollectionViewDataSource {
    
    var objects: [Explore] = [
        Explore(title: "Arborretum Wandering", location: "Law School", image: UIImage(named: "event-image-placeholder")!),
        Explore(title: "Drive in Erie", location: "Huran River", image: UIImage(named: "3")!),
        Explore(title: "Lorem ipsum dolor sit", location: "Nunc tempor dui at", image: UIImage(named: "4")!),
        Explore(title: "Vestibulum blandit augue quis", location: "Cras sodales velit nec", image: UIImage(named: "5")!),
        Explore(title: "Pellentesque rhoncus", location: "Law School", image: UIImage(named: "6")!),
        Explore(title: "Lorem ipsum dolor sit", location: "Nunc tempor dui at", image: UIImage(named: "8")!),
        Explore(title: "Vestibulum blandit augue quis", location: "Cras sodales velit nec", image: UIImage(named: "9")!),
        Explore(title: "Pellentesque rhoncus", location: "Law School", image: UIImage(named: "10")!),
        Explore(title: "Arborretum Wandering", location: "Law School", image: UIImage(named: "event-image-placeholder")!),
        Explore(title: "Drive in Erie", location: "Huran River", image: UIImage(named: "11")!),
        Explore(title: "Lorem ipsum dolor sit", location: "Nunc tempor dui at", image: UIImage(named: "12")!),
        Explore(title: "Vestibulum blandit augue quis", location: "Cras sodales velit nec", image: UIImage(named: "13")!),
        Explore(title: "Pellentesque rhoncus", location: "Law School", image: UIImage(named: "14")!),
        Explore(title: "Arborretum Wandering", location: "Law School", image: UIImage(named: "event-image-placeholder")!),
        Explore(title: "Drive in Erie", location: "Huran River", image: UIImage(named: "15")!),
        Explore(title: "Lorem ipsum dolor sit", location: "Nunc tempor dui at", image: UIImage(named: "6")!),
        Explore(title: "Vestibulum blandit augue quis", location: "Cras sodales velit nec", image: UIImage(named: "17")!),
        Explore(title: "Arborretum Wandering", location: "Law School", image: UIImage(named: "event-image-placeholder")!),
        Explore(title: "Drive in Erie", location: "Huran River", image: UIImage(named: "3")!),
        Explore(title: "Lorem ipsum dolor sit", location: "Nunc tempor dui at", image: UIImage(named: "4")!),
        Explore(title: "Vestibulum blandit augue quis", location: "Cras sodales velit nec", image: UIImage(named: "5")!),
        Explore(title: "Pellentesque rhoncus", location: "Law School", image: UIImage(named: "6")!),
        Explore(title: "Arborretum Wandering", location: "Law School", image: UIImage(named: "event-image-placeholder")!),
        Explore(title: "Drive in Erie", location: "Huran River", image: UIImage(named: "7")!),
        Explore(title: "Lorem ipsum dolor sit", location: "Nunc tempor dui at", image: UIImage(named: "8")!),
        Explore(title: "Vestibulum blandit augue quis", location: "Cras sodales velit nec", image: UIImage(named: "9")!),
        Explore(title: "Pellentesque rhoncus", location: "Law School", image: UIImage(named: "10")!),
        Explore(title: "Arborretum Wandering", location: "Law School", image: UIImage(named: "event-image-placeholder")!),
        Explore(title: "Drive in Erie", location: "Huran River", image: UIImage(named: "11")!),
        Explore(title: "Lorem ipsum dolor sit", location: "Nunc tempor dui at", image: UIImage(named: "12")!),
        Explore(title: "Vestibulum blandit augue quis", location: "Cras sodales velit nec", image: UIImage(named: "13")!),
        Explore(title: "Pellentesque rhoncus", location: "Law School", image: UIImage(named: "14")!),
        Explore(title: "Arborretum Wandering", location: "Law School", image: UIImage(named: "event-image-placeholder")!),
        Explore(title: "Drive in Erie", location: "Huran River", image: UIImage(named: "15")!),
        Explore(title: "Lorem ipsum dolor sit", location: "Nunc tempor dui at", image: UIImage(named: "4")!),
        Explore(title: "Vestibulum blandit augue quis", location: "Cras sodales velit nec", image: UIImage(named: "17")!),
        Explore(title: "Pellentesque rhoncus", location: "Law School", image: UIImage(named: "6")!),
    ]
    
    // Mark: mock data
    func fill() {
//        objects = []
//        for i in 1...10 {
//            objects.append(
//                Explore(title: "Mock Data Happy Hour \(i)", location: "Law School", image: UIImage(named: "event-image-placeholder")!)
//            )
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ExploreCell
        
        let explore = objects[indexPath.item]
        cell.fill(with: explore)
        return cell
    }
}
