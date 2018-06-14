//
//  DBPropostasDetalheViewController.swift
//  iosFinalApp
//
//  Created by DocAdmin on 6/10/18.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DBPropostasDetalheViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadProposta()
    }

    // Var
    // --
    
    var geocoder = CLGeocoder()
    var CoordOrigemMaster = CLLocation()
    var CoordOrigemProposta = CLLocation()
    var CoordDestino = CLLocation()
    
    struct WSResultProposta: Decodable, Encodable {
        let get: Bool
        let result: [WSProposta]
    }
    
    struct WSProposta: Encodable, Decodable {
        let idProposta: String
        let fkViagem: String
        let fkUser: String
        let estado: String
        let origemNome: String
        let origemCoordLat: String
        let origemCoordLong: String
    }
    
    struct WSResultViagem: Encodable, Decodable {
        let get: Bool
        let result: [WSViagem]
    }
    
    struct WSViagem: Encodable, Decodable {
        let idViagem: String
        let origemNome: String
        let origemCoordLat: String
        let origemCoordLong: String
        let destinoNome: String
        let destinoCoordLat: String
        let destinoCoordLong: String
        let fkCar: String
        let fkUser: String
        let totalKm: String
        let estado: String
        let quantidadeLugares: String
        let lugaresDisponiveis: String
        let dataViagem: String
    }
    
    struct dados {
        let origemCoordMasterLat: String
        let origemCoordMasterLong: String
        let origemCoordLat: String
        let origemCoordLong: String
        let destinoCoordMasterLat: String
        let destinoCoordMasterLong: String
        let idViagem: String
        let idUser: String
    }
    
    var varAux: Any = ""
    
    // --
    // End Var
    
    // Outlets
    // --
    
    @IBOutlet weak var mapView: MKMapView!
    
    // --
    // End Outlets
    
    // Actions
    // --
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        if overlay.title == "route Master" {
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 5.0
        } else {
            renderer.strokeColor = UIColor.red
            renderer.lineWidth = 2.0
        }
        return renderer
    }
    
    @IBAction func btnCancelar(_ sender: Any) {
        self.performSegue(withIdentifier: "segueProposta", sender: self)
    }
    
    @IBAction func btnAceitar(_ sender: Any) {
    }
    
    // --
    // End Actions
    
    // Functions
    // --

    

    
    private func centerMapOnLocation(location: CLLocation){
        let regionRadius: CLLocationDistance = 2000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    private func calculateMasterRoute(origemLat: Double, origemLong: Double, destinoLat: Double, destinoLong: Double){
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: origemLat, longitude: origemLong), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: destinoLat, longitude: destinoLong), addressDictionary: nil))
        request.requestsAlternateRoutes = false
        
        let direction = MKDirections(request: request)
        direction.calculate(completionHandler: {
            (response, error) in
            if error != nil {
                self.displayMessage("Occoreu um erro durante o calculo do percurso, por favor tente novamente", type: 1)
            } else {
                for route in (response?.routes)! {
                    route.polyline.title = "route Master"
                    self.mapView.add(route.polyline, level: MKOverlayLevel.aboveRoads)
                }
            }
        })
        centerMapOnLocation(location: CLLocation(latitude: origemLat, longitude: origemLong))
    }
    
    private func calculateRoute(origemLat: Double, origemLong: Double, destinoLat: Double, destinoLong: Double){
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: origemLat, longitude: origemLong), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: destinoLat, longitude: destinoLong), addressDictionary: nil))
        request.requestsAlternateRoutes = false
        
        let direction = MKDirections(request: request)
        direction.calculate(completionHandler: {
            (response, error) in
            if error != nil {
                self.displayMessage("Occoreu um erro durante o calculo do percurso, por favor tente novamente", type: 1)
            } else {
                for route in (response?.routes)! {
                    self.mapView.add(route.polyline, level: MKOverlayLevel.aboveRoads)
                }
            }
        })
    }
    
    
    
    private func loadProposta(){
        let urlString = "http://davidmatos.pt/slimIOS/index.php/propostas/" + String(Global.idProposta)
        print(urlString)
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(WSResultProposta.self, from: data)
                DispatchQueue.main.async {
                    for proposta in response.result {
                        // ----------------------------------------------------------------
                        let urlString = "http://davidmatos.pt/slimIOS/index.php/viagem/" + proposta.fkViagem
                        print(urlString)
                        guard let url = URL(string: urlString) else { return }
                        
                        URLSession.shared.dataTask(with: url) {
                            (data, response, error) in
                            if error != nil {
                                print(error!.localizedDescription)
                            }
                            
                            guard let data = data else { return }
                            
                            do {
                                let response = try JSONDecoder().decode(WSResultViagem.self, from: data)
                                DispatchQueue.main.async {
                                    for viagem in response.result {
                                        let d = dados(origemCoordMasterLat: viagem.origemCoordLat, origemCoordMasterLong: viagem.origemCoordLong, origemCoordLat: proposta.origemCoordLat, origemCoordLong: proposta.origemCoordLong, destinoCoordMasterLat: viagem.destinoCoordLat, destinoCoordMasterLong: viagem.destinoCoordLong, idViagem: viagem.idViagem, idUser: proposta.fkUser)
                                        self.varAux = d

                                        self.calculateMasterRoute(origemLat: Double(viagem.origemCoordLat)!, origemLong: Double(viagem.origemCoordLong)!, destinoLat: Double(viagem.destinoCoordLat)!, destinoLong: Double(viagem.destinoCoordLong)!)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 05, execute: {
                                            self.calculateRoute(origemLat: Double(viagem.origemCoordLat)!, origemLong: Double(viagem.origemCoordLong)!, destinoLat: Double(proposta.origemCoordLat)!, destinoLong: Double(proposta.origemCoordLong)!)
                                        })
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: {
                                            self.calculateRoute(origemLat: Double(proposta.origemCoordLat)!, origemLong: Double(proposta.origemCoordLong)!, destinoLat: Double(viagem.destinoCoordLat)!, destinoLong: Double(viagem.destinoCoordLong)!)
                                        })
                                    }
                                }
                            } catch let jsonError {
                                print(jsonError)
                            }
                            
                            }.resume()
                    }
                }
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
    }
    
    
    private func displayMessage(_ mensagem: String, type: Int) {
        
        // 0 to Success
        // 1 to Error
        
        if ( type == 1) {
            let alerta = UIAlertController(title: "Alerta", message: mensagem, preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alerta.addAction(okAction)
            self.present(alerta, animated: true, completion: nil)
        } else {
            let alerta = UIAlertController(title: "Bem Vindo", message: mensagem, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default){
                (action) in
                //self.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "segueMain", sender: self)
            }
            
            alerta.addAction(okAction)
            self.present(alerta, animated: true, completion: nil)
        }
    }
    
    
    // --
    // Functions
    
}
