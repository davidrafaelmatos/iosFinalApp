//
//  DBPropostasViewController.swift
//  iosFinalApp
//
//  Created by DocAdmin on 6/10/18.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import UIKit

class DBPropostasViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadPropostas()
        // Do any additional setup after loading the view.
    }

    // Var
    // --
    
    struct listProp {
        let nome: String
        let origem: String
        let id: Int
    }
    
    struct WSResult: Encodable, Decodable {
        let get: Bool
        let result: [WSPropostas]
    }
    
    struct WSPropostas: Encodable, Decodable {
        let idProposta: String
        let fkViagem: String
        let fkUser: String
        let estado: String
        let origemNome: String
        let origemCoordLat: String
        let origemCoordLong: String
    }
    
    struct WSUser: Decodable, Encodable {
        let idUser: String
        let username: String
        let password: String
        let nome: String
        let email: String
        let estado: String
    }
    
    var arrayProp: [listProp] = []
    
    // --
    // End Var
    
    // Outlets
    // --
    
    @IBOutlet weak var tableProposta: UITableView!
    
    // --
    // Outlets
    
    // Actions
    // --
    
    
    // --
    // End Actions
    
    // Functions
    // --
    
    //MARK UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayProp.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = arrayProp[indexPath.row].nome
        cell.detailTextLabel?.text = arrayProp[indexPath.row].origem
        return cell
    }
    
    //MARK UITableViewDelegate
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editar = UITableViewRowAction(style: .default, title: "Detalhes"){action, index in
            Global.idProposta = self.arrayProp[index.row].id
            self.performSegue(withIdentifier: "seguePropostaDetalhe", sender: self)
        }
        editar.backgroundColor = UIColor.blue
        
        return [editar]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
    private func loadPropostas(){
        let urlString = "http://davidmatos.pt/slimIOS/index.php/propostasByIdUserDB/" + String(Global.idUser)
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode(WSResult.self, from: data)
                DispatchQueue.main.async {
                    for proposta in response.result{
                        print("proposta", proposta)
                        //-----------------------------------------------------------------
                        //-----------------------------------------------------------------
                        let urlString = "http://davidmatos.pt/slimIOS/index.php/user/" + proposta.fkUser
                        guard let url = URL(string: urlString) else { return }
                        URLSession.shared.dataTask(with: url) {
                            (data, response, error) in
                            if error != nil {
                                print(error!.localizedDescription)
                            }
                            guard let data = data else { return }
                            do {
                                let response = try JSONDecoder().decode([WSUser].self, from: data)
                                DispatchQueue.main.async {
                                    for user in response{
                                        let aux = listProp(nome: user.nome, origem: proposta.origemNome, id: Int(proposta.idProposta)!)
                                        self.arrayProp.append(aux)
                                        self.tableProposta.reloadData()
                                    }
                                }
                            } catch let jsonError {
                                print(jsonError)
                            }
                            
                            }.resume()
                        //-----------------------------------------------------------------
                        //-----------------------------------------------------------------
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
