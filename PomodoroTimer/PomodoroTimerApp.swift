//
//  PomodoroTimerApp.swift
//  PomodoroTimer
//
//  Created by Максим Окунеев on 23.01.2023.
//

import SwiftUI

@main
struct PomodoroTimerApp: App {
    //MARK: - Since We're doing background fetching intializing here
    
    @StateObject var pomodoroModel: PomodoroModel = .init()
    
    //MARK: - Scene Phase
    
    @Environment(\.scenePhase) var phase
    
    //MARK: - Storing Last Time Stamp
    
    @State var lastActiveTimeStamp: Date = Date()
     
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(pomodoroModel)
        }
        .onChange(of: phase) { newValue in
            if pomodoroModel.isStarted {
                if newValue == .background {
                    lastActiveTimeStamp = Date()
                }
                 
                if newValue == .active {
                    // Finding the difference
                    let currentTimeStampDiff = Date().timeIntervalSince(lastActiveTimeStamp)
                    
                    if pomodoroModel.totalSeconds - Int(currentTimeStampDiff) <= 0 {
                        pomodoroModel.isStarted = false
                        pomodoroModel.totalSeconds = 0
                        pomodoroModel.isFinished = true
                    } else {
                        pomodoroModel.totalSeconds -= Int(currentTimeStampDiff)
                    }
                }
            }
        }
    }
}
