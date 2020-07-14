//
//  TestViewController.swift
//  playsound
//
//  Created by SSPRL on 8/9/19.
//  Copyright © 2019 SSPRL. All rights reserved.
//

import UIKit
import AVFoundation
import LMGaugeView


var hz250 = NSURL(fileURLWithPath: Bundle.main.path(forResource: "250Hz",ofType: "wav")!)
var hz500 = NSURL(fileURLWithPath: Bundle.main.path(forResource: "500Hz",ofType: "wav")!)
var hz1000 = NSURL(fileURLWithPath: Bundle.main.path(forResource: "1000Hz",ofType: "wav")!)
var hz1500 = NSURL(fileURLWithPath: Bundle.main.path(forResource: "1500Hz",ofType: "wav")!)
var hz2000 = NSURL(fileURLWithPath: Bundle.main.path(forResource: "2000Hz",ofType: "wav")!)
var hz3000 = NSURL(fileURLWithPath: Bundle.main.path(forResource: "3000Hz",ofType: "wav")!)
var hz4000 = NSURL(fileURLWithPath: Bundle.main.path(forResource: "4000Hz",ofType: "wav")!)
var hz5000 = NSURL(fileURLWithPath: Bundle.main.path(forResource: "5000Hz",ofType: "wav")!)
var hz6000 = NSURL(fileURLWithPath: Bundle.main.path(forResource: "6000Hz",ofType: "wav")!)
var hz8000 = NSURL(fileURLWithPath: Bundle.main.path(forResource: "8000Hz",ofType: "wav")!)
var whiteNoise = NSURL(fileURLWithPath: Bundle.main.path(forResource: "whit_noise",ofType: "wav")!)
var startVol: Int = 30

class TestViewController: UIViewController, AVAudioRecorderDelegate
{
    var user: String = ""
    var audioRecorder : AVAudioRecorder!
    var recordingSession : AVAudioSession!
    var leftdBHL:[Int] = []
    var rightdBHL :[Int] = []
    var audioPlayer: AVAudioPlayer!
    var audioPlayer_Masking : AVAudioPlayer!
    var Index_Hz:Int = 0
    let array1 = NSMutableArray(array: [hz250, hz500,hz1000,hz1500, hz2000,hz3000, hz4000,hz6000,hz8000])
    var dBSPL_MAX : [Float] =   [102.6,102.7,106.4,110.0,112.2,120.1,119.1,120.0,112.7]
    //var RETSPL:[Float] = [11.8 ,9.5 ,4.4 ,2.2 ,0  ,5.1 ,6.7 ,13.2 ,16.2]
    var RETSPL:[Float] = [1.8, -0.5, -0.6, 2.2, 0, 5.1, 6.7, 13.2, 11.2]
    var dBFS:[Int] = [0,-5,-10,-15,-20,-25,-30,-35,-40,-45,-50,-55,-60,-65,-70,-75,-80,-85,-90,-95,-100,-105,-110,-115,-120,-125,-130]
    var dBtoVol: [Float] = [1,0.56234,0.31623,0.17783,0.1,0.056234,0.031623,0.017783,0.01,0.0056234,0.0031623,0.0017783,0.001,0.00056234,0.00031623,0.00017783,0.0001,5.6234e-05,3.1623e-05,1.7783e-05,1e-05,5.6234e-06,3.1623e-06,1.7783e-06,1e-06,5.6234e-07,3.1623e-07]
    var timerTest : Timer?
    var currentVol: Int = startVol
    var volMask: Float = -50
    var first_Mask: Bool = true
    var prevButton: String = ""
    var currButton: String = ""
    var dict250 : [Int : String] = [:]
    var dict500 : [Int : String] = [:]
    var dict1000: [Int : String] = [:]
    var dict1500 : [Int : String] = [:]
    var dict2000 : [Int : String] = [:]
    var dict3000: [Int : String] = [:]
    var dict4000 : [Int : String] = [:]
    var dict5000 : [Int : String] = [:]
    var dict6000: [Int : String] = [:]
    var dict8000: [Int : String] = [:]
    
    var dictionaries = [[Int: String]]()
    var earSelect: String = ""
    var ear : Int = -1
    var countEar = 0
    var leftEarDone : Bool = false
    var rightEarDone : Bool = false
    

    
    @IBOutlet var meterview: LMGaugeView!  // Adding LMGaugeView enables meter view.

    @IBOutlet weak var Heard: UIButton!
    @IBOutlet weak var notHeard: UIButton!
    @IBAction func pause_resume(_ sender: Any){
        audioPlayer.stop()
        audioPlayer_Masking.stop()
        pauseResumeAlert()
    }
    @IBAction func exit_test(_ sender: Any){
        audioPlayer.stop()
        audioPlayer_Masking.stop()
        exitAlert()
    }
    @IBAction func show_results(_ sender: Any){
        if (countEar == 2 ){
            performSegue(withIdentifier: "toNewView", sender: self)
        }else{
            finishFirstAlert()
        }
    }
 
