//
//  DBViagensViewController.swift
//  iosFinalApp
//
//  Created by DocAdmin on 6/10/18.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import UIKit

class DBViagensViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtNumLugares.delegate = self
        loadCars()
        // Do any additional setup after loading the view.
    }
    
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
    
    @IBOutlet weak var txtOrigem: UITextField!
    @IBOutlet weak var txtDestino: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var txtNumLugares: UITextField!
    
    // --
    // End Outlets
    
    // Actions
    // --
    
    // -- PickerView Make
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listaCarros.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listaCarros[row].makeModel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        Global.idCar = listaCarros[row].id
    }
    
    // -- End PickerView Make
    
    @IBAction func btnSegue(_ sender: Any) {
        
        if(txtOrigem.text!.isEmpty || txtDestino.text!.isEmpty || txtNumLugares.text!.isEmpty){
            // error message
            displayMessage("Todos os campos tem que estar preenchidos", type: 1)
        } else {
            Global.origemDBViagem = txtOrigem.text!
            Global.destinoDBViagem = txtDestino.text!
            Global.numLugares = Int(txtNumLugares.text!)!
            displayMessage("A Calcular o percurso", type: 0)
        }
        
    }
    
    // --
    // End Actions
    
    // Functions
    // --
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let allowedCharacters = CharacterSet.init(charactersIn: "0123456789")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
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
            let alerta = UIAlertController(title: "Quase Completo", message: mensagem, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default){
                (action) in
                self.performSegue(withIdentifier: "segueViagem", sender: self)
            }
            
            alerta.addAction(okAction)
            self.present(alerta, animated: true, completion: nil)
        }
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
                    self.pickerView.reloadAllComponents()
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
