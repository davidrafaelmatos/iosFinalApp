//
//  DBViagensViewController.swift
//  iosFinalApp
//
//  Created by DocAdmin on 6/10/18.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import UIKit

class DBViagensViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Outlets
    // --
    
    @IBOutlet weak var txtOrigem: UITextField!
    @IBOutlet weak var txtDestino: UITextField!
    
    // --
    // End Outlets
    
    // Actions
    // --
    
    @IBAction func btnSegue(_ sender: Any) {
        
        if(txtOrigem.text!.isEmpty || txtDestino.text!.isEmpty){
            // error message
            displayMessage("Todos os campos tem que estar preenchidos", type: 1)
        } else {
            Global.origemDBViagem = txtOrigem.text!
            Global.destinoDBViagem = txtDestino.text!
            displayMessage("A Calcular o percurso", type: 0)
        }
        
    }
    
    // --
    // End Actions
    
    // Functions
    // --
    
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
    
    // --
    // End Functions

}
