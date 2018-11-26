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
        self.dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
        self.dateFormatter.timeZone = TimeZone(identifier: "UTC")
    }

    func logIn(email: String, password: String, completion: @escaping (Bool, String) -> ()){
        let params = [WSConstants.Params.EMAIL: email, WSConstants.Params.PASSWORD: password]
        Alamofire.request(WSConstants.URL.USER+"log_in/", method: .post, parameters: params, encoding: URLEncoding.default).responseJSON{
            response in
            var success = false
            var errorMsg = ""
            var statusCode = response.response?.statusCode
            switch statusCode {
            case 403:
                errorMsg = "Incorrect Password"
                break
            case 404:
                errorMsg = "Email doesn't exist"
                break
            case 201:
                success = true
                if let data = response.result.value{
                    let dictData = data as! NSDictionary
                    UserDefaults.standard.set(dictData["id"], forKey: UserDefaultsConstants.USER_ID )
                    UserDefaults.standard.set(dictData["first_name"], forKey: UserDefaultsConstants.FIRST_NAME )
                    UserDefaults.standard.set(dictData["last_name"], forKey: UserDefaultsConstants.LAST_NAME )
                    if dictData["profile_picture"] is NSNull {
                        UserDefaults.standard.set(nil, forKey: UserDefaultsConstants.PROFILE_PICTURE )
                    } else {
                        UserDefaults.standard.set(dictData["profile_picture"], forKey: UserDefaultsConstants.PROFILE_PICTURE )
                    }
                } else {
                    success = false
                    errorMsg = "Unknown error"
                }
                break
            default:
                errorMsg = "Unknown error"
                break
            }
            completion(success, errorMsg)
        }
    }
    
    func publishEvent(event_name: String, start_time: Date, end_time: Date, place_id: String, description: String, category: String, completion: @escaping (Bool) -> ()){
        
        let text_start_time = dateFormatter.string(from: start_time)
        let text_end_time = dateFormatter.string(from: end_time)

        print(text_start_time)
        let params = [WSConstants.Params.OWNER_ID: UserDefaults.standard.integer(forKey: UserDefaultsConstants.USER_ID), WSConstants.Params.EVENT_NAME: event_name, WSConstants.Params.START_TIME: text_start_time, WSConstants.Params.END_TIME : text_end_time, WSConstants.Params.PLACE_ID: place_id, WSConstants.Params.DESCRIPTION: description, WSConstants.Params.CATEGORY: category] as [String : Any]
        Alamofire.request(WSConstants.URL.EVENT, method: .post, parameters: params, encoding: URLEncoding.default).responseJSON{
            response in
            print(response.result.value)
            var success = false
            switch response.result {
            case .success:
                success = true
                break
            case .failure(let error):
                print(self.LOG_TAG)
                print(error)
                break

            }
            completion(success)
        }
    }
    
    func getCategories(){
        Alamofire.request(WSConstants.URL.THEME, method: .get, encoding: URLEncoding.default).validate(statusCode: 200..<300).responseJSON{
            response in
            switch response.result {
            case .success:
                if let data = response.result.value{
                    var categoryDict = Dictionary<String, Int>()
                    for i in data as! NSArray{
                        let temp = (i as! NSDictionary)
                        let key = temp["theme_name"] as! String
                        let value = temp["id"] as! NSNumber
                        categoryDict[key] = value as? Int
                    }
                    // use userdefault as temp localstorage
                    UserDefaults.standard.set(categoryDict, forKey: UserDefaultsConstants.CATEGORY)
                }
                break
            case .failure(let error):
                print(self.LOG_TAG)
                print(error)
                break
                
            }
        }
    }
    
    func register(firstName: String, lastName: String, email: String, password: String, completion: @escaping (Bool, String) -> ()) {
        let params = [WSConstants.Params.LAST_NAME: lastName, WSConstants.Params.FIRST_NAME: firstName, WSConstants.Params.EMAIL: email, WSConstants.Params.PASSWORD: password]
        Alamofire.request(WSConstants.URL.USER, method: .post, parameters: params, encoding: URLEncoding.default).responseJSON{
            response in
            print(response.result.value)
            var success = false
            var errorMsg = ""
            switch response.response?.statusCode {
            case 201:
                if let data = response.result.value{
                    let dictData = data as! NSDictionary
                    UserDefaults.standard.set(dictData["id"], forKey: UserDefaultsConstants.USER_ID )
                    UserDefaults.standard.set(dictData["first_name"], forKey: UserDefaultsConstants.FIRST_NAME )
                    UserDefaults.standard.set(dictData["last_name"], forKey: UserDefaultsConstants.LAST_NAME )
                    if dictData["profile_picture"] is NSNull {
                        UserDefaults.standard.set(nil, forKey: UserDefaultsConstants.PROFILE_PICTURE )
                    } else {
                        UserDefaults.standard.set(dictData["profile_picture"], forKey: UserDefaultsConstants.PROFILE_PICTURE )
                    }
                }
                success = true
                break
            case 400:
                let errorDict = response.result.value as! Dictionary<String, Array<String>>
                
                errorMsg = errorDict.values.first![0]
                break
            
            default:
                errorMsg = "Unknown error"
                break
            }
            completion(success, errorMsg)
        }
        
    }
    
    func searchEvent(category: [String], start_time: Date, end_time: Date, completion: @escaping (Bool, [Event]) -> ()){
        print(category.joined(separator: ","))
        let text_start_time = dateFormatter.string(from: start_time)
        let text_end_time = dateFormatter.string(from: end_time)

        let params = [WSConstants.Params.CATEGORY: category.joined(separator: ","), WSConstants.Params.START_TIME: text_start_time, WSConstants.Params.END_TIME: text_end_time]
        Alamofire.request(WSConstants.URL.EVENT + "search/", method: .get, parameters: params, encoding: URLEncoding.default).validate(statusCode: 200..<300).responseJSON{
            response in
            switch response.result {
            case .success:
                print(response.result.value)
                break
            case .failure(let error):
                print(self.LOG_TAG)
                print(error)
                break
                
            }
        }
        
    }

}
