//
//  QBPropostasViewController.swift
//  iosFinalApp
//
//  Created by DocAdmin on 6/15/18.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import UIKit

class QBPropostasViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadPropostas()
        // Do any additional setup after loading the view.
    }

    // Var
    // --
    struct list {
        let origemDestino: String
        let DataEstado: String
    }
    
    var listViagem:[list] = []
    
    struct WSReturnPropostas: Encodable, Decodable {
        let get: Bool
        let result: [WSProposta]
    }
    
    struct WSProposta: Encodable, Decodable {
        let fkViagem: String
        let fkUser: String
        let estado: String
        let origemNome: String
        let origemCoordLat: String
        let origemCoordLong: String
    }
    
    struct WSReturnViagem: Encodable, Decodable {
        let get: Bool
        let result: [WSViagem]
    }
    
    struct WSViagem: Encodable, Decodable {
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
    
    @IBOutlet weak var tablePropostas: UITableView!
    
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
        cell.detailTextLabel?.text = listViagem[indexPath.row].DataEstado
        return cell
    }
    
    //MARK UITableViewDelegate
    
    /*func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editar = UITableViewRowAction(style: .default, title: "Propor"){action, index in
            //if !self.lblOrigem.text!.isEmpty {
            //    self.loadOrigem(idViagem: self.listViagem[indexPath.row].idHistorico)
            //}
        }
        editar.backgroundColor = UIColor.blue
        
        //return [editar]
    }*/
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
    private func loadPropostas(){
        let urlString = "http://davidmatos.pt/slimIOS/index.php/propostasByIdUser/" + String(Global.idUser)
        print(urlString)
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(WSReturnPropostas.self, from: data)
                DispatchQueue.main.async {
                    for proposta in response.result{
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
                                let response = try JSONDecoder().decode(WSReturnViagem.self, from: data)
                                DispatchQueue.main.async {
                                    var est = ""
                                    for viagem in response.result{
                                        switch Int(proposta.estado){
                                        case 1:
                                            est = "Pendente"
                                        case 2:
                                            est = "Aceite"
                                        default:
                                            est = "Recusado"
                                        }
                                        
                                        let aux = list(origemDestino: "De " + viagem.origemNome + " Para " + viagem.destinoNome, DataEstado: viagem.dataViagem + " Estado: " + est)
                                        self.listViagem.append(aux)
                                        self.tablePropostas.reloadData()
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
