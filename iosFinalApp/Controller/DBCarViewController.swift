//
//  DBCarViewController.swift
//  iosFinalApp
//
//  Created by DocAdmin on 6/9/18.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import UIKit

class DBCarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // Var
    // --
    
    struct lista {
        let makeModel: String
        let consumoCombustivel: String
        let id: Int
    }
    
    var listaCarros: [lista] = []
    
    // --
    // Var
    
    // Outlets
    // --
    
    @IBOutlet weak var tableCarros: UITableView!
    @IBOutlet weak var constPainel: NSLayoutConstraint!
    @IBOutlet weak var contLat: NSLayoutConstraint!
    
    // --
    // End Outlets
    
    // Actions
    // --
    
    @IBAction func btnNewCar(_ sender: Any) {
        self.performSegue(withIdentifier: "segueNewCar", sender: self)
    }
    
    // --
    // End Actions
    override func viewDidLoad() {
        super.viewDidLoad()
        constPainel.constant = -200
        contLat.constant = -200
        loadCars()
        // Do any additional setup after loading the view.
    }
    
    // Functions
    // --
    
    //MARK UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaCarros.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = listaCarros[indexPath.row].makeModel
        cell.detailTextLabel?.text = listaCarros[indexPath.row].consumoCombustivel
        
        return cell
    }
    
    //MARK UITableViewDelegate
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editar = UITableViewRowAction(style: .default, title: "Editar"){action, index in
            Global.idCar = self.listaCarros[index.row].id
            self.performSegue(withIdentifier: "segueEditCar", sender: self)
        }
        editar.backgroundColor = UIColor.blue
        let delete = UITableViewRowAction(style: .default, title: "Apagar"){action, index in
            self.deleteCar(idCar: self.listaCarros[index.row].id, index: index.row)
        }
        delete.backgroundColor = UIColor.red
        return [editar, delete]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
    }
    
    private func loadCars(){
        print(Global.idUser)
        let urlString = "http://davidmatos.pt/slimIOS/index.php/carroByIdUser/" + String(Global.idUser)
        print(urlString)
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(WSReturnCarByIdUser.self, from: data)
                DispatchQueue.main.async {
                    var valComb:String
                    for car in response.Result {
                        switch Int(car.combustivel){
                        case 0:
                            valComb = "Gasolina"
                        case 1:
                            valComb = "Gasoleo"
                        default:
                            valComb = "Eletrico"
                        }
                        let aux = lista(makeModel: (car.marca + " " + car.modelo), consumoCombustivel: String(car.consumo) + " " + valComb, id: Int(car.idCar)!)
                        self.listaCarros.append(aux)
                    }
                    print(self.listaCarros)
                    self.tableCarros.reloadData()
                    print("-----------------fsdfsdf--------------")
                }
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
    }
    
    private func deleteCar(idCar:Int, index:Int){
        let urlString: String = "http://davidmatos.pt/slimIOS/index.php/carro/delete/" + String(idCar)
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(WSReturnDeleteCar.self, from: data)
                DispatchQueue.main.async {
                    print(response.mensagem)
                    self.listaCarros.remove(at: index)
                    self.tableCarros.reloadData()
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
