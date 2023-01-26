//
//  ContentView.swift
//  PomodoroTimer
//
//  Created by Максим Окунеев on 23.01.2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var pomodoroModel: PomodoroModel
    
    var body: some View {
        Home()
            .environmentObject(pomodoroModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
