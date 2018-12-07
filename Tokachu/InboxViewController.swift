//
//  InboxViewController.swift
//  Tokachu
//
//  Created by Yuanze Zhang on 12/5/18.
//  Copyright © 2018 Tokachu. All rights reserved.
//

import UIKit

class InboxViewController: UITableViewController {
    
    var channelList = [String]()
    var selectedIndex = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidload")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("viewwillAppear")
        refreshChannelList()
    }
    
    func refreshChannelList() {
        WebServiceUtils.sharedInstance.getChannels(completion: {(a, b) in
            if a {
                self.channelList = b
                print("here")
                print(self.channelList)
                self.tableView.reloadData()
            }
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.channelList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath)
        cell.textLabel?.text = "Channel " + String(indexPath.row)
        return cell
    }
    

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedIndex = indexPath.row
        return indexPath
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        print(selectedIndex)
        if segue.identifier == "showDetail" {
            guard let chatView = segue.destination as? ChatViewController else {
               fatalError("ah")
            }

            chatView.channel = self.channelList[selectedIndex]
        }
    }
}
