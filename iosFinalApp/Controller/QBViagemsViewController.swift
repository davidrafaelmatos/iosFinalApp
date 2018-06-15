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
    var CoordDestino = CLLocation()
    
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
    }
    
        var listViagem:[list] = []
    
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
        loadDestino()
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
            //Global.idProposta = self.arrayProp[index.row].id
            //self.performSegue(withIdentifier: "seguePropostaDetalhe", sender: self)
        }
        editar.backgroundColor = UIColor.blue
        
        return [editar]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
    
    private func loadDestino(){
        self.geocoder.geocodeAddressString(lblDestino.text!) {
            (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?){
        if let error = error {
            displayMessage("Occoreu um erro durante o calculo do percurso, por favor tente novamente", type: 1)
        } else {
            var location: CLLocation?
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
                    CoordDestino = CLLocation(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
                print(CoordDestino)
                loadViagens()
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
                self.performSegue(withIdentifier: "segueMain", sender: self)
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
                print(error!.localizedDescription)
            }
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode(WSReturnViagem.self, from: data)
                DispatchQueue.main.async {
                    for viagem in response.result{
                        
                        // -- teste
                        
                        var string = "hello Swift"
                        
                        if string.range(of:"Swift") != nil {
                            print("exists teste fds", string.range(of:"Swift") != nil)
                        }
                        
                        // -- teste
                        print(viagem)
                        print("result", viagem.destinoNome.range(of: self.lblDestino.text!) != nil)
                        if viagem.destinoNome.range(of: self.lblDestino.text!) != nil && viagem.origemNome.range(of: self.lblOrigem.text!) != nil {
                            let aux = list(origemDestino: "de: " + viagem.origemNome + " para: " + viagem.destinoNome, data: viagem.dataViagem, idHistorico: Int(viagem.idViagem)!, estado: Int(viagem.estado)!)
                            self.listViagem.append(aux)
                            print("entrou", self.listViagem)
                            self.tableViagens.reloadData()
                        }else{
                            print("-------------------------- fsd -------------------")
                        }
                    }
                }
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
    }
    
    // --
    // End Functions
    

}
