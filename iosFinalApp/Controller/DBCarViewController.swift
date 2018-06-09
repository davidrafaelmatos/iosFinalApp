//
//  DBCarViewController.swift
//  iosFinalApp
//
//  Created by DocAdmin on 6/9/18.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import UIKit

class DBCarViewController: UIViewController {

    // Outlets
    // --
    
    @IBOutlet weak var btnNewCar: UIButton!
    
    // --
    // End Outlets
    
    // Actions
    // --
    
    @IBAction func btnNewCar(_ sender: Any) {
        
        self.performSegue(withIdentifier: "segueNewCar", sender: self)
        
        
    }
    
    // --
    // End Actions
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }

}
