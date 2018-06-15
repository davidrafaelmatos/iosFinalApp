//
//  DBMainViewController.swift
//  iosFinalApp
//
//  Created by DocAdmin on 6/9/18.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import UIKit

class QBMainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        blurView.layer.cornerRadius = 15
        sideView.layer.shadowColor = UIColor.black.cgColor
        sideView.layer.shadowOpacity = 0.8
        sideView.layer.shadowOffset = CGSize(width: 5, height: 0)
        
        // Do any additional setup after loading the view.
    }
    
    // Var
    // --
    var isSideViewHidden = true
    
    // --
    // End Var
    
    // Outlets
    // --
    
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var sideViewConstrain: NSLayoutConstraint!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    // --
    // End Outlets
    
    // Actions
    // --
    
    @IBAction func btnSideBar(_ sender: Any) {
        if isSideViewHidden {
            sideViewConstrain.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            sideViewConstrain.constant = -200
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
        isSideViewHidden = !isSideViewHidden
    }
    
    @IBAction func PanPerformed(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            
            let translation = sender.translation(in: self.view).x
            if translation > 0 { // swipe right
                sideViewConstrain.constant = 0
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                })
            } else { // swipe left
                sideViewConstrain.constant = -200
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
        isSideViewHidden = !isSideViewHidden
    }

    // --
    // Actions
    
}
