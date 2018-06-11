//
//  ViewController.swift
//  iosFinalApp
//
//  Created by DocAdmin on 6/8/18.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Var
    // --
    
    var result: Bool = false;
    
    // --
    // End Var
    
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

        // Validations
        if ( txtUsername.text!.isEmpty || txtPassword.text!.isEmpty) {
            //Error Message
            displayMessage("Os campos tem que estar todos preenchidos")
        } else {
            validLogin(username: txtUsername.text!, password: txtPassword.text!)
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

    // Functions
    // --
    
    private func validLogin(username: String, password:String){
        var request = URLRequest(url: URL(string: "http://davidmatos.pt/slimIOS/index.php/user/login")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let dados = WSInputLogin(username: username, password: password)
            let jsonBody = try JSONEncoder().encode(dados)
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
                let response = try JSONDecoder().decode( WSReturnLogin.self, from: data)
                DispatchQueue.main.async {
                    if(response.Login){
                        Global.idUser = response.id
                        Global.nomeUser = response.nome
                        self.performSegue(withIdentifier: "segueMain", sender: self)
                    } else {
                        self.displayMessage("Os dados inseridos estao incorretos")
                    }
                }
            } catch let jsonError {
                print(jsonError)
            }
        }
        task.resume()
    }
    
    // --
    // End Functions
    
}

