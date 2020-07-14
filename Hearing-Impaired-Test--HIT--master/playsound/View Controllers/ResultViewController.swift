//
//  ResultViewController.swift
//  playsound
//
//  Created by SSPRL on 8/9/19.
//  Copyright © 2019 SSPRL. All rights reserved.
//

import UIKit
import Firebase

class ResultViewController: UIViewController {
    var leftFS : [Int] = []
    var rightFS : [Int] = []
    var leftCG : [CGPoint] = []
    var rightCG : [CGPoint] = []
    var leftHL : [Int] = []
    var rightHL : [Int] = []
    //var ref: DatabaseReference?
 
    @IBAction func press(_ sender: Any)
    {
        
        print("Another button works.")
    }
    @IBAction func saveme(_ sender: Any)
    {
        
        print("you pressed me, helloooooooo")
    }
   
    
    @IBOutlet var email: UITextField!
    
    @IBOutlet var drawonAudiogram: UIImageView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        var ref = Database.database().reference()
        
       
        var image: UIImage = UIImage(named: "audiogram")!
       
        leftHL = dBFSTOdBHL(arr: leftFS)
        rightHL = dBFSTOdBHL(arr: rightFS)
        leftCG = valToPoint(arr: leftHL)
        rightCG = valToPoint(arr: rightHL)
        
        ref.child("list").childByAutoId().setValue(leftHL)
        
        
      //  var imagenew : UIImage = DrawOnImage(startingImage: image, leftCG : leftCG, rightCG : rightCG)
        //drawonAudiogram.image = imagenew
        
        
        
    }
    
    func dBFSTOdBHL (arr : [Int]) -> [Int]
    {   var outHL : [Int] = []
        for item in arr
        {
            outHL.append(item + 85)
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
        for i in 0..<arr.count
        {
            point.x = inXPoint + seperationInFrequency*CGFloat(i+1)   // (i+1) is because we are starting from frequency 250 Hz
            point.y = inYPoint + seperationInIntensity*CGFloat(abs(arr[i]))
            out.append(point)
        }
        
        return out
    }
    
    
    
    
  /*
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
            
           
           
            let point1 = CGPoint(x:300,y:300)
            let point2 = CGPoint(x:400,y:300)
          //  circle(point: point1, len: rad)
           // circle(point: point2, len: rad)
            //cross(point: point2,len: len)
            //cross(point:point1, len: len)
            
            // Save the context as a new UIImage
            myImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            // Return modified image
            
        }
        return myImage
    

}*/




    
    
    
    
    
    
}
