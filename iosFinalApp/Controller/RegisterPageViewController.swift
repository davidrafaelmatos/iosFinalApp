 //
//  RegisterPageViewController.swift
//  iosFinalApp
//
//  Created by Hugo Silva on 09/06/2018.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import UIKit

class RegisterPageViewController: UIViewController {

    // Outlets
    // --
    
    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtRepeatPassword: UITextField!
    
    
    // --
    // End Outlets
    
    // Actions
    // --
    
    @IBAction func btnRegistar(_ sender: Any) {
        
        // GetData
        let nome = txtNome.text!
        let username = txtUsername.text!
        let email = txtEmail.text!
        let pass = txtPassword.text!
        let repPass = txtRepeatPassword.text!
        
        //Verifications
        if( nome.isEmpty || username.isEmpty || email.isEmpty || pass.isEmpty || repPass.isEmpty) {
            // Error Message
            displayMessage("Todos os campos tem de estar preenchidos", type: 1);
            return;
        } else {
            
            if(pass != repPass) {
                // Error Message
                displayMessage("As Palavras Chaves não são iguais", type: 1)
                return;
            }
            
            //Store Data
            
            //Success Message
            displayMessage("Registo Concluido com Sucesso", type: 0)
            // url video PKOswUE731c
        }
    }
    
    private func displayMessage(_ mensagem: String, type: Int) {
        
        // 0 to Success
        // 1 to Error
        
        if ( type == 1) {
            var alerta = UIAlertController(title: "Alerta", message: mensagem, preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alerta.addAction(okAction)
            self.present(alerta, animated: true, completion: nil)
        } else {
            var alerta = UIAlertController(title: "Bem Vindo", message: mensagem, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default){
                (action) in
                self.dismiss(animated: true, completion: nil)
            }
            
            alerta.addAction(okAction)
            self.present(alerta, animated: true, completion: nil)
        }
    }
    
    // --
    // End Actions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
