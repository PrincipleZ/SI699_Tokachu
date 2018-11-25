//
//  AddViewController.swift
//  Tokachu
//
//  Created by Shaung Cheng on 11/10/18.
//  Copyright © 2018 Tokachu. All rights reserved.
//

import UIKit
import os.log

class AddViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var eventLocation: UITextField!
    @IBOutlet weak var startTime: UIDatePicker!
    @IBOutlet weak var endTime: UIDatePicker!
    @IBOutlet weak var eventDescription: UITextView!
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    var newEvent: Explore?
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self
        scrollView.keyboardDismissMode = .onDrag
        self.categoryText = Array(self.categoryData.keys)
        
    }
    let categoryData = UserDefaults.standard.object(forKey: UserDefaultsConstants.CATEGORY) as! Dictionary<String, Int>
    var categoryText = Array<String>()
    var selectedRow = 0
    @IBAction func publishEvent(_ sender: Any) {
        let category_id = self.categoryData[self.categoryText[self.selectedRow]]
        print(category_id)
        WebServiceUtils.sharedInstance.publishEvent(event_name: eventTitle.text!, start_time: startTime.date, end_time: endTime.date, place_id: eventLocation.text!, description: eventDescription.text!, category: String(category_id!), completion: {success in
            if success{
                print("Successfully published the event")
            } else{
                print("ERROR: Failed to publish the event")
            }
        })
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.categoryText.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.categoryText[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedRow = row
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("", log: OSLog.default, type: .debug)
            return
        }
        
        
        if let
            eventTitle = self.eventTitle.text,
            let eventLocation = self.eventLocation.text {
            self.newEvent = Explore(title: eventTitle, location: eventLocation, image: UIImage(named: "event-image-placeholder")!)
        }
        
        
    }


}
