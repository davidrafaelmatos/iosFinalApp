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
    

    // Outlets
    // --
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var txtComsumos: UITextField!
    
    // --
    // End Outlets
    
    // Actions
    // --
    
    @IBAction func btnCombustivel(_ sender: Any) {
    }
    
    @IBAction func btnGuardar(_ sender: Any) {
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    // --
    // End WS
    

}
