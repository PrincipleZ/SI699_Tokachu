import Foundation

class Event {
    let owner_id: int
    
    var event_id: int
    var event_name: string
    var start_time: Date
    var end_time: Date
    var place_id: string
    var description: string
    var main_channel: string
    
    init (owner_id: int, event_name: string, start_time: Date, end_time: Date, place_id: string, description: string) {
        
    }
}
