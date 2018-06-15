//
//  MainViewController.swift
//  iosFinalApp
//
//  Created by DocAdmin on 6/9/18.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        blurDB.layer.cornerRadius = 15
        btnDB.layer.shadowColor = UIColor.black.cgColor
        btnDB.layer.shadowOpacity = 0.8
        btnDB.layer.shadowOffset = CGSize(width: 5, height: 0)
        
        blurDB.layer.cornerRadius = 15
        btnQB.layer.shadowColor = UIColor.black.cgColor
        btnQB.layer.shadowOpacity = 0.8
        btnQB.layer.shadowOffset = CGSize(width: 5, height: 0)
        
    }
    
    // Outlets
    // --
    
    @IBOutlet weak var blurQB: UIVisualEffectView!
    @IBOutlet weak var btnQB: UIView!
    @IBOutlet weak var blurDB: UIVisualEffectView!
    @IBOutlet weak var btnDB: UIView!
    
    // --
    // End Outlets
    
    
}
