//
//  QBNewCarViewController.swift
//  iosFinalApp
//
//  Created by DocAdmin on 6/9/18.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import UIKit

class DBCarNewViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var makeArray = [Make]()
    var modelArray = [Model]()
    var make: String = ""
    var makeId: Int = -1
    var model: String = ""
    var modelId: Int = -1
    var tipoCombustivel: Int = 0
    

    // Outlets
    // --
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var txtComsumos: UITextField!
    
    // --
    // End Outlets
    
    // Actions
    // --
    
    @IBAction func btnCombustivel(_ sender: UISegmentedControl) {
        
        switch (sender.selectedSegmentIndex) {
        case 0:
            tipoCombustivel = 0
        case 1:
            tipoCombustivel = 1
        default:
            tipoCombustivel = 2
        }
        
    }
    
    @IBAction func btnGuardar(_ sender: Any) {
        
        if (make.isEmpty || model.isEmpty || txtComsumos.text!.isEmpty){
            displayMessage("Tem que preencher todos os campos", type: 1)
        } else {
            let carro = WSInputCar(marca: make, modelo: model, combustivel: tipoCombustivel, consumo: Double(txtComsumos.text!)!, fkUser: Global.idUser, estado: 1)
            addCar(car: carro)
        }

    }
    
    // --
    // Actions
    
    // -- PickerView Make
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return makeArray.count
        } else {
            return modelArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return makeArray[row].MakeName
        }else{
            return modelArray[row].Model_Name
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            make = makeArray[row].MakeName
            makeId = makeArray[row].MakeId
            loadModel()
        }else{
            model = modelArray[row].Model_Name
            modelId = modelArray[row].Model_ID
        }
    }
    
    // -- End PickerView Make
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // Do any additional setup after loading the view.
        loadMake()
    }
    
    // WS
    // --
    // import all Makes
    // - https://vpic.nhtsa.dot.gov/api/vehicles/getallmakes?format=json
    
    func loadMake() {
        let urlString = "https://vpic.nhtsa.dot.gov/api/vehicles/GetMakesForVehicleType/car?format=json"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(MakeReturn.self, from: data)
                DispatchQueue.main.async {
                    self.makeArray = response.Results
                    self.pickerView.reloadAllComponents()
                    print(self.makeArray)
                }
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
        pickerView.reloadComponent(0)
    }
    
    
    // import all models by Make_ID
    // - https://vpic.nhtsa.dot.gov/api/vehicles/GetModelsForMakeId/440?format=json
    
    func loadModel() {
        let urlString = "https://vpic.nhtsa.dot.gov/api/vehicles/getmodelsformake/" + make + "?format=json"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(ModelReturn.self, from: data)
                DispatchQueue.main.async {
                    self.modelArray = response.Results
                    self.pickerView.reloadComponent(1)
                    print(self.modelArray)
                }
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
        pickerView.reloadComponent(0)
    }
    
    private func addCar(car: WSInputCar){
        var request = URLRequest(url: URL(string: "http://davidmatos.pt/slimIOS/index.php/carro/new")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let jsonBody = try JSONEncoder().encode(car)
            request.httpBody = jsonBody
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
                let response = try JSONDecoder().decode( WSReturnCarNew.self, from: data)
                DispatchQueue.main.async {
                    if(response.Post){
                        self.displayMessage("O seu carro foi adicionado com sucesso", type: 0)
                    } else {
                        self.displayMessage("Os dados inseridos estao incorretos", type: 1)
                    }
                }
            } catch let jsonError {
                print(jsonError)
            }
        }
        task.resume()
    }
    
    
    // --
    // End WS
    
    private func displayMessage(_ mensagem: String, type: Int) {
        
        // 0 to Success
        // 1 to Error
        
        if ( type == 1) {
            let alerta = UIAlertController(title: "Alerta", message: mensagem, preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alerta.addAction(okAction)
            self.present(alerta, animated: true, completion: nil)
        } else {
            let alerta = UIAlertController(title: "Bem Vindo", message: mensagem, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default){
                (action) in
                //self.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "segueCarro", sender: self)
            }
            
            alerta.addAction(okAction)
            self.present(alerta, animated: true, completion: nil)
        }
    }

}
