//
//  DBCarEditViewController.swift
//  iosFinalApp
//
//  Created by DocAdmin on 6/10/18.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import UIKit

class DBCarEditViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        self.txtComsumos.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    
    
    // Variables
    // --
    var make: String = ""
    var model: String = ""
    // --
    // End Variables
    
    // Outlets
    // --
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var btnCombustivel: UISegmentedControl!
    @IBOutlet weak var txtComsumos: UITextField!
    
    // --
    // End Outlets
    
    // -- PickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return make
        }else{
            return model
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //
    }
    
    // -- End PickerView
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let allowedCharacters = CharacterSet.init(charactersIn: "0123456789")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    // Actions
    // --
    
    @IBAction func btnGuardar(_ sender: Any) {
        
        if(txtComsumos.text!.isEmpty){
            // Error message
            displayMessage("Todos os campos tem que estar preenchidos", type: 1)
            
        } else {
            
            let carro = WSInputCarEdit(combustivel: btnCombustivel.selectedSegmentIndex, consumo: Double(txtComsumos.text!)!)
            editCar(car: carro)
        }
    }
    
    @IBAction func btnCombustivel(_ sender: UISegmentedControl) {
        /*switch (sender.selectedSegmentIndex) {
        case 0:
            //combustiveis = 0
        case 1:
           // combustiveis = 1
        default:
           // combustiveis = 2
        }*/
    }
    // --
    // End Actions

    // functions
    // --
    
    private func loadData(){
        print(Global.idUser)
        let urlString = "http://davidmatos.pt/slimIOS/index.php/carro/" + String(Global.idCar)
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
                    for car in response.Result{
                        self.make = car.marca
                        self.model = car.modelo
                        self.btnCombustivel.selectedSegmentIndex = Int(car.combustivel)!
                        self.txtComsumos.text = car.consumo
                        self.pickerView.reloadAllComponents()
                    }
                }
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
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
            let alerta = UIAlertController(title: "Editar", message: mensagem, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default){
                (action) in
                self.performSegue(withIdentifier: "segueCarroMain", sender: self)
            }
            
            alerta.addAction(okAction)
            self.present(alerta, animated: true, completion: nil)
        }
    }
    
    private func editCar(car: WSInputCarEdit){
        var request = URLRequest(url: URL(string: "http://davidmatos.pt/slimIOS/index.php/carro/edit/" + String(Global.idCar))!)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonBody = try JSONEncoder().encode(car)
            request.httpBody = jsonBody
            let jsonBodyString = String(data: jsonBody, encoding: .utf8)
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
                let response = try JSONDecoder().decode(WSReturnCarEdit.self, from: data)
                DispatchQueue.main.async {
                    if(response.edit){
                        self.displayMessage("O seu carro foi editado com sucesso", type: 0)
                    } else {
                        self.displayMessage("Ocoreu um erro durante a alteração do carro", type: 1)
                    }
                }
            } catch let jsonError {
                print(jsonError)
            }
        }
        task.resume()
    }

    
    // --
    // End functions
    
}
