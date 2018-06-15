//
//  QBViagemsViewController.swift
//  iosFinalApp
//
//  Created by DocAdmin on 6/10/18.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class QBViagemsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate  {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Var
    // --
    
    var geocoder = CLGeocoder()
    var CoordOrigem = CLLocation()
    
    struct lista {
        let makeModel: String
        let consumoCombustivel: String
        let id: Int

    }

    struct list: Encodable, Decodable {
        let origemDestino: String
        let data: String
        let idHistorico: Int
        let estado: Int
        let estadoProposta: Int
    }
    
        var listViagem:[list] = []
    
    struct WSInputProposta: Encodable, Decodable {
        let fkViagem: Int
        let fkUser: Int
        let estado: Int
        let origemNome: String
        let origemCoordLat: String
        let origemCoordLong: String
    }
    
    struct WSReturnProposta: Encodable, Decodable {
        let Post: Bool
    }
    
    struct WSInputP: Encodable, Decodable {
        let idViagem: Int
        let idUser: Int
    }
    
    struct WSReturnP: Encodable, Decodable {
        let get: Bool
    }
    
    // --
    // End Var
    
    
    // Outlets
    // --
    @IBOutlet weak var lblOrigem: UITextField!
    @IBOutlet weak var lblDestino: UITextField!
    @IBOutlet weak var tableViagens: UITableView!

    // --
    // End Outlets
    
    // Actions
    // --
    @IBAction func btnSearch(_ sender: Any) {
        if lblOrigem.text!.isEmpty || lblDestino.text!.isEmpty {
            
        } else {
            loadViagens()
        }

    }
    
    
    // --
    // End Actions
    
    // Functions
    // --
    
    //MARK UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViagem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = listViagem[indexPath.row].origemDestino
        cell.detailTextLabel?.text = listViagem[indexPath.row].data
        return cell
    }
    
    //MARK UITableViewDelegate
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editar = UITableViewRowAction(style: .default, title: "Propor"){action, index in
            if !self.lblOrigem.text!.isEmpty {
                self.loadOrigem(idViagem: self.listViagem[indexPath.row].idHistorico)
            }
        }
        editar.backgroundColor = UIColor.blue
        
        return [editar]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
    private func loadOrigem(idViagem: Int){
        self.geocoder.geocodeAddressString(lblOrigem.text!) {
            (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error, idViagem: idViagem)
        }
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?, idViagem: Int){
        if let error = error {
            displayMessage("Occoreu um erro durante o calculo do percurso, por favor tente novamente", type: 1)
        } else {
            var location: CLLocation?
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
                    CoordOrigem = CLLocation(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
                let aux = WSInputProposta(fkViagem: idViagem, fkUser: Global.idUser, estado: 1, origemNome: self.lblOrigem.text!, origemCoordLat: String(location!.coordinate.latitude), origemCoordLong: String(location!.coordinate.longitude))
                addProposta(proposta: aux)
            }
        }
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
                //self.performSegue(withIdentifier: "segueMain", sender: self)
            }
            
            alerta.addAction(okAction)
            self.present(alerta, animated: true, completion: nil)
        }
    }
    
    private func loadViagens(){
        let urlString = "http://davidmatos.pt/slimIOS/index.php/viagens"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if error != nil {

            }
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode(WSReturnViagem.self, from: data)
                DispatchQueue.main.async {
                    for viagem in response.result{
                        self.listViagem = []
                        if viagem.destinoNome.range(of: self.lblDestino.text!) != nil && viagem.origemNome.range(of: self.lblOrigem.text!) != nil && Int(viagem.idViagem) != -1 {
                            
                            let aux = WSInputP(idViagem: Int(viagem.idViagem)!, idUser: Global.idUser)
                            
                            var request = URLRequest(url: URL(string: "http://davidmatos.pt/slimIOS/index.php/propostasByIdUserAndIdViagem")!)
                                request.httpMethod = "POST"
                                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                                do {
                                    let jsonBody = try JSONEncoder().encode(aux)
                                    request.httpBody = jsonBody
                                } catch {
                                    print("error")
                                    return
                                }
                                let task = URLSession.shared.dataTask(with: request) {
                                    (data, response, error) in
                                    guard error == nil else {
                                        print(error!)
                                        return
                                    }
                                    guard let data = data else {
                                        print("data is empty")
                                        return
                                    }
                                    do {
                                        let response = try JSONDecoder().decode( WSReturnP.self, from: data)
                                        DispatchQueue.main.async {
                                            if !response.get {
                                                let aux = list(origemDestino: "de: " + viagem.origemNome + " para: " + viagem.destinoNome, data: viagem.dataViagem, idHistorico: Int(viagem.idViagem)!, estado: Int(viagem.estado)!, estadoProposta: 0)
                                                self.listViagem.append(aux)
                                                self.tableViagens.reloadData()
                                            }
                                        }
                                    } catch let jsonError {
                                        print(jsonError)
                                    }
                                }
                                task.resume()
                        }else{
                        }
                    }
                }
            } catch let jsonError {
            }
            
        }.resume()
    }
    
    private func addProposta(proposta: WSInputProposta){
        var request = URLRequest(url: URL(string: "http://davidmatos.pt/slimIOS/index.php/proposta/new")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let jsonBody = try JSONEncoder().encode(proposta)
            request.httpBody = jsonBody
        } catch {
            print("error")
            return
        }
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("data is empty")
                return
            }
            do {
                let response = try JSONDecoder().decode( WSReturnProposta.self, from: data)
                DispatchQueue.main.async {
                    if(response.Post){
                        self.listViagem = []
                        self.loadViagens()
                    }
                }
            } catch let jsonError {
                print(jsonError)
            }
        }
        task.resume()
    }
    
    
    // --
    // End Functions
    

}
