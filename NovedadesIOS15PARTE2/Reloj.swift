//
//  Reloj.swift
//  NovedadesIOS15PARTE2
//
//  Created by Paul Jaime Felix Flores on 21/06/23.
//

import SwiftUI

struct Reloj: View {
    //Vid241,guardar nuestra hora y eso se guardara en Userdefaults y será persistente 
    @AppStorage("reloj") var clock : String = "sin hora"
    
    let color : [Color] = [.red, .green, .blue, .purple, .yellow, .pink]
    let emoji = ["😀", "😬", "😄", "🙂", "😗", "🤓", "😏", "😕", "😟", "😎", "😜", "😍", "🤪"]
    
    var body: some View {
        //Vid 240,le ponemos el dia y que vaya de 1 en 1 y en in van los datos
        TimelineView(PeriodicTimelineSchedule(from: Date(), by: 1)) { _ in
            let date = Date.now
            //Vid 240,Ponemos la hora y le ponemos la hora tal cual .defaultDigitsNoAMPM
            let time = date.formatted(.dateTime.hour(.defaultDigitsNoAMPM).minute().second())
            let day = date.formatted(.dateTime.day(.defaultDigits))
            //Vid 240, Nos muestra el texto de la hora
            let dayName = date.formatted(.dateTime.weekday(.wide))
            
            Text("\(day) \(Text(dayName))")
                .font(.title)
            Text(time)
                .font(.largeTitle)
                .foregroundColor(color.randomElement())
            Text(emoji.randomElement() ?? "")
                .scaleEffect(2)
            //Vid 241 ,para capturar la hora
            Button("Capturar hora"){
                clock = time
            }
            Text("La hora es: \(clock)")
                .font(.largeTitle)
        }
    }
}


