//
//  ChatViewController.swift
//  Tokachu
//
//  Created by Yuanze Zhang on 12/3/18.
//  Copyright © 2018 Tokachu. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITextFieldDelegate, PNDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textBottomCon: NSLayoutConstraint!
    @IBOutlet weak var scrollBottomCon: NSLayoutConstraint!
    
    @IBOutlet weak var textInput: UITextField!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var currentHeight = 0.0
    var keyboardUp = false
    var channel: String = "s0aq9844dnzxyzvmd8sjr47jmnrjdugvr6t5oksldsppls7f8rr4ggrrkflis4fs"
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.showsVerticalScrollIndicator = true
        print(scrollView.frame.height)
        scrollView.contentSize = CGSize(width: self.view.bounds.width, height: 0)
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        appDelegate.delegate = self
        textInput.delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
    
    func sendMessage(){
        self.presentContent(text: textInput.text!, sended: true)
        appDelegate.publishToPubNub(message: textInput.text!, channel: channel)
    }
    
    
    func receivedMessage(message: String, fromChannel: String) {
        if fromChannel == self.channel {
            self.presentContent(text: message, sended: false)
        }
    }
    @objc func keyboardWillShow(notification: NSNotification) {
//        scrollToBottom()
        print("show")
        if !self.keyboardUp{
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                moveUpTextfield(offset: Double(keyboardSize.height))
            }
        }
        self.keyboardUp = true

    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.keyboardUp{
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                moveUpTextfield(offset: -Double(keyboardSize.height))

            }
        }
        self.keyboardUp = false
    }
    
    func moveUpTextfield(offset: Double){
        if offset > 0{
            textBottomCon.constant = CGFloat(-offset)
        } else {
            textBottomCon.constant = 0
        }
        
//        self.textInput.frame = CGRect(x: 0, y: Double(self.textInput.frame.midY) - offset, width: Double(self.textInput.frame.width), height: Double(self.textInput.frame.height))
        print(textBottomCon.description)
        print(scrollBottomCon.description)
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//
//        moveUpTextfield(offset: self.keyboardHeight)
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        moveUpTextfield(offset: self.keyboardHeight)
//    }
    func scrollToBottom() {
        if scrollView.contentSize.height > scrollView.bounds.size.height{
            let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height)
            scrollView.setContentOffset(bottomOffset, animated: true)
        }
    }
    func presentContent(text: String, sended: Bool) {
        var xPosition: Double
        if sended {
            xPosition = Double(self.view.bounds.width) * 0.55
        } else {
            xPosition = Double(self.view.bounds.width) * 0.05
        }
        var label = UILabel(frame: CGRect(x: xPosition, y: currentHeight, width: Double(self.view.bounds.width) * 0.4, height: 20))
        label.text = text
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        
        
        scrollView.addSubview(label)
        currentHeight += Double(label.frame.height) + 20
        if currentHeight > Double(scrollView.contentSize.height) {
            scrollView.contentSize.height = CGFloat(currentHeight) + 10
            scrollToBottom()
        }
        
    }
}
