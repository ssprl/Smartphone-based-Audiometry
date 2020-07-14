//
//  NewViewController.swift
//  playsound
//
//  Created by SSPRL on 8/15/19.
//  Copyright © 2019 SSPRL. All rights reserved.
//

import UIKit
import Firebase
let date = NSDate()
let calendar = NSCalendar.current

class NewViewController: UIViewController {
    
    var leftFS : [Int] = []
    var rightFS : [Int] = []
    var leftCG : [CGPoint] = []
    var rightCG : [CGPoint] = []
    var leftHL : [Int] = []
    var rightHL : [Int] = []
    var user : String = ""
    var freq : [String] = ["250 Hz", "500 Hz", "1000 Hz","1500 Hz", "2000 Hz", "3000 Hz", "4000 Hz","6000 Hz", "8000 Hz"]
    var left : [Int] = [20,40,40,50,40,30,60,20,30]
    var right : [Int] = [0,0,0,0,0,0,0,0,0]
    
    var dictLeftEar : [String : Int] = ["250 Hz": 0, "500 Hz" : 0, "1000 Hz" : 0,"1500 Hz" : 0, "2000 Hz" : 0,"3000 Hz" : 0,"4000 Hz" : 0,"6000 Hz" : 0, "8000 Hz": 0]
    var dictRightEar : [String : Int] = ["250 Hz": 0, "500 Hz" : 0, "1000 Hz" : 0,"1500 Hz" : 0, "2000 Hz" : 0,"3000 Hz" : 0,"4000 Hz" : 0,"6000 Hz" : 0, "8000 Hz": 0]
    var alert:UIAlertController!
    var timerTest : Timer?
    let date = Date()
    let format = DateFormatter()
    var ref : Int = 0
    
  
    
    @IBOutlet var resultUser: UILabel!
    @IBAction func exit(_ sender: Any) {
        
       performSegue(withIdentifier: "toTable", sender: self)
    }
    @IBAction func testAgain(_ sender: Any) {
        performSegue(withIdentifier: "testAgainSeg", sender: self)
        
    }
    
    @IBAction func save(_ sender: Any) {
        if (leftHL != [] && rightHL != [])
        {
        storeInDict(arrLeft : leftHL, arrRight : rightHL)
        print(dictLeftEar)
        print(dictRightEar)
        let time = getTime()
        let ref = Database.database().reference()
        ref.child("list").child(user + "  " + time).child("Left Ear").setValue(dictLeftEar)
        ref.child("list").child(user + "  " + time).child("Right Ear").setValue(dictRightEar)
        showAlert()
       
        }
    }
    
    @IBOutlet var audiogram: UIImageView!
    
    

    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        resultUser.text =  "Your Audiogram" + ", " + user
       
        
        
        var image: UIImage = UIImage(named: "audiogram")!
        
        leftHL = dBFSTOdBHL(arr: leftFS)
        rightHL = dBFSTOdBHL(arr: rightFS)
        leftCG = valToPoint(arr: leftHL)
        rightCG = valToPoint(arr: rightHL)
        
      
        var imagenew : UIImage = DrawOnImage(startingImage: image, leftCG : leftCG, rightCG : rightCG)
        audiogram.image = imagenew
        