    @IBOutlet weak var result: UIButton!
    @IBOutlet var progress_bar: UIProgressView!
  
    func getMaskVol(indB : Float)->Float{
        return pow(10,indB/20);
    }
    
    func getVol(indB: Int)->Float{
        let vol_spl = Float(indB) + (RETSPL[Index_Hz])
        let vol_FS = vol_spl - Float(dBSPL_MAX[Index_Hz])
        let vol = pow(10, vol_FS/20)
        print("Vol SPL is :", vol_spl, "vol FS is :", vol_FS, "vol is :", vol, "Index is :", Index_Hz)
        return vol
    }
 
    
    @IBAction func response(sender: UIButton){
        switch sender{
            case notHeard:
                prevButton = currButton
                currButton = "notHeard"
            case Heard:
                prevButton = currButton
                currButton = "heard"
            default:
                break
        }
        respond()
    }
    
    func progress(){
        let c = array1.count
        let p = Float(Index_Hz)*(0.5)/Float(c) + Float(countEar)*0.5
        progress_bar.setProgress(p, animated: true)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        definesPresentationContext = true
        progress_bar.transform = progress_bar.transform.scaledBy(x: 1, y: 4)
        
        recordingSession = AVAudioSession.sharedInstance()
        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
            if hasPermission{
                print("Accepted Recording")
            }
        }
       
