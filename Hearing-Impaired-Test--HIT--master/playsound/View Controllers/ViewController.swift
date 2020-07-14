//
//  ViewController.swift
//  playsound
//
//  Created by SSPRL on 8/5/19.
//  Copyright © 2019 SSPRL. All rights reserved.
//

import UIKit
import AVFoundation




class ViewController: UIViewController
{
    var userName: String = ""
    override func viewDidLoad()
    {
        super.viewDidLoad()
        definesPresentationContext = true
        
       
    }
    
    
    @IBAction func testResult(_ sender: Any) {
        performSegue(withIdentifier: "toTestResult", sender: self)
    }
    
   
    
    
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var user_name: UITextField!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "toFirstView" {
        let fistviewcontroller = segue.destination as! FirstViewController
        fistviewcontroller.userName = user_name.text!
        }
        else
        {
            let testResultviewcontroller = segue.destination as! TestResultViewController
            testResultviewcontroller.user = user_name.text!
            
        }
    }
    
    
    @IBAction func submit(_ sender: Any)
    {
        
    performSegue(withIdentifier: "toFirstView", sender: self)
        
    
        
    }
    
    

}

