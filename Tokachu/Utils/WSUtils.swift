//
//  WSUtils.swift
//  Tokachu
//
//  Created by Yuanze Zhang on 6/20/18.
//  Copyright © 2018 Tokachu. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON
import CoreData


class WebServiceUtils {
    
    let LOG_TAG = "[WebServiceUtils]"
    let dateFormatter = DateFormatter()
    
    // First bool is the connection state while the second bool indicates if request has been accepted and executed
    typealias responseReceived = ((Bool, Bool)) -> ()
    static let sharedInstance = WebServiceUtils()
    
    private init (){
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.dateFormatter.timeZone = TimeZone(identifier: "UTC")
    }
    
    func logIn(username: String, password: String, completion: @escaping responseReceived){
        
    }
    
    /**
     Handles registration process. Non-empty username should be chekced prior to passing into this function. First bool in completion indicates whether connection was successful and second bool yield to false if the username already exists
     */
    func userRegistration(username: String, uuid: String, completion: @escaping responseReceived) {
        let params = [WSConstants.Params.USERNAME: username, WSConstants.Params.UUID: uuid]
        Alamofire.request(WSConstants.URL.ADD_USER, method: .post, parameters: params, encoding: URLEncoding.default).validate(statusCode: 200..<300).responseJSON { response in
            var connectionSuccess = false
            var registrationSuccess = false
            switch response.result {
            case .success:
                if let data = response.result.value {
                    let dictData = data as! Dictionary<String, String>
                    let status = dictData[WSConstants.JSON.status]
                    if status == WSConstants.Status.success {
                        connectionSuccess = true
                        if dictData[WSConstants.JSON.data]! != "None" {
                            let jsonData = JSON(parseJSON: dictData[WSConstants.JSON.data]!)
                            if let user_id = Int(jsonData[WSConstants.Params.USER_ID].string!) {
                                // Registration succeeded
                                UserDefaults.standard.set(user_id, forKey: UserDefaultConstants.USER_ID)
                                UserDefaults.standard.set(username, forKey: UserDefaultConstants.USER_NAME)
                                registrationSuccess = true
                            }
                        }
                    }
                }
            case .failure(let error):
                print(self.LOG_TAG)
                print(error)
            }
            completion((connectionSuccess, registrationSuccess))
        }
    }
    
    /**
     Get road condition data from server based on location. Save to local database.
     - parameters:
        - location: a tuple of double containing latitude and longitude of fetching location
        - completion: a call back executed when finished fetching from database. First Bool indicates whether connection succeeded, second list contains all the condition objects fetched from database
     */
    func getConditionData(location: (Double, Double), completion: @escaping (Bool, [Condition]) -> ()){
        let params = [WSConstants.Params.LAT: location.0, WSConstants.Params.LOG: location.1]
        Alamofire.request(WSConstants.URL.GET_DATA, method: .get, parameters: params, encoding: URLEncoding.default).validate(statusCode: 200..<300).responseJSON { response in
            var connectionSuccess = false
            var resultList = [Condition]()
            switch response.result{
            case .success:
                if let data = response.result.value {
                    let dictData = data as! Dictionary<String, String>
                    let status = dictData[WSConstants.JSON.status]
                    if status == WSConstants.Status.success {
                        connectionSuccess = true
                        let jsonData = JSON(parseJSON: dictData[WSConstants.JSON.data]!)
                        for item in jsonData{
                            let newCondition = Condition(fromJSON: item.1)
                            // Insert data to local database
                            DBManager.sharedInstance.insertDataFromObject(condition: newCondition)
                            resultList.append(newCondition)
                        }
                        
                    }
                }
            case.failure(let error):
                print(self.LOG_TAG)
                print(error)
                
            }
            completion(connectionSuccess, resultList)
        }
    }
    
