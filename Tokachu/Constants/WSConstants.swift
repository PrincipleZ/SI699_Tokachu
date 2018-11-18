//
//  WebServiceConstants.swift
//  Tokachu
//
//
//  Created by Yuanze Zhang on 6/12/18
//

// Web Service Constants for WebServiceUtils
class WSConstants {
    // URL constants
    struct URL {
        static let SERVER = "http://127.0.0.1:8000/"
        static let USER = SERVER + "api/users/"
        
    }
    
    // JSON params
    struct JSON {
        static let message = "message"
        static let data = "data"
        static let status = "status"
    }
    
    // Keywords to check status
    struct Status {
        static let success = "success"
        static let fail = "fail"
        static let none = "none"
    }
    
    // Web service parameters constants
    struct Params {
        static let USERNAME = "username"
        static let PASSWORD = "password"
        static let FIRST_NAME = "first_name"
        static let LAST_NAME = "last_name"
        static let EMAIL = "email"
        
        static let UUID = "uuid"
        static let USER_ID = "id"
    }
    
    
    
    struct PubNub {
        static let PUBLISH_KEY = "pub-c-5e5a5f12-d0eb-4b2f-bdff-a745202b8d05"
        static let SUBSCRIBE_KEY = "sub-c-f71e96ba-892a-11e8-85ee-866938e9174c"
    }
}
