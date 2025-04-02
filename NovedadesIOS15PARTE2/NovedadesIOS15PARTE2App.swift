//
//  NovedadesIOS15PARTE2App.swift
//  NovedadesIOS15PARTE2
//
//  Created by Paul Jaime Felix Flores on 21/06/23.
//

import SwiftUI

@main
struct NovedadesIOS15PARTE2App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            //Vid 236,media Ventana modal
            //ContentView()
            //Vid 237
            //Mapa()
            //Vid 240
            Reloj()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
