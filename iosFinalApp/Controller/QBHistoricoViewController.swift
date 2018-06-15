//
//  QBHistoricoViewController.swift
//  iosFinalApp
//
//  Created by DocAdmin on 6/15/18.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import UIKit

class QBHistoricoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadBoleia()
        // Do any additional setup after loading the view.
    }

    // Var
    // --
    
    struct list {
        let origemDestino: String
        let DataPagamento: String
    }
    
    var listViagem:[list] = []
    
    struct WSReturnBoleia: Encodable, Decodable {
        let get: Bool
        let result: [WSBoleia]
    }
    
    struct WSBoleia: Encodable, Decodable {
        let fkViagem: String
        let fkUser: String
        let estadoPagamento: String
        let estado: String
    }
    
    struct WSReturnViagem: Encodable, Decodable {
        let get: Bool
        let result: [WSViagem]
    }
    
    struct WSViagem: Decodable, Encodable {
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
    
    // --
    // End Var
    
    // Outlets
    // --
    @IBOutlet weak var tableHistorico: UITableView!
    
    
    
    // --
    // End Outlets
    
    // Actions
    // --
    
    
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
        cell.detailTextLabel?.text = listViagem[indexPath.row].DataPagamento
        return cell
    }
    
    //MARK UITableViewDelegate
    /*
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editar = UITableViewRowAction(style: .default, title: "Propor"){action, index in
            //if !self.lblOrigem.text!.isEmpty {
            //    self.loadOrigem(idViagem: self.listViagem[indexPath.row].idHistorico)
            //}
        }
        editar.backgroundColor = UIColor.blue
        
        return [editar]
        
    }
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
    private func loadBoleia(){
        let urlString = "http://davidmatos.pt/slimIOS/index.php/boleiaByIdUser/" + String(Global.idUser)
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode(WSReturnBoleia.self, from: data)
                DispatchQueue.main.async {
                    for boleia in response.result{
                        print(boleia, "fs")
                        let urlString = "http://davidmatos.pt/slimIOS/index.php/viagem/" + boleia.fkViagem
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
                                        print(viagem, "fds")
                                        var pag: String = ""
                                        if Int(boleia.estadoPagamento) == 0 {
                                            pag = "Pendente"
                                        }else{
                                            pag = "Pago"
                                        }
                                        let aux = list(origemDestino: "De: " + viagem.origemNome + " Para: " + viagem.destinoNome, DataPagamento: viagem.dataViagem + " " + pag)
                                        self.listViagem.append(aux)
                                        self.tableHistorico.reloadData()
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
    
    // --
    // End Functions
    
    
    
}
