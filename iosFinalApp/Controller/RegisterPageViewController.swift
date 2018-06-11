 //
//  RegisterPageViewController.swift
//  iosFinalApp
//
//  Created by Hugo Silva on 09/06/2018.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import UIKit

class RegisterPageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
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
        
        //Verifications
        if( txtNome.text!.isEmpty || txtUsername.text!.isEmpty || txtEmail.text!.isEmpty || txtPassword.text!.isEmpty || txtRepeatPassword.text!.isEmpty) {
            // Error Message
            displayMessage("Todos os campos tem de estar preenchidos", type: 1);
            return;
        } else {
            
            if(txtPassword.text! != txtRepeatPassword.text!) {
                // Error Message
                displayMessage("As Palavras Chaves não são iguais", type: 1)
                return;
            }
            addUser()
        }
    }
    
    // --
    // End Actions
    
    // Functions
    // --
    
    private func displayMessage(_ mensagem: String, type: Int) {

        
        if ( type == 1) {
            let alerta = UIAlertController(title: "Alerta", message: mensagem, preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alerta.addAction(okAction)
            self.present(alerta, animated: true, completion: nil)
        } else {
            let alerta = UIAlertController(title: "Bem Vindo", message: mensagem, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default){
                (action) in
                self.performSegue(withIdentifier: "segueMain", sender: self)
            }
            
            alerta.addAction(okAction)
            self.present(alerta, animated: true, completion: nil)
        }
    }
    
    private func addUser(){
        var request = URLRequest(url: URL(string: "http://davidmatos.pt/slimIOS/index.php/user/new")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let dados = User(username: txtUsername.text!, password: txtPassword.text!, nome: txtNome.text!, email: txtEmail.text!, estado: 1)
            print(dados)
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
                let response = try JSONDecoder().decode( WSReturnRegistar.self, from: data)
                DispatchQueue.main.async {
                    if(response.Add){
                        Global.idUser = response.id
                        Global.nomeUser = self.txtNome.text!
                        self.displayMessage("O seu registo foi comcluido com sucesso", type: 0)
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
    // End Functions

}
