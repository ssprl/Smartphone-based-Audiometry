//
//  FirstViewController.swift
//  playsound
//
//  Created by SSPRL on 8/7/19.
//  Copyright © 2019 SSPRL. All rights reserved.
//

import UIKit
import AVFoundation


class FirstViewController: UIViewController
{
    var userName:String = ""
    var selectedEar: Int = -1
    
    
    @IBOutlet var greetName: UILabel!
    @IBOutlet var greet: UILabel!
    
    @IBOutlet var segmentedContol: UISegmentedControl!
    
    
    @IBAction func earSelect(_ sender: UISegmentedControl) {
        switch segmentedContol.selectedSegmentIndex
        {
        case 0:
            selectedEar = -1
            
        case 1:
            selectedEar = 1
            
        default:
            selectedEar = -1
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let testviewcontroller = segue.destination as! TestViewController
        testviewcontroller.ear =  selectedEar
        testviewcontroller.user = userName
    }
    
    
    @IBAction func startTest(_ sender: Any) {
        VolumeAlert();
        

    }
    
    @IBOutlet var Instructions: UILabel!
    @IBOutlet var InstructionText1: UITextView!
    @IBOutlet var InstructionTest2: UITextView!
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        greet.text = "On which ear, you would like to test your hearing?"
        greetName.text = "Hi " + userName + ","
        definesPresentationContext = true
        
        
        
    }
    
    func isHeadphonesConnected() -> Bool{
        let routes = AVAudioSession.sharedInstance().currentRoute
        return routes.outputs.contains(where: { (port) -> Bool in
            port.portType == AVAudioSession.Port.headphones
        })
    }

    
    func VolumeAlert(){
           let alert = UIAlertController(title: "Set Volume to Maximum and connect to Wi-Fi!", message: "Your test resuls dependes on the volume of the cell phone. You must set your volume level to maximum to have correct results Also to save your results, please connect the phone to internet connection. ", preferredStyle: .actionSheet)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            self.performSegue(withIdentifier: "toTestView", sender: self)
           }))
        
           self.present(alert, animated: true, completion: {
               print("completion block")
           })
    }
}
