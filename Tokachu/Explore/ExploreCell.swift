//
//  ExploerCell.swift
//  Tokachu
//
//  Created by Shaung Cheng on 11/15/18.
//  Copyright © 2018 Tokachu. All rights reserved.
//

import UIKit

class ExploreCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var pan: UIPanGestureRecognizer!
    var deleteLabel1: UILabel!
    var deleteLabel2: UILabel!
    
    //MARK: initialize data
    func fill(with explore: Explore) {
        titleLabel.text = explore.title
        locationLabel.text = explore.location
        imageView.image = explore.image
    }
    
    //MARK: swipe gesture setup
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        commonInit()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        commonInit()
//    }
//    
//    private func commonInit() {
//        self.contentView.backgroundColor = UIColor.white
//        self.backgroundColor = UIColor.red
//        
//        deleteLabel1 = UILabel()
//        deleteLabel1.text = "delete1"
//        deleteLabel1.textColor = UIColor.white
//        self.insertSubview(deleteLabel1, belowSubview: self.contentView)
//        
//        deleteLabel2 = UILabel()
//        deleteLabel2.text = "delete2"
//        deleteLabel2.textColor = UIColor.white
//        self.insertSubview(deleteLabel2, belowSubview: self.contentView)
//        
//        pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
//        pan.delegate = self
//        self.addGestureRecognizer(pan)
//    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        if (pan.state == UIGestureRecognizer.State.changed) {
//            let p: CGPoint = pan.translation(in: self)
//            let width = self.contentView.frame.width
//            let height = self.contentView.frame.height
//            self.contentView.frame = CGRect(x: p.x,y: 0, width: width, height: height);
//            self.deleteLabel1.frame = CGRect(x: p.x - deleteLabel1.frame.size.width-10, y: 0, width: 100, height: height)
//            self.deleteLabel2.frame = CGRect(x: p.x + width + deleteLabel2.frame.size.width, y: 0, width: 100, height: height)
//        }
//        
//    }
    
    @objc func onPan(_ pan: UIPanGestureRecognizer) {
        if pan.state == UIGestureRecognizer.State.began {
            
        } else if pan.state == UIGestureRecognizer.State.changed {
            self.setNeedsLayout()
        } else {
            if abs(pan.velocity(in: self).x) > 500 {
                let collectionView: UICollectionView = self.superview as! UICollectionView
                let indexPath: IndexPath = collectionView.indexPathForItem(at: self.center)!
                collectionView.delegate?.collectionView!(collectionView, performAction: #selector(onPan(_:)), forItemAt: indexPath, withSender: nil)
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                })
            }
        }
    }
    
    // MARK: tap to segue to edit explore page (same as addViewController)
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        
    }
}
