//
//  ShowViewController.swift
//  playsound
//
//  Created by SSPRL on 8/16/19.
//  Copyright © 2019 SSPRL. All rights reserved.
//

import UIKit

class ShowViewController: UIViewController {
    var result : String = "Please, Wait a moment!"
    @IBAction func mainWindow(_ sender: Any) {
        
        performSegue(withIdentifier: "toMainView2", sender: self)
    }
    
    
    @IBAction func back(_ sender: Any) {
        
        
         performSegue(withIdentifier: "toTableView", sender: self)
    }
    
    
    
    @IBOutlet var show: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
