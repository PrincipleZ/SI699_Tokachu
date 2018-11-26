//
//  searchResultController.swift
//  Tokachu
//
//  Created by Yuanze Zhang on 11/24/18.
//  Copyright © 2018 Tokachu. All rights reserved.
//

import UIKit

class searchResultController: UITableViewController {
    var start_time = Date()
    var end_time = Date(timeIntervalSinceNow: 10800)
    let dateFormatter = DateFormatter()
    var senderTag = 0
    var start_time_button = UIButton()
    var end_time_button = UIButton()
    var timePicker: UIDatePicker?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
        self.dateFormatter.timeZone = TimeZone(identifier: String (TimeZone.current.identifier))
        hideDatePicker()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
            cell.selectionStyle = .none
            let margin = 0.1
            let textWidth = Double("to".size(withAttributes: nil).width)
            let rowWidth = Double(cell.frame.width)
            let rowHeight = Double(cell.frame.midY)
            let start_x = rowWidth * margin
            let end_x = rowWidth*(0.5+margin) + 4*Double(textWidth)
            
            self.start_time_button = UIButton(frame: CGRect(x: start_x , y: rowHeight - 5.0, width: rowWidth * 0.48, height: 10.0))
            self.start_time_button.setTitle(dateFormatter.string(from: start_time), for: .normal)
            self.start_time_button.setTitleColor(UIColor.blue, for: .normal)
            self.start_time_button.addTarget(self, action: #selector(time_picker), for: .touchUpInside)
            self.start_time_button.tag = 1
            
            self.end_time_button = UIButton(frame: CGRect(x: end_x, y: rowHeight - 5.0, width: rowWidth * 0.48, height: 10))
            self.end_time_button.setTitle(dateFormatter.string(from: end_time), for: .normal)
            self.end_time_button.setTitleColor(UIColor.blue, for: .normal)
            self.end_time_button.addTarget(self, action: #selector(time_picker), for: .touchUpInside)
            self.end_time_button.tag = 2
            
            cell.addSubview(self.start_time_button)
            cell.addSubview(self.end_time_button)
            cell.textLabel?.text = "to"
            cell.textLabel?.textAlignment = .center
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        }
        return cell
    }
    
    
    @objc func time_picker(sender: UIButton!) {
        self.senderTag = sender.tag
        if (self.timePicker == nil){
            self.timePicker = UIDatePicker()
            self.timePicker!.datePickerMode = UIDatePicker.Mode.dateAndTime
            let pickerSize = self.timePicker!.sizeThatFits(CGSize(width: self.view!.frame.width, height: self.view!.frame.height))
            
            self.timePicker!.addTarget(self, action: #selector(changeTime(sender:)), for: UIControl.Event.valueChanged)
            self.timePicker!.date = dateFormatter.date(from: sender.currentTitle!)!
            self.timePicker!.frame = CGRect(x:0 , y:self.view!.frame.height - pickerSize.height - self.view!.safeAreaInsets.top - self.view!.safeAreaInsets.bottom, width:self.view!.frame.width, height:pickerSize.height)
            self.timePicker?.minimumDate = start_time
            self.timePicker!.backgroundColor = UIColor.white
            self.timePicker!.tag = 100
            self.view.addSubview(self.timePicker!)
            
        }
    }
    

    @objc func changeTime(sender:UIDatePicker){
        if (self.senderTag == 1) {
            self.start_time = sender.date
            self.start_time_button.setTitle(dateFormatter.string(from: start_time), for: .normal)
        } else {
            self.end_time = sender.date
            self.end_time_button.setTitle(dateFormatter.string(from: end_time), for: .normal)
        }
        
    }
    
    func hideDatePicker(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hidePicker(sender:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func hidePicker(sender:UIDatePicker){
        if (self.timePicker != nil){
            if let viewWithTag = self.view.viewWithTag(100) {
                viewWithTag.removeFromSuperview()
            }
            self.timePicker = nil
        }
    }
}
