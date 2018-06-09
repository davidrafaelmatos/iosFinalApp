//
//  ViewController.swift
//  iosFinalApp
//
//  Created by DocAdmin on 6/8/18.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Outlets
    // --
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var swRemenber: UISwitch!
    
    // --
    // End Outlets
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Action
    // --
    
    @IBAction func btnLogin(_ sender: Any) {
        
        // Get Data
        let username = txtUsername.text!
        let password = txtPassword.text!
        
        // Validations
        if ( username.isEmpty || password.isEmpty) {
            //Error Message
            displayMessage("Os campos tem que estar todos preenchidos")
        } else {
            
            if(username == "admin" && password == "12345") {
                //Login Success
                self.performSegue(withIdentifier: "segueMain", sender: self)
            } else {
                //Error Message
                displayMessage("Os dados inseridos estao incorretos")
            }
            
        }
        
    }
    
    private func displayMessage(_ mensagem: String) {
        
        
        
            let alerta = UIAlertController(title: "Alerta", message: mensagem, preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alerta.addAction(okAction)
            self.present(alerta, animated: true, completion: nil)
    
    }
    
    // --
    // End Action

}

