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
    
    var listaCarros: [String] = []
    
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
        cell.textLabel?.text = listaCarros[indexPath.row]
        cell.detailTextLabel?.text = "info Adicional"
        
        return cell
    }
    
    //MARK UITableViewDelegate
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editar = UITableViewRowAction(style: .default, title: "Editar"){action, index in
            print("editar: " + String(index.row) + " " + self.listaCarros[index.row])
        }
        editar.backgroundColor = UIColor.blue
        let delete = UITableViewRowAction(style: .default, title: "Apagar"){action, index in
            print("apagar: " + String(index.row))
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
                    for car in response.Result {
                        let aux = car.marca + " " + car.modelo
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
    
    // --
    // End Functions

}
