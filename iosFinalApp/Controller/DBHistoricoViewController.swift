//
//  DBHistoricoViewController.swift
//  iosFinalApp
//
//  Created by DocAdmin on 6/10/18.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import UIKit

class DBHistoricoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadViagens()
    }
    
    // Var
    // --
    
    struct list: Encodable, Decodable {
        let origemDestino: String
        let data: String
        let idHistorico: Int
        let estado: Int
    }
    
    struct WSReturnConcluir: Encodable, Decodable {
        let edit: Bool
    }
    
    struct WSInputConcluir: Encodable, Decodable {
        let estado: Int
    }
    
    var listHistorico:[list] = []
    
    struct WSReturnProposta: Encodable, Decodable {
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
    
    struct WSInputPropEdit: Encodable, Decodable {
        let estado: Int
    }
    
    struct WSResultProp: Decodable, Encodable {
        let edit: Bool
        let prop: [WSProposta]
    }
    
    // --
    // End Var
    
    // Outlets
    // --
    
    @IBOutlet weak var tableViagem: UITableView!
    
    // --
    // End Outlets
    
    // Functions
    // --
    
    //MARK UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listHistorico.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = listHistorico[indexPath.row].origemDestino
        cell.detailTextLabel?.text = listHistorico[indexPath.row].data
        return cell
    }
    
    //MARK UITableViewDelegate
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editar = UITableViewRowAction(style: .default, title: "Detalhes"){action, index in
            Global.idHistorico = self.listHistorico[index.row].idHistorico
            self.performSegue(withIdentifier: "segueHistoricoDetalhe", sender: self)
        }
        editar.backgroundColor = UIColor.blue
        let concluir = UITableViewRowAction(style: .default, title: "Concluir"){action, index in
            let editViagem = WSInputConcluir(estado: 0)
            
            self.ConcluirViagem(editViagem: editViagem, idViagem: self.listHistorico[indexPath.row].idHistorico)
            print("edit Viagem")
            
        }
        concluir.backgroundColor = UIColor.orange
        
        if self.listHistorico[indexPath.row].estado == 1 || self.listHistorico[indexPath.row].estado == 2 {
        return [editar, concluir]
        } else {
            return [editar]
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
    private func loadViagens(){
        let urlString = "http://davidmatos.pt/slimIOS/index.php/viagemByIdUser/" + String(Global.idUser)
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
                        let aux = list(origemDestino: "de: " + viagem.origemNome + " para: " + viagem.destinoNome, data: viagem.dataViagem, idHistorico: Int(viagem.idViagem)!, estado: Int(viagem.estado)!)
                        self.listHistorico.append(aux)
                        self.tableViagem.reloadData()
                    }
                }
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
    }
    
    private func loadPropostas(idViagem: Int){
        let urlString = "http://davidmatos.pt/slimIOS/index.php/propostasByIdViagem/" + String(idViagem)
        print("load propostas", idViagem)
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode(WSReturnProposta.self, from: data)
                DispatchQueue.main.async {
                    for proposta in response.result{
                        print("entrou proposta")
                        if proposta.idProposta != "-1" {
                            self.listHistorico = []
                            let aux = WSInputPropEdit(estado: 3)
                            self.deleteProposta(prop: aux, idProposta: Int(proposta.idProposta)!)
                        } else {
                            self.reloadTable()
                        }
                    }
                }
            } catch let jsonError {
                print(jsonError)
                print("josnError")
            }
            
            }.resume()
    }
    
    private func reloadTable(){
        self.listHistorico = []
        self.loadViagens()
        self.tableViagem.reloadData()
    }
    
    var aux: Bool = true
    
    private func deleteProposta(prop: WSInputPropEdit, idProposta: Int){
        var request = URLRequest(url: URL(string: "http://davidmatos.pt/slimIOS/index.php/proposta/edit/" + String(idProposta))!)
        print("delete proposta", idProposta)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonBody = try JSONEncoder().encode(prop)
            request.httpBody = jsonBody
            let jsonBodyString = String(data: jsonBody, encoding: .utf8)
        } catch {
            print("error")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            guard error == nil else {
                print(error!, "error task")
                return
            }
            guard let data = data else {
                print("data is empty")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(WSResultProp.self, from: data)
                DispatchQueue.main.async {
                    if(response.edit){
                        if self.aux {
                            self.reloadTable()
                            self.aux = !self.aux
                        }
                    }
                }
            } catch let jsonError {
                print(jsonError)
            }
        }
        task.resume()
    }
    
    private func ConcluirViagem(editViagem: WSInputConcluir, idViagem: Int){
        print("id Viagem", idViagem)
        var request = URLRequest(url: URL(string: "http://davidmatos.pt/slimIOS/index.php/viagem/concluir/" + String(idViagem))!)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            print(editViagem)
            let jsonBody = try JSONEncoder().encode(editViagem)
            request.httpBody = jsonBody
            print("concluir Viagem")
            //let jsonBodyString = String(data: jsonBody, encoding: .utf8)
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
                let response = try JSONDecoder().decode(WSReturnConcluir.self, from: data)
                DispatchQueue.main.async {
                    if response.edit {
                        self.loadPropostas(idViagem: idViagem)
                    }else{
                        print("erro edit viagem")
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
