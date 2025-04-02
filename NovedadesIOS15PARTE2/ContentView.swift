//
//  ContentView.swift
//  NovedadesIOS15PARTE2
//
//  Created by Paul Jaime Felix Flores on 21/06/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showModal = false
    
    var body: some View {
        NavigationView{
            Button("Abrir ventana"){
                showModal.toggle()
            }.navigationTitle("Ventana modal media")
                .mediaModal(showModal: $showModal) {
                    Text("Soy la ventana modal")
                }
        }
    }
}
//Vid 236, creamos una funcion que llamara a lo demas
extension View{
    
    func mediaModal<ModalView : View>(showModal: Binding<Bool>, @ViewBuilder modalView: @escaping () -> ModalView) ->
    //Vid 236, construimos una vista
    some View {
        return self
            .background(
                //Aqui mandamos a llamar a nuestra estructura 
                mediaModalHelper(modalView: modalView(), showModal: showModal)
            )
    }
    
}
//Vid 236, representamos una vista del View controler
struct mediaModalHelper<ModalView: View>: UIViewControllerRepresentable {
    //Creamos una vista modal
    var modalView : ModalView
    //Vid 236, es con lo que estaremos mostrando nuestra ventana modal
    @Binding var showModal : Bool
    let controller = UIViewController()
    //Necitamos este procolo para ver esto
    func makeUIViewController(context: Context) -> UIViewController {
        //Retornamos el controler que creamos
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
        if showModal {
            //Le presentamos a la vista
            let modalController = CustomHostingController(rootView: modalView)
            //Vid 236, le presentamos el view controler
            uiViewController.present(modalController, animated: true) {
                DispatchQueue.main.async {
                    self.showModal.toggle()
                }
            }
        }
        
    }
    
}
//Vid 236-Aqui escribimos el codigo de UKit de un View controler
//Aqui podemos escribir cualquier codigo de UIKit
class CustomHostingController<Content: View> : UIHostingController<Content>{
    
    //Hacemos el mismo codigo de la vez pasada
    override func viewDidLoad() {
        
        if let presentation = presentationController as? UISheetPresentationController {
            
            presentation.detents = [
                //Vid 236, para que el content view sea tamaño medium o completo
                .medium(),
                .large()
            ]
            
            presentation.prefersGrabberVisible = true
            
        }
        
    }
    
}


