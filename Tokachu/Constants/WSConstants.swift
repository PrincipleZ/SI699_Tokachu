//
//  WebServiceConstants.swift
//  VComm
//
//  Created by Michael Ho on 6/27/17.
//  Changed by Yuanze Zhang on 6/12/18
//  Copyright © 2017 Michael Ho. All rights reserved.
//

// Web Service Constants for WebServiceUtils
class WSConstants {
    // URL constants
    struct URL {
        static let SERVER = "http://18.220.196.108//VComm/"
        static let ADD_USER = SERVER + "add_user.php"
        static let CHECK_USER = SERVER + "check_user.php"
        static let DELETE_USER = SERVER + "delete_user.php"
        static let UPLOAD_DATA = SERVER + "save_to_database.php"
        static let GET_DATA = SERVER + "prepare_data.php"
        static let DELETE_DATA = SERVER + "delete_record.php"
        static let FEEDBACK = SERVER + "feedback.php"
        static let UPDATE_ACCURACY = SERVER + "update_accuracy.php"
        static let SERVER_PARAMS = SERVER + "server_params.php"
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
        static let UUID = "uuid"
        static let USER_ID = "user_id"
        static let CONDITION_TYPE = "type"
        static let LAT = "loc_lat"
        static let LOG = "loc_log"
        static let SPEED = "speed"
        static let TIMESTAMP = "time"
        static let DIRECTION = "direction"
        static let ACCURACY = "accuracy"
        static let FEEDBACK = "feedback"
        static let CONDITION_ID = "condition_id"
        static let DATA = "data"
    }
    
    struct Service {
        static var ACCURACY_ADJUSTMENT = 0.01
        static var RADIUS = 0.25
        // meter
        static var NOTIFICATION_DISTANCE_BASIC = 90.0
        static var NOTIFICATION_DISTANCE_MULTIPLIER = 2.5
        static var ACCURACY_ADJUSTMENT_DISTANCE_BASIC = 7.0
        static var ACCURACY_ADJUSTMENT_DISTANCE_MULTIPLIER = 0.8
    }
    
    
    
    struct PubNub {
        static let PUBLISH_KEY = "pub-c-5e5a5f12-d0eb-4b2f-bdff-a745202b8d05"
        static let SUBSCRIBE_KEY = "sub-c-f71e96ba-892a-11e8-85ee-866938e9174c"
    }
}