    /**
     Upload condition data to server database. First Bool in the completion callback indicates whether connection succeeded and second int is the id of the uploaded condition. if int == -1 means the uploaded condition is a duplication.
     */
    func uploadConditionData(condition: Condition, completion: @escaping ((Bool, Int)) -> ()){
        let params = [WSConstants.Params.USER_ID: UserDefaults.standard.string(forKey: UserDefaultConstants.USER_ID)!,
                      WSConstants.Params.CONDITION_TYPE: condition.conditionType,
                      WSConstants.Params.LAT: condition.location.0,
                      WSConstants.Params.LOG: condition.location.1,
                      WSConstants.Params.DIRECTION: condition.heading,
                      WSConstants.Params.SPEED: condition.speed,
                      WSConstants.Params.TIMESTAMP: dateFormatter.string(from: condition.timestamp),
                      WSConstants.Params.ACCURACY: condition.accuracy] as [String : Any]
        Alamofire.request(WSConstants.URL.UPLOAD_DATA, method: .post, parameters: params, encoding: URLEncoding.default).validate(statusCode: 200..<300).responseJSON { response in
            var connectionSuccess = false
            var condition_id = -1
            switch response.result{
            case .success:
                if let data = response.result.value {
                    let dictData = data as! Dictionary<String, String>
                    let status = dictData[WSConstants.JSON.status]
                    if status == WSConstants.Status.success {
                        connectionSuccess = true
                        condition_id = Int(dictData[WSConstants.JSON.data]!)!
                    }
                }
            case.failure(let error):
                print(self.LOG_TAG)
                print(error)
                
            }
            completion((connectionSuccess, condition_id))
        }
    }
    
    /**
     Feedback in plain string format. Supports unicode.
     */
    func uploadFeedback(feedback: String, completion: @escaping (Bool) -> ()){
        let params = [WSConstants.Params.USER_ID: UserDefaults.standard.string(forKey: UserDefaultConstants.USER_ID)!,
                      WSConstants.Params.FEEDBACK: feedback]
        Alamofire.request(WSConstants.URL.FEEDBACK, method: .post, parameters: params, encoding: URLEncoding.default).validate(statusCode: 200..<300).responseJSON { response in
            var connectionSuccess = false
            switch response.result{
            case .success:
                if let data = response.result.value {
                    let dictData = data as! Dictionary<String, String>
                    let status = dictData[WSConstants.JSON.status]
                    if status == WSConstants.Status.success {
                        connectionSuccess = true
                    }
                }
            case.failure(let error):
                print(self.LOG_TAG)
                print(error)
                
            }
            completion(connectionSuccess)
        }
    }
    
    /**
     Update accuracy of currently existed condition.
     - parameter condition: the condition which's value is to be updated
     - parameter increaseBy: Double between -1 ~ 1
     */
    func updateAccuracy(condition: Condition, increaseBy amountChanged: Double) {
        if (condition.id == nil) { return }
        let params = [WSConstants.Params.CONDITION_ID: String(condition.id!), WSConstants.Params.ACCURACY: String(amountChanged)]
        Alamofire.request(WSConstants.URL.UPDATE_ACCURACY, method: .post, parameters: params, encoding: URLEncoding.default).validate(statusCode: 200..<300).responseJSON { response in
            return
        }
    }
    
    /**
     Get parameters that are stored on the server. Parameter list is stored in UserDefaultConstants.ServerParams
     */
    func getServerParams (completion: @escaping (Bool) -> ()) {
        Alamofire.request(WSConstants.URL.SERVER_PARAMS, method: .get, encoding: URLEncoding.default).validate(statusCode: 200..<300).responseJSON { response in
            var connectionSuccess = false
            switch response.result{
            case .success:
                if let data = response.result.value {
                    let dictData = data as! Dictionary<String, String>
                    let status = dictData[WSConstants.JSON.status]
                    if status == WSConstants.Status.success {
                        connectionSuccess = true
                        let jsonData = JSON(parseJSON: dictData[WSConstants.JSON.data]!)
                        for item in jsonData {
                            UserDefaults.standard.set(item.1.doubleValue, forKey: item.0)
                        }
                    }
                }
            case.failure(let error):
                print(self.LOG_TAG)
                print(error)
                
            }
            completion(connectionSuccess)
        }
    }
}
