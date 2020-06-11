//
//  AlarmController.swift
//  Alarm
//
//  Created by Bryan Workman on 6/8/20.
//  Copyright © 2020 Bryan Workman. All rights reserved.
//

import UIKit

protocol AlarmSchedulerDelegate {
    func scheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotifications(for alarm: Alarm)
}

class AlarmController {
    
    static let shared = AlarmController()
    
    init(){
        self.alarms = self.mockAlarms
    }
    
    //MARK: - SOT
    var alarms: [Alarm] = []
    fileprivate let userNotificationIdentifier = "TimerCompletedNotification"
    
    var mockAlarms: [Alarm] {
        let alarm1 = Alarm(name: "Alarm1", isOn: false, fireDate: Date())
        let alarm2 = Alarm(name: "Alarm2", isOn: false, fireDate: Date())
        let alarm3 = Alarm(name: "Alarm3", isOn: true, fireDate: Date())
        return [alarm1, alarm2, alarm3]
    }
    
    func toggleEnabled(for alarm: Alarm) {
        alarm.isOn = !alarm.isOn
        
        if alarm.isOn {
            scheduleUserNotifications(for: alarm)
        } else {
            cancelUserNotifications(for: alarm)
        }
    }
    
    //CRUD
    func addAlarm(fireDate: Date, name: String, enabled: Bool){
        let newAlarm = Alarm(name: name, isOn: enabled, fireDate: fireDate)
        alarms.append(newAlarm)
        scheduleUserNotifications(for: newAlarm)
        saveToPersistenceStore()
    }
    
    func update(alarm: Alarm, fireDate: Date, name: String, enabled: Bool){
        alarm.name = name
        alarm.fireDate = fireDate
        alarm.isOn = enabled
        scheduleUserNotifications(for: alarm)
        saveToPersistenceStore()
    }
    
    func delete(alarm: Alarm){
        guard let index = alarms.firstIndex(of: alarm) else {return}
        alarms.remove(at: index)
        cancelUserNotifications(for: alarm) 
        saveToPersistenceStore()
    }
    
    //MARK: - Persistence

    func createPersistenceStore() -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = url[0].appendingPathComponent("Alarm.json")
        return fileURL
    }

    //Save
    func saveToPersistenceStore() {
        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(alarms)
            try data.write(to: createPersistenceStore())
        } catch {
            print("Error encoding our alarms: \(error) --- \(error.localizedDescription)")
        }
    }

    //Load
    func loadFromPersistenceStore() {
        let jsonDecoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: createPersistenceStore())
            alarms = try jsonDecoder.decode([Alarm].self, from: data)
        } catch {
            print("Error decoding our data into alarms \(error) --- \(error.localizedDescription)")
        }
    }
}

extension AlarmController: AlarmSchedulerDelegate {
    
    func scheduleUserNotifications(for alarm: Alarm) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Alarm is going off"
        notificationContent.body = "Ring Ring"
        notificationContent.sound = .default
        
        let fireDate = alarm.fireDate
        
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: alarm.uuid, content: notificationContent, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    func cancelUserNotifications(for alarm: Alarm){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
}


