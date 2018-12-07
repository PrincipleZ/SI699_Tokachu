//
//  searchResultController.swift
//  Tokachu
//
//  Created by Yuanze Zhang on 11/24/18.
//  Copyright © 2018 Tokachu. All rights reserved.
//

import UIKit

protocol eventSearchDelegate {
    
    func updateFilter(categories: [String], start_time: Date, end_time: Date)
}

class searchResultController: UITableViewController {
    var start_time = Date()
    var end_time = Date(timeIntervalSinceNow: 10800)
    let dateFormatter = DateFormatter()
    var senderTag = 0
    var start_time_button = UIButton()
    var end_time_button = UIButton()
    var timePicker: UIDatePicker?
    var currentCategory: [String] = []
    var delegate: eventSearchDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
        self.dateFormatter.timeZone = TimeZone(identifier: String (TimeZone.current.identifier))
        hideDatePicker()
        self.delegate?.updateFilter(categories: currentCategory, start_time: start_time, end_time: end_time)

    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        if indexPath.row == 0 {
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
            self.start_time_button.tag = 50
            
            self.end_time_button = UIButton(frame: CGRect(x: end_x, y: rowHeight - 5.0, width: rowWidth * 0.48, height: 10))
            self.end_time_button.setTitle(dateFormatter.string(from: end_time), for: .normal)
            self.end_time_button.setTitleColor(UIColor.blue, for: .normal)
            self.end_time_button.addTarget(self, action: #selector(time_picker), for: .touchUpInside)
            self.end_time_button.tag = 51
            
            cell.addSubview(self.start_time_button)
            cell.addSubview(self.end_time_button)
            cell.textLabel?.text = "to"
            cell.textLabel?.textAlignment = .center
        } else if indexPath.row == 1{
            cell.selectionStyle = .none
            self.generateCategoryPickers(forCell: cell)
        } else {
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
        if (self.senderTag == 50) {
            self.start_time = sender.date
            self.start_time_button.setTitle(dateFormatter.string(from: start_time), for: .normal)
        } else {
            self.end_time = sender.date
            self.end_time_button.setTitle(dateFormatter.string(from: end_time), for: .normal)
        }
        self.delegate?.updateFilter(categories: self.currentCategory, start_time: start_time, end_time: end_time)
    }
    
    func generateCategoryPickers(forCell cell: UITableViewCell){
        let rowWidth = Double(cell.frame.width)
        
        let margin = 20.0
        var currentX = 20.0
        for (name, id) in UserDefaults.standard.dictionary(forKey: UserDefaultsConstants.CATEGORY)!{
            let textWidth = Double(name.size(withAttributes: nil).width)
            
            if currentX + textWidth + margin > rowWidth {
                // To next line
            }
            let rowHeight = Double(cell.frame.maxY)
            let cateButton = UIButton()
            cateButton.layer.cornerRadius = 10
            cateButton.layer.borderWidth = 1
            cateButton.layer.borderColor = UIColor.blue.cgColor
            cateButton.tag = id as! Int
            cateButton.setTitle(name, for: .normal)
            cateButton.setTitleColor(UIColor.blue, for: .normal)
            cateButton.setTitleColor(UIColor.white, for: .selected)

            cateButton.sizeToFit()
            cateButton.addTarget(self, action: #selector(selectCategory(sender:)), for: .touchUpInside)
            cateButton.frame.size = CGSize(width: cateButton.frame.width + 5, height: cateButton.frame.height)
            
            cateButton.frame.origin = CGPoint(x: currentX, y: (rowHeight - Double(cateButton.frame.height)) * 0.5)
            cell.addSubview(cateButton)
            currentX += margin + Double(cateButton.frame.width)
        }
    }
    
    @objc func selectCategory(sender:UIButton){
        let senderTag = sender.tag
        if let senderButton = self.view.viewWithTag(senderTag) as? UIButton {
            switch senderButton.state {
            case .highlighted:
                senderButton.isSelected = true
                senderButton.backgroundColor = UIColor.blue
                self.currentCategory.append(String(senderButton.tag))
                break
            case UIControl.State(rawValue: 5):
                print("here")
                senderButton.isSelected = false
                senderButton.backgroundColor = UIColor.white
                self.currentCategory.remove(at: self.currentCategory.firstIndex(of: String(senderButton.tag))!)
                break
            default:

                break
            }
            print(self.currentCategory)
            self.delegate?.updateFilter(categories: self.currentCategory, start_time: start_time, end_time: end_time)
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
