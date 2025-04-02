//
//  Mapa.swift
//  NovedadesIOS15PARTE2
//
//  Created by Paul Jaime Felix Flores on 21/06/23.
//

import SwiftUI
//Vid 237-Para obtener nuestra localizacion
import CoreLocation
import CoreLocationUI

//Vid 238-Para poner nuestro mapa
import MapKit
struct Mapa: View {
    
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        //Vid 228,para poner nuesro boton flotante
        ZStack(alignment: .topTrailing){
            //Vid 238,ponemos nuestra region, Vid 239 ponemos anottations 
            Map(coordinateRegion: $locationManager.region, showsUserLocation: true, annotationItems: locationManager.lugares, annotationContent: { lugar in
                MapMarker(coordinate: lugar.mapItem.placemark.coordinate, tint: .purple)
            })
                .ignoresSafeArea()
            //Vid 239
            HStack{
                TextField("Buscador", text: $locationManager.lugar)
                    .textFieldStyle(.roundedBorder)
                //Vid 237 ,ponemos nuestro boton de busqueda
                LocationButton{
                    locationManager.requestLocation()
                }
                //Vid 238,Para poner nuestro diseño del mapa
                .labelStyle(.iconOnly)
                .symbolVariant(.fill)
                .foregroundColor(.white)
                .tint(.green)
                .clipShape(Circle())
                .padding()
            }.padding(.all)
            
        }
    }
}

//Vid 237-Es nuestra LocationView
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    //Vid 237, es donde tenemos nuestras coordenadas
    @Published var location : CLLocationCoordinate2D?
    
    //Vid 238, para poner nuestro map
    @Published var region: MKCoordinateRegion = .init()
    
    //Vid 239, buscador en nuestro mapa
    @Published var lugares : [Lugares] = []
    //Vid 239, es para el lugar que estamos buscando
    @Published var lugar = ""
    
    //Vid 237, ponemos nuestro delegado
    override init(){
        super.init()
        manager.delegate = self
    }
    //Vid 237,ponemos nuestars coordenadas
    func requestLocation(){
        manager.requestLocation()
    }
    //Vid 237, es necesario para que nos muestre el eror en cosola en caso de que lo tengamos
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    //Vid 237, y aqui obtenemos las coordenadas
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Vid 238, aquí es donde estamos sacando todas nuestras coordenadas
        guard let location = locations.first?.coordinate else { return }
        
        //Vid 238,ponemos nuestra localizacion,ponemos la localizacion
        region = MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        //Vid 239, hacemos que se inicialice
        Task.init{
            await searchLocations()
        }
        
    }
    //Vid 239, funcion para que nos busqe los lugares
    func searchLocations() async {
        do{
            //Hacemos nuestra busqueda local en nuestro mapa
            let request = MKLocalSearch.Request()
            request.region = region
            //Le decimos que busque lo que queramos
            request.naturalLanguageQuery = self.lugar
            let query = MKLocalSearch(request: request)
            let response = try await query.start()
            //Cuanso se usa el asyn y y el await se usa mas el MainActor
            await MainActor.run {
                self.lugares = response.mapItems.compactMap({ item in
                    //mapItem viene de lugares
                    return Lugares(mapItem: item)
                })
            }
        
        }catch let error as NSError{
            print(error.localizedDescription)
        }
    }
    
    
}
//Vid 239,para buscar varios lugares
struct Lugares : Identifiable {
    //Vid 239, para que nos de el id alfanumerico
    var id = UUID().uuidString
    var mapItem : MKMapItem
    
}


