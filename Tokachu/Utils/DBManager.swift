//
//  DBManager.swift
//  Tokachu
//
//  Created by Yuanze Zhang on 6/20/18.
//  Copyright © 2018 Tokachu. All rights reserved.
//

import CoreData
import UIKit

class DBManager {
    var appDelegate: AppDelegate?
    
    let managedContext: NSManagedObjectContext
    let entity: NSEntityDescription
    let entityName = "RoadCondition"
    let LOG_TAG = "[DBManager]"
    
    static let sharedInstance = DBManager()

    private init() {
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = self.appDelegate!.persistentContainer.viewContext
        self.entity = NSEntityDescription.entity(forEntityName: self.entityName, in: self.managedContext)!
        self.managedContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
    }
    
    /**
     Get context of managed object (different getting method for iOS 9 and iOS 10+)
     From Rovano
     - Returns NSManagedObjectContext
     */
    func getContext() -> NSManagedObjectContext {
        return self.appDelegate!.persistentContainer.viewContext
    }
    
    /**
     Insert single condition object into local database
     - parameter condition: Single condition object
    */
    func insertDataFromObject(condition: Condition) {
        let newCondition = NSManagedObject(entity: self.entity, insertInto: self.managedContext)
        newCondition.setValuesForKeys(condition.toDBDict())
        do {
            try self.managedContext.save()
        } catch let error as NSError {
            print(self.LOG_TAG + "Could not save. \(error), \(error.userInfo)")
        }
    }
    
    /**
        Get all condition data from database
        - returns: a list containing condition objects
     */
    func getObjectFromDB() -> [Condition] {
        var conditionList = [Condition]()
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            let result = try self.managedContext.fetch(fetch)
            for item in result as! [RoadCondition] {
                let newCondition = Condition(conditionType: Int(item.condition_type_id), location: (item.loc_lat, item.loc_log), heading: item.direction, username: item.username!, timestamp: item.entry_time!, lastReportTime: item.last_report_time!, speed: item.speed, accuracy: item.accuracy, hasPublished: true, id: Int(item.condition_id))
                conditionList.append(newCondition)
            }
        } catch let error as NSError {
            print(self.LOG_TAG + "Fetch error. \(error), \(error.userInfo)")
        }
        return conditionList
    }
    
    

}
