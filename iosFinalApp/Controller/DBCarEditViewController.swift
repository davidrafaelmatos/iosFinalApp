//
//  DBCarEditViewController.swift
//  iosFinalApp
//
//  Created by DocAdmin on 6/10/18.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import UIKit

class DBCarEditViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        LoadData()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    // Variables
    // --
    var make: String = ""
    var model: String = ""
    var combustiveis: Int = -1
    var comsumos: Double = -1
    
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
    
    // Actions
    // --
    
    @IBAction func btnGuardar(_ sender: Any) {
        
        if(txtComsumos.text!.isEmpty){
            // Error message
            displayMessage("Todos os campos tem que estar preenchidos", type: 1)
            
        } else {
            comsumos = Double(txtComsumos.text!)!
            let car = Car(Marca: make, Modelo: model, TipoCombustivel: combustiveis, Comsumos: comsumos, fkUser: 1, estado: 1)

            print(car)
            displayMessage("O carro foi editado com sucesso", type: 0)
            
        }
    }
    
    @IBAction func btnCombustivel(_ sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
        case 0:
            combustiveis = 0
        case 1:
            combustiveis = 1
        default:
            combustiveis = 2
        }
    }
    // --
    // End Actions

    // functions
    // --
    
    private func LoadData(){
        // WS
        
        make = "bmw"
        model = "320d"
        combustiveis = 1
        comsumos = 12.1
        
        btnCombustivel.selectedSegmentIndex = combustiveis
        txtComsumos.text = String(comsumos)
        
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
            let alerta = UIAlertController(title: "Bem Vindo", message: mensagem, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default){
                (action) in
                self.performSegue(withIdentifier: "segueCarroMain", sender: self)
            }
            
            alerta.addAction(okAction)
            self.present(alerta, animated: true, completion: nil)
        }
    }

    
    // --
    // End functions
    
}
