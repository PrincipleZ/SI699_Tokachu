//
//  ExploerCell.swift
//  Tokachu
//
//  Created by Shaung Cheng on 11/15/18.
//  Copyright © 2018 Tokachu. All rights reserved.
//

import UIKit

class ExploreCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        
    }
    
    func fill(with explore: Explore) {
        
    }
}
