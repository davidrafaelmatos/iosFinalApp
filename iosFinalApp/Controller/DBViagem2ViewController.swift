//
//  DBViagem2ViewController.swift
//  iosFinalApp
//
//  Created by DocAdmin on 6/10/18.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DBViagem2ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCoordinate()
    }
    
    // Var
    // --
    
    var geocoder = CLGeocoder()
    var CoordOrigem = CLLocation()
    var CoordDestino = CLLocation()
    var aux: Bool = false
    var km: Double = -1
    
    struct WSViagem: Decodable, Encodable {
        let origemNome: String
        let origemCoordLat: String
        let origemCoordLong: String
        let destinoNome: String
        let destinoCoordLat: String
        let destinoCoordLong: String
        let fkCar: Int
        let fkUser: Int
        let totalKm: Double
        let estado: Int
        let quantidadeLugares: Int
        let lugaresDisponiveis: Int
        let dataViagem: String
    }
    
    struct WSResult: Encodable, Decodable {
        let Post: Bool
        let msg: String
    }
    
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
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        
        return renderer
    }
    
    @IBAction func btnCancelar(_ sender: Any) {
        self.performSegue(withIdentifier: "segueMain", sender: self)
    }
    @IBAction func btnGuardar(_ sender: Any) {
        let date: Date = Date()
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy hh:mm"
        let data = formatter.string(from: date)
        let viagem = WSViagem(origemNome: Global.origemDBViagem, origemCoordLat: String(CoordOrigem.coordinate.latitude), origemCoordLong: String(CoordOrigem.coordinate.longitude), destinoNome: Global.destinoDBViagem, destinoCoordLat: String(CoordDestino.coordinate.latitude), destinoCoordLong: String(CoordDestino.coordinate.longitude), fkCar: Global.idCar, fkUser: Global.idUser, totalKm: km, estado: 1, quantidadeLugares: Global.numLugares, lugaresDisponiveis: Global.numLugares, dataViagem: data)
        addViagem(viagem: viagem)
    }
    // --
    // End Actions
    
    // Functions
    // --
    
    private func loadCoordinate(){
    
        self.loadOrigem()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
        self.loadDestino()
        })
        //calculateRota()
        DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: {
            self.calculateRota()
        })
    }
    
    private func loadOrigem(){
        self.geocoder.geocodeAddressString(Global.origemDBViagem) {
            (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error, tipo: 0)
        }
    }
    
    private func loadDestino(){
        self.geocoder.geocodeAddressString(Global.destinoDBViagem) {
            (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error, tipo: 1)
        }
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?, tipo: Int){
        if let error = error {
            displayMessage("Occoreu um erro durante o calculo do percurso, por favor tente novamente", type: 1)
            print(error, "nao conseguiu buscar localização")
        } else {
            var location: CLLocation?
            
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
                if tipo == 0 {
                    CoordOrigem = CLLocation(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
                    centerMapOnLocation(location: CLLocation(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude))
                } else {
                    CoordDestino = CLLocation(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
                }
                
            }
            
            
        }
    }
    
    private func centerMapOnLocation(location: CLLocation){
        let regionRadius: CLLocationDistance = 2000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    private func calculateRota(){
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: CoordOrigem.coordinate.latitude, longitude: CoordOrigem.coordinate.longitude), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: CoordDestino.coordinate.latitude, longitude: CoordDestino.coordinate.longitude), addressDictionary: nil))
        request.requestsAlternateRoutes = false
        
        let direction = MKDirections(request: request)
        direction.calculate(completionHandler: {
            (response, error) in
            if error != nil {
                self.displayMessage("Occoreu um erro durante o calculo do percurso, por favor tente novamente", type: 1)
            } else {
                self.showRoute(response!)
            }
        })
    }
    
    private func showRoute(_ response: MKDirectionsResponse) {
        for route in response.routes {
            km = route.distance
            mapView.add(route.polyline, level: MKOverlayLevel.aboveRoads)
        }
    }
    
    private func addViagem(viagem: WSViagem){
        var request = URLRequest(url: URL(string: "http://davidmatos.pt/slimIOS/index.php/viagem/new")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let jsonBody = try JSONEncoder().encode(viagem)
            request.httpBody = jsonBody
        } catch {
            print("error")
            displayMessage("Ocorreu um erro ao guardar a viagem por favor tente novamente", type: 1)
            return
        }
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            guard error == nil else {
                self.displayMessage("Ocorreu um erro ao guardar a viagem por favor tente novamente", type: 1)
                print(error!)
                return
            }
            guard let data = data else {
                print("data is empty")
                self.displayMessage("Ocorreu um erro ao guardar a viagem por favor tente novamente", type: 1)
                return
            }
            do {
                let response = try JSONDecoder().decode( WSResult.self, from: data)
                DispatchQueue.main.async {
                    if(response.Post){
                        self.displayMessage("A sua viagem foi adicionada com sucesso", type: 0)
                    } else {
                        self.displayMessage("Os dados inseridos estao incorretos", type: 1)
                    }
                }
            } catch let jsonError {
                self.displayMessage("Ocorreu um erro ao guardar a viagem por favor tente novamente", type: 1)
                print(jsonError)
            }
        }
        task.resume()
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
    // End Function
}
