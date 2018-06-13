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
    }
    
    var listHistorico:[list] = []
    
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
        let editar = UITableViewRowAction(style: .default, title: "Editar"){action, index in
            Global.idHistorico = self.listHistorico[index.row].idHistorico
            self.performSegue(withIdentifier: "segueHistoricoDetalhe", sender: self)
        }
        editar.backgroundColor = UIColor.blue

        return [editar]
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
                        let aux = list(origemDestino: "de: " + viagem.origemNome + " para: " + viagem.destinoNome, data: viagem.dataViagem, idHistorico: Int(viagem.idViagem)!)
                        self.listHistorico.append(aux)
                        self.tableViagem.reloadData()
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