        try! recordingSession.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        record()
      //  startTimer()
        setDictionary()
        // Sets the array of dictionary to store the response of user at each frequency and intensity
        onStart()
        // When the view appears...what to do is defined by this function
        testingDone()
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let resultviewcontroller = segue.destination as! NewViewController
        stopTimerTest()
        audioRecorder.stop()
        audioPlayer.stop()
        audioPlayer_Masking.stop()
        resultviewcontroller.leftFS = leftdBHL
        resultviewcontroller.rightFS = rightdBHL
        resultviewcontroller.user = user
    }
    
    func setDictionary(){
        dictionaries.append(dict250)
        dictionaries.append(dict500)
        dictionaries.append(dict1000)
        dictionaries.append(dict1500)
        dictionaries.append(dict2000)
        dictionaries.append(dict3000)
        dictionaries.append(dict4000)
        dictionaries.append(dict6000)
        dictionaries.append(dict8000)
    }
    
    func onStart(){
        do{
            print(array1[0])
            audioPlayer = try AVAudioPlayer(contentsOf: array1[0] as! URL, fileTypeHint: AVFileType.wav.rawValue)
            playsound()
            audioPlayer_Masking = try AVAudioPlayer(contentsOf: whiteNoise as URL)
        }catch{
            print("Error locating file to play")
        }
    }
    
    func updatedict(){
        if (Index_Hz<array1.count){
            dictionaries[Index_Hz].updateValue(currButton, forKey: currentVol)
        }else{
            return
        }
    }
   
    func playsound(){
        if (audioPlayer.isPlaying){
            audioPlayer.pause()
        }
        do{
            DispatchQueue.main.asyncAfter(deadline: .now() + (0.3)){
                self.audioPlayer =  try! AVAudioPlayer(contentsOf: self.array1[self.Index_Hz] as! URL)
                self.audioPlayer.play()
                self.audioPlayer.volume = self.getVol(indB: self.currentVol)
                self.audioPlayer.pan = Float(self.ear)
                self.audioPlayer.isMeteringEnabled = true
                self.audioPlayer.numberOfLoops = -1
            }
        }
    }

    func masksound(){
           self.audioPlayer_Masking =  try! AVAudioPlayer(contentsOf: whiteNoise as URL)
           self.audioPlayer_Masking.play()
           self.audioPlayer_Masking.volume = getMaskVol(indB: volMask)
           self.audioPlayer_Masking.pan = Float(-1*self.ear)
    }
        
    func updateResult(){
        if (ear == -1){
            leftdBHL.append(currentVol)
        }else{
            rightdBHL.append(currentVol)
        }
    }
    
    func changTonesAndEar(){
        Index_Hz = Index_Hz + 1
        if (Index_Hz < array1.count){
            currentVol = startVol
            prevButton = ""
            currButton = ""
        }else{
            Index_Hz = 0
            currentVol = startVol
            if (countEar < 3){
                countEar = countEar + 1
                if (countEar<2){
                    earChangeAlert()
                }
                ear = ear*(-1)
            }
        }
        testingDone()
    }
    
    func testingDone(){
        if (countEar == 2){
            completedAlert()
            print("User Finished the Test")
            return
        }
    }
    
    func checkMasking(){
        if (currentVol<=50){
            if(self.audioPlayer_Masking.isPlaying){
                self.audioPlayer_Masking.stop()
            }
        }else{
            if(self.audioPlayer_Masking.isPlaying){
                self.audioPlayer_Masking.volume = self.audioPlayer_Masking.volume*1.259;
            }
            else{
                if (first_Mask == true){
                    maskingWarning()
                    first_Mask = false
                }
                masksound()
            }
        }
    }
    
    func respond(){
        updatedict()
        progress()
        checkMasking()
        if (prevButton == "notHeard" && currButton == "heard"){
            updateResult()
            changTonesAndEar()
            playsound()
        }else{
            if (currButton == "heard"){
                currentVol = currentVol - 10
                playsound()
                print("I heard" )
            }else{
                currentVol = currentVol + 5
                playsound()
            }
        }
    }
    
    func startTimer () {
        guard timerTest == nil else { return }
        timerTest =  Timer.scheduledTimer(
            timeInterval: TimeInterval(0.5),
            target      : self,
            selector    : #selector(TestViewController.meter),
            userInfo    : nil,
            repeats     : true)
       }


    func stopTimerTest() {
        timerTest?.invalidate()
        timerTest = nil
    }

    @objc func meter(){
        meterview.valueFont = UIFont(name: "HelveticaNeue-CondensedBold",size: 25)
        meterview.valueTextColor = UIColor.white
        meterview.decimalFormat = true
        meterview.unitOfMeasurement = ""//"dB SPL"
        meterview.ringThickness = 10
        meterview.showRingBackground = false
        meterview.backgroundColor = UIColor.white
        meterview.divisionsPadding = 0
        meterview.unitOfMeasurementFont = UIFont(name: "HelveticaNeue-CondensedBold",size: 15)
        meterview.showMinMaxValue = false

        if audioRecorder.isRecording{
            audioRecorder.updateMeters()
            let decibels : Float = audioRecorder.averagePower(forChannel: 0)
            // 160+db here, to scale it from 0 to 160, not -160 to 0.
            let referenceLevel : Float = 5.0
            let offset : Float = 20
            let range: Float = 160
            let SPL: Float = 20 * log10(referenceLevel * powf(10, (decibels/20)) * range) + offset;
            meterview.value = CGFloat(SPL)
            if (SPL > 45){
                meterview.backgroundColor = UIColor.red
            }else{
                meterview.backgroundColor = UIColor.white
            }
        }
    }
       
       
    func record(){
        let filename = getUrlDirectory().appendingPathComponent("sound.m4a", isDirectory: false)
        let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 48000, AVNumberOfChannelsKey : 1, AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue ]
               //start recording
        do{
            audioRecorder = try AVAudioRecorder(url: filename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            audioRecorder.isMeteringEnabled = true
        }catch{
        }
           
    }
       // Func that gets the paths to the directory
    func getUrlDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
       
    func exitAlert(){
        let alert = UIAlertController(title: "Are you sure you want to exit the test?", message: "Your test resuls will not be saved. You may need to do the hearing test again.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Yes, Exit", style: .default, handler: { (_) in
            exit(0)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (_) in
            self.playsound()
            print("User click the NO button")
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func pauseResumeAlert(){
        let alert = UIAlertController(title: "Pause", message: "You have paused the test. Press Resume to continue the test. Press Exit to exit the test.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Resume", style: .default, handler: { (_) in
            self.playsound()
            print("User click Approve button")
        }))
        alert.addAction(UIAlertAction(title: "Exit", style: .default, handler: { (_) in
            self.exitAlert()
            print("User click the NO button")
        }))
        self.present(alert, animated: true, completion: {
        })
    }
    
    func completedAlert(){
        let alert = UIAlertController(title: "Completed Test", message: "Click the result button to see your result.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Result", style: .default, handler: { (_) in
            self.result.sendActions(for: .touchUpInside)
            print("User Finished the test")
        }))
        self.present(alert, animated: true, completion: {
        })
    }
    
    func finishFirstAlert(){
        let alert = UIAlertController(title: "Test is not completed", message: "You need to finish the test to view the results. It will not take long!", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (_) in
        }))
        self.present(alert, animated: true, completion: {
        })
    }
    
    func maskingWarning(){
        let alert = UIAlertController(title: "Warning", message: "As your hearing loss is higher in one ear, sound will be masked in other ear to prevent leakage.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
        }))
        self.present(alert, animated: true, completion: {
        })
    }

    func earChangeAlert(){
        if ear == -1{
            let alert = UIAlertController(title: "Attention !" + user, message: "You have finished the hearing test for your left ear. Now application will test your right ear.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            }))
            self.present(alert, animated: true, completion: {
                //print("completion block")
            })
        }else{
            let alert = UIAlertController(title: "Attention !" + user, message: "You have finished the hearing test for your right ear. Now application will test your left ear.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
               
            }))
            self.present(alert, animated: true, completion: {
                    //print("completion block")
            })
        }
    }
    
}

