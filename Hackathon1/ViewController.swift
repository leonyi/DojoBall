//
//  ViewController.swift
//  Hackathon1
//
//  Created by Lisa Ryland on 1/14/18.
//  Copyright © 2018 Lisa Ryland. All rights reserved.
//

import UIKit
import CoreMotion

var algoArr = [
    "How would you verify a prime number?",
    "How could you find all prime factors of a number?",
    "How do get nth Fibonacci number?",
    "How would you find the greatest common divisor of two numbers?",
    "How would you remove duplicate members from an array?"
]
var shakeCount = 0

var categoryArr = ["Algorithms", "Uplifting Quotes", "Jokes"]
var categoryShakeCount = 0

var motionManager: CMMotionManager?

var isAccelerometerAvailable: Bool = false

class ViewController: UIViewController {
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var stringLabel: UILabel!
    
    var motionManager = CMMotionManager()
    let opQueue = OperationQueue()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if motionManager.isDeviceMotionAvailable {
            print("We can detect device motion")
            startReadingMotionData()
        }
        else {
            print("We cannot detect device motion")
        }
        
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.02
            motionManager.startDeviceMotionUpdates(to: .main) {
                [weak self] (data: CMDeviceMotion?, error: Error?) in
                if let x = data?.userAcceleration.x,
                    x < -2.5 {
                    self?.navigationController?.popViewController(animated: true)
                    self?.categoryLabel.text = categoryArr[categoryShakeCount]
                    
                    if categoryShakeCount == categoryArr.count - 1 {
                        categoryShakeCount  = 0
                        self?.stringLabel.text = ""
                    }
                    else {
                        print("Motion ended")
                        self?.stringLabel.text = categoryArr[categoryShakeCount]
                        categoryShakeCount += 1
                    }
//                    categoryShakeCount += 1
                    self?.stringLabel.text = ""
                }
            }
        }
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        print("Motion started")
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if shakeCount == algoArr.count - 1 {
            shakeCount = 0
            stringLabel.text = algoArr[shakeCount]
        }
        else {
            print("Motion ended")
            stringLabel.text = algoArr[shakeCount]
            shakeCount += 1
        }
    }
    
    func startReadingMotionData() {
        // set read speed
        motionManager.deviceMotionUpdateInterval = 1
        // start reading
        motionManager.startDeviceMotionUpdates(to: opQueue) {
            (data: CMDeviceMotion?, error: Error?) in
            
            if let mydata = data {
                print("mydata", mydata.attitude)
                print("pitch", self.degrees(mydata.attitude.pitch))
            }
        }
    }
    
    func degrees(_ radians: Double) -> Double {
        return 180/Double.pi * radians
    }

}