        // Do any additional setup after loading the view.
    }
    
    func storeInDict(arrLeft : [Int], arrRight : [Int])
    {
        for i in 0..<arrLeft.count
        {
            
          dictLeftEar.updateValue(arrLeft[i], forKey: freq[i])
          dictRightEar.updateValue(arrRight[i], forKey: freq[i])
            
            
        }
        
    }
    
    func getTime() -> String
    {
    format.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let formattedDate = format.string(from: date)
    return formattedDate
    }
    
    func dBFSTOdBHL (arr : [Int]) -> [Int]
    {   var outHL : [Int] = []
        for item in arr
        {
            outHL.append(item + ref)
        }
        
        return outHL
        
    }
    
    
    func valToPoint (arr : [Int])-> [CGPoint]
    {
        var out : [CGPoint] = []
        var point : CGPoint = CGPoint(x: 0 , y: 0)
        let inXPoint : CGFloat = 93
        let seperationInFrequency : CGFloat = 52.5
        let inYPoint : CGFloat = 135
        let seperationInIntensity : CGFloat = 3
        var pos1000 : CGFloat = 0
        var abs_y : Int = 0;
        for i in 0..<arr.count
        {   if (i <= 2)
            {
            point.x = inXPoint + seperationInFrequency*CGFloat(i+1)   // (i+1) is because we are starting from frequency 250 Hz
            pos1000 = point.x
            }else
            {
            point.x = pos1000 + (seperationInFrequency/2)*CGFloat(i+1-3)
            }
            
            if arr[i]<0{
                abs_y = 0
            }else{
                abs_y = arr[i]
                
            }
            point.y = inYPoint + seperationInIntensity*CGFloat(abs_y)
            out.append(point)
        }
    
        return out
    }
    
    
    
    
    func DrawOnImage(startingImage: UIImage, leftCG : [CGPoint], rightCG: [CGPoint]) -> UIImage
    {
        
        // Create a context of the starting image size and set it as the current one
        UIGraphicsBeginImageContext(startingImage.size)
        
        // Draw the starting image in the current context as background
        startingImage.draw(at: CGPoint.zero)
        var myImage: UIImage!
        
        // Get the current context
        if  let context = UIGraphicsGetCurrentContext()
        {
            
            
            func cross (point : CGPoint, len: CGFloat)
            {
                context.setStrokeColor(UIColor.blue.cgColor)
                context.setAlpha(0.5)
                context.setLineWidth(3.0)
                //context.move(to: CGPoint(x: point.x-5,y: point.y-5))
                context.addLines(between: [CGPoint(x: point.x-len,y: point.y-len),CGPoint(x: point.x+len,y: point.y+len) ])
                context.strokePath()
                context.setStrokeColor(UIColor.blue.cgColor)
                context.setAlpha(0.5)
                context.setLineWidth(3.0)
                context.addLines(between: [CGPoint(x: point.x-len,y: point.y+len),CGPoint(x: point.x+len,y: point.y-len) ])
                context.strokePath()
                
            }
            
            func circle ( point :CGPoint, len : CGFloat)
            {
                // Draw a transparent green Circle
                context.setStrokeColor(UIColor.red.cgColor)
                context.setAlpha(0.5)
                context.setLineWidth(3.0)
                context.addEllipse(in: CGRect(x: point.x-len/2, y:point.y-len/2, width: len, height: len))
                context.drawPath(using: .stroke) // or .fillStroke if need filling
            }
            
            func lines (arr : [CGPoint], ear : String  )
            {   if ear == "left"
            {
                context.setStrokeColor(UIColor.blue.cgColor)
            } else{
                context.setStrokeColor(UIColor.red.cgColor)
                }
                context.setAlpha(0.5)
                context.setLineWidth(3.0)
                context.addLines(between: arr)
                context.strokePath()
            }
            
            
            let len : CGFloat = 8
            let rad = 2*1.41*len
            
            for item in leftCG
            {
                cross(point: item,len : len)
            }
            for item in rightCG
            {
                circle(point: item,len : rad)
            }
            
            
            
            lines(arr : leftCG, ear : "left")
            lines(arr : rightCG, ear : "right")
            
            // Draw a red line
            /* context.setLineWidth(2.0)
             context.setStrokeColor(UIColor.red.cgColor)
             context.move(to: CGPoint(x: 100, y: 100))
             context.addLine(to: CGPoint(x: 200, y: 200))
             context.addLines(between: [CGPoint(x:100,y:100), CGPoint(x:300,y: 250), CGPoint(x:400,y:40), CGPoint(x:40,y:500)])
             context.strokePath()*/
            
            
          
            
            // Save the context as a new UIImage
            myImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            // Return modified image
            
        }
        return myImage
        
        
    }
    
    func startTimer () {
        guard timerTest == nil else { return }
        
        timerTest =  Timer.scheduledTimer(
            timeInterval: TimeInterval(1),
            target      : self,
            selector    : #selector(NewViewController.dismissAlert),
            userInfo    : nil,
            repeats     : false)
    }
    func stopTimerTest() {
        timerTest?.invalidate()
        timerTest = nil
    }
    
    
    func showAlert() {
        self.alert = UIAlertController(title: "Hi, " + user, message: "Your test results are successfully saved.", preferredStyle: UIAlertController.Style.alert)
        self.present(self.alert, animated: true, completion: nil)
        startTimer()
       
    }
    
    @objc func dismissAlert(){
        // Dismiss the alert from here
        self.alert.dismiss(animated: true, completion: nil)
    }

  
}



