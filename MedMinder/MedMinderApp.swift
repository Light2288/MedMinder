//
//  MedMinderApp.swift
//  MedMinder
//
//  Created by Davide Aliti on 20/06/22.
//

import SwiftUI

@main
struct MedMinderApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
