//
//  PomodoroModel.swift
//  PomodoroTimer
//
//  Created by Максим Окунеев on 23.01.2023.
//

import SwiftUI

class PomodoroModel: NSObject, ObservableObject {
    
    //MARK: - Timer Properties
    
    @Published var progress: CGFloat = 1
    @Published var timerStringValue: String = "00:00"
    @Published var isStarted: Bool = false
    @Published var addNewTimer: Bool = false 
    
    @Published var hour: Int = 0
    @Published var minutes: Int = 0
    @Published var seconds: Int = 0
    
    //MARK: - Total seconds
    
    @Published var totalSeconds: Int = 0
    @Published var staticTotalSeconds: Int = 0
    
    //MARK: - Post Timer Properties
    
    @Published var isFinished: Bool = false
    
    
    //MARK: - Init
     
    override init() {
        super.init()
        self.authorizeNotification()
    }
    
    //MARK: - Starting Timer
    
    func startingTimer() {
        withAnimation(.easeInOut(duration: 0.25)){
            isStarted = true
            
            //MARK: - Setting string timer value
            timerStringValue = "\(hour == 0 ? "" : "\(hour)")\(minutes >= 10 ? "\(minutes)" : "0\(minutes)"):\(seconds >= 10 ? "\(seconds)":"0\(seconds)")"
            
            //MARK: - Calculating total seconds for timer animation
            totalSeconds = (hour * 3600) + (minutes * 60) + seconds
            staticTotalSeconds = totalSeconds
            addNewTimer = false
            addNotification()
        }
    }
    
    //MARK: - Stop Timer
    
    func stopTimer() {
        withAnimation {
            isStarted = false
            hour = 0
            minutes = 0
            seconds = 0
            progress = 1
        }
        totalSeconds = 0
        staticTotalSeconds = 0
        timerStringValue = "00:00"
    }
    
    //MARK: - Update Timer
    
    func updateTimer() {
        totalSeconds -= 1
        progress = CGFloat(totalSeconds) / CGFloat(staticTotalSeconds)
        progress = (progress < 0 ? 0 : progress)
        // 60 Minutes * 60 Seconds
        hour = totalSeconds / 3600
        minutes = totalSeconds / 60 % 60
        seconds = totalSeconds % 60
        
        timerStringValue = "\(hour == 0 ? "" : "\(hour)")\(minutes >= 10 ? "\(minutes)" : "0\(minutes)"):\(seconds >= 10 ? "\(seconds)":"0\(seconds)")"
        
        if hour == 0, minutes == 0, seconds == 0 {
            isStarted = false
            print("finished")
            isFinished = true
        }
    }
    
    func addNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Pomodoro Timer"
        content.subtitle = "Congratulations You did it!"
        
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(staticTotalSeconds), repeats: false))
        
        UNUserNotificationCenter.current().add(request)
    }
}

extension PomodoroModel: UNUserNotificationCenterDelegate {
    //MARK: - Request Notification Access
    
    func authorizeNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) {_,_ in
            UNUserNotificationCenter.current().delegate = self
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner])
    }
}


