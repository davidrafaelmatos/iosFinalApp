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
    

    // Outlets
    // --
    
    
    
    
    // --
    // End Outlets
    
    // -- PickerView Make
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return makeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return makeArray[row].Make_Name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //lblTest.text = makeArray[row].Make_Name
    }
    
    // -- End PickerView Make
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        let urlString = "https://vpic.nhtsa.dot.gov/api/vehicles/getallmakes?format=json"
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
                    print(self.makeArray)
                }
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
        
    }
    
    func load() {
        
    }
    
    // import all models by Make_ID
    // - https://vpic.nhtsa.dot.gov/api/vehicles/GetModelsForMakeId/440?format=json
    
    // --
    // End WS
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
