//
//  HistoricoDetalheViewController.swift
//  iosFinalApp
//
//  Created by DocAdmin on 6/10/18.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import UIKit

class DBHistoricoDetalheViewController: UIViewController, UITableViewDataSource {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        loadViagemDetalhe()
        // Do any additional setup after loading the view.
    }
    
    // Var
    // --
    
    struct WSReturnResult: Encodable, Decodable{
        let Origem: String
        let Destino: String
        let Carro: String
        let Boleia: [WSReturnUser]
    }
    
    struct WSReturnUser: Decodable, Encodable {
        let nome: String
        let estadoPagamento: Int
    }
    
    var listNomes:[WSReturnUser] = []
    
    // --
    // Var
    
    // Outlets
    // --
    
    @IBOutlet weak var lblOrigem: UITextView!
    @IBOutlet weak var lblDestino: UITextView!
    @IBOutlet weak var lblCarro: UILabel!
    @IBOutlet weak var tableNome: UITableView!
    
    // --
    // End Outlets
    
    // Actions
    // --
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNomes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = listNomes[indexPath.row].nome
        return cell
    }
    
    
    // --
    // End Actions
    
    // Functions
    // --
    
    private func loadViagemDetalhe(){
        let urlString = "http://davidmatos.pt/slimIOS/index.php/viagemDetalhe/" + String(Global.idHistorico)
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode(WSReturnResult.self, from: data)
                DispatchQueue.main.async {
                        for boleia in response.Boleia{
                            let aux = WSReturnUser(nome: boleia.nome, estadoPagamento: boleia.estadoPagamento)
                            self.listNomes.append(aux)
                            self.tableNome.reloadData()
                        }
                        self.lblCarro.text = response.Carro
                        self.lblOrigem.text = response.Origem
                        self.lblDestino.text = response.Destino
                    }
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
    }
    
    // --
    // End Functions
    
    
}
