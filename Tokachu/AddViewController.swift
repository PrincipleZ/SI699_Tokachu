//
//  AddViewController.swift
//  Tokachu
//
//  Created by Shaung Cheng on 11/10/18.
//  Copyright © 2018 Tokachu. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scrollView.keyboardDismissMode = .onDrag
        
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
