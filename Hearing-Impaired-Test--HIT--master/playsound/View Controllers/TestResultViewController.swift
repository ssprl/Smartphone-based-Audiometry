//
//  TestResultViewController.swift
//  playsound
//
//  Created by SSPRL on 8/16/19.
//  Copyright © 2019 SSPRL. All rights reserved.
//

import UIKit
import Firebase


class TestResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var user : String = ""
    var list: [String] = []//["Bread", "Tomato", "Milk", "Butter"]
    var myIndex = 0
    var handle : DatabaseHandle?
    var ref : DatabaseReference?
    var ref_pressed : DatabaseReference?
    var freq : [String] = ["250 Hz","500 Hz", "1000 Hz", "2000 Hz", "4000 Hz", "8000 Hz"];
    var string : String = ""
    
    @IBAction func Back(_ sender: Any) {
        
         performSegue(withIdentifier: "toMainView", sender: self)
    }
    @IBOutlet var myTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = list[indexPath.row]
        return (cell)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
       
        performSegue(withIdentifier: "toShowView", sender: self)
        
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       if (segue.identifier == "toShowView")
       {
        let showviewcontroller = segue.destination as! ShowViewController
       
        ref_pressed = ref?.child(list[myIndex])
        ref_pressed?.observe(.childAdded, with: { (Audiogram) in
            
         showviewcontroller.show.text += Audiogram.description + "\n \n"
        })
        }
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference().child("list")
        handle = ref?.observe(.childAdded, with: { (snapshot) in
        
            if let item = snapshot.key as? String
            {
                
                DispatchQueue.main.async {
                    self.list.append(item.description)
                    self.myTableView.reloadData()
                }
            }
            
        })
        
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
