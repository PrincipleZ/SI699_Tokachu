//
//  AppDelegate.swift
//  Tokachu
//
//  Created by Yuanze Zhang on 11/6/18.
//  Copyright © 2018 Tokachu. All rights reserved.
//

import UIKit
import PubNub
import SwiftyJSON

protocol PNDelegate {
    func receivedMessage(message: String, fromChannel: String)
}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PNObjectEventListener {

    var window: UIWindow?
    var client: PubNub!
    var delegate: PNDelegate?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        WebServiceUtils.sharedInstance.getCategories()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
        self.setupPubNub()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func setupPubNub() {
        let configuration = PNConfiguration(publishKey: WSConstants.PubNub.PUBLISH_KEY, subscribeKey: WSConstants.PubNub.SUBSCRIBE_KEY)
        configuration.stripMobilePayload = false
        self.client = PubNub.clientWithConfiguration(configuration)
        self.client.addListener(self)
//        self.client.subscribeToChannels(["test"], withPresence: false)
    }
    // Handle new message from one of channels on which client has been subscribed.
    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
        // Handle new message stored in message.data.message
        print()
        print(message.data.publisher)
        if let data = message.data.message {
            let temp = data as! NSDictionary
            let textMessage = temp["message"] as! String
            let sender = temp["sender"] as! String
            if sender == UserDefaults.standard.string(forKey: UserDefaultsConstants.USER_ID){
                // sended by self
            } else {
                self.delegate?.receivedMessage(message: textMessage, fromChannel: message.data.channel)
            }
        }
        if message.data.channel != message.data.subscription {
            // Message has been received on channel group stored in message.data.subscription.
        }
        else {
            // Message has been received on channel stored in message.data.channel.
        }
        
        
        
    }
    
    // Handle subscription status change.
    func client(_ client: PubNub, didReceive status: PNStatus) {
        if status.operation == .subscribeOperation {
            // Check whether received information about successful subscription or restore.
            if status.category == .PNConnectedCategory || status.category == .PNReconnectedCategory {
                let subscribeStatus: PNSubscribeStatus = status as! PNSubscribeStatus
                if subscribeStatus.category == .PNConnectedCategory {
                    // This is expected for a subscribe, this means there is no error or issue whatsoever.
                    
                    // Select last object from list of channels and send message to it.
                    let targetChannel = client.channels().last!
                    
                }
                else {
                    /**
                     This usually occurs if subscribe temporarily fails but reconnects. This means there was
                     an error but there is no longer any issue.
                     */
                }
            }
            else if status.category == .PNUnexpectedDisconnectCategory {
                /**
                 This is usually an issue with the internet connection, this is an error, handle
                 appropriately retry will be called automatically.
                 */
            }
                // Looks like some kind of issues happened while client tried to subscribe or disconnected from
                // network.
            else {
                let errorStatus: PNErrorStatus = status as! PNErrorStatus
                if errorStatus.category == .PNAccessDeniedCategory {
                    /**
                     This means that PAM does allow this client to subscribe to this channel and channel group
                     configuration. This is another explicit error.
                     */
                } else {
                    /**
                     More errors can be directly specified by creating explicit cases for other error categories
                     of `PNStatusCategory` such as: `PNDecryptionErrorCategory`,
                     `PNMalformedFilterExpressionCategory`, `PNMalformedResponseCategory`, `PNTimeoutCategory`
                     or `PNNetworkIssuesCategory`
                     */
                }
            }
        }
    }
    
    func publishToPubNub(message: String, channel: String) {
        let json = JSON(["message": message, "sender": UserDefaults.standard.string(forKey: UserDefaultsConstants.USER_ID)]).object
        self.client.publish(json, toChannel: channel,
                            compressed: false, withCompletion: { status in
                                
                                if !status.isError {
                                    // Message successfully published to specified channel.
                                }
                                else {
                                    /**
                                     Handle message publish error. Check 'category' property to find
                                     out possible reason because of which request did fail.
                                     Review 'errorData' property (which has PNErrorData data type) of status
                                     object to get additional information about issue.
                                     
                                     Request can be resent using: status.retry()
                                     */
                            
                                }
        })
    }
}

