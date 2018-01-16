//
//  ViewController.swift
//  Hackathon1
//
//  Created by Lisa Ryland on 1/14/18.
//  Copyright © 2018 Lisa Ryland. All rights reserved.
//

import UIKit
import CoreMotion

var currentArr: [String] = []

//category array
var categoryArr = ["Algorithms", "Uplifting Quotes", "Jokes"]

//main content arrays
var algoArr = [
    "Beginning: How would you verify a prime number?",
    "How could you find all prime factors of a number?",
    "How do get nth Fibonacci number?",
    "How would you find the greatest common divisor of two numbers?",
    "Ending: How would you remove duplicate members from an array?"
]
var inspirationalQuoteArr = ["inspo1", "inspo2", "inspo3", "inspo4", "inspo5"]
var jokeArr = ["joke1", "joke2", "joke3", "joke4", "joke5"]

//shake counters
var categorySwipeCount = 0
var mainContentShakeCount = 0


var motionManager: CMMotionManager?

var isAccelerometerAvailable: Bool = false

class ViewController: UIViewController {
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var stringLabel: UILabel!
    
    var motionManager = CMMotionManager()
    let opQueue = OperationQueue()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ownView: UIView = self.view
        
        //when app first loads
        categoryLabel.text = categoryArr[0]
        stringLabel.text = algoArr[0]
        
        //detecting device motion
        if motionManager.isDeviceMotionAvailable {
            print("We can detect device motion")
            startReadingMotionData()
        }
        else {
            print("We cannot detect device motion")
        }
        
        //swipe gestures
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture))
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture))
        
        leftSwipeGesture.direction = .left
        rightSwipeGesture.direction = .right
        
        ownView.addGestureRecognizer(leftSwipeGesture)
        ownView.addGestureRecognizer(rightSwipeGesture)
        //        iterateMainContent()
    }
    
    func iterateMainContent() {
        //when device motion is available
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.02
            motionManager.startDeviceMotionUpdates(to: .main) {
                [weak self] (data: CMDeviceMotion?, error: Error?) in
                if let x = data?.userAcceleration.x,
                    x < -2.5 {
                    self?.navigationController?.popViewController(animated: true)
                    
                    //when shake occurs
                    if mainContentShakeCount == algoArr.count - 1 {
                        mainContentShakeCount  = 0
                        self?.stringLabel.text = algoArr[mainContentShakeCount]
                    }
                    else {
                        self?.stringLabel.text = algoArr[mainContentShakeCount]
                        mainContentShakeCount += 1
                    }
                    mainContentShakeCount += 1
                }
            }
        }
    }
    
    @objc func swipeGesture(sender: UISwipeGestureRecognizer) {
        // go to next category, access different array for main content
        if(sender.direction == .right) {
            print("swiped right, next category")
            print("Swipe Count:", categorySwipeCount)
            // if at the last category, loop to the first one
            if categorySwipeCount == categoryArr.count - 1 {
                categorySwipeCount = 0
                categoryLabel.text = categoryArr[categorySwipeCount]
                if categoryArr[categorySwipeCount] == "Algorithms" {
                    currentArr = algoArr
                    stringLabel.text = currentArr[0]
                }
                else if categoryArr[categorySwipeCount] == "Uplifting Quotes" {
                    currentArr = inspirationalQuoteArr
                    stringLabel.text = currentArr[0]
                }
                else {
                    currentArr = jokeArr
                    stringLabel.text = currentArr[0]
                }
            }
            // if at the first category, move to the next
            else {
                categorySwipeCount += 1
                categoryLabel.text = categoryArr[categorySwipeCount]
                if categoryArr[categorySwipeCount] == "Algorithms" {
                    currentArr = algoArr
                    stringLabel.text = currentArr[0]
                }
                else if categoryArr[categorySwipeCount] == "Uplifting Quotes" {
                    currentArr = inspirationalQuoteArr
                    stringLabel.text = currentArr[0]
                }
                else {
                    currentArr = jokeArr
                    stringLabel.text = currentArr[0]
                }
            }
        }
        
        // go to previous
        if(sender.direction == .left) {
            print("swiped left, previous category")
            print("Swipe Count:", categorySwipeCount)
            
            if categorySwipeCount == 0 {
                categorySwipeCount = categoryArr.count - 1
                categoryLabel.text = categoryArr[categorySwipeCount]
                print(categoryArr[categorySwipeCount])
                if categoryArr[categorySwipeCount] == "Algorithms" {
                    currentArr = algoArr
                    stringLabel.text = currentArr[0]
                }
                else if categoryArr[categorySwipeCount] == "Uplifting Quotes" {
                    currentArr = inspirationalQuoteArr
                    stringLabel.text = currentArr[0]
                }
                else {
                    currentArr = jokeArr
                    stringLabel.text = currentArr[0]
                }
            }
            else {
                categorySwipeCount -= 1
                categoryLabel.text = categoryArr[categorySwipeCount]
                print(categoryArr[categorySwipeCount])
                if categoryArr[categorySwipeCount] == "Algorithms" {
                    currentArr = algoArr
                    stringLabel.text = currentArr[0]
                }
                else if categoryArr[categorySwipeCount] == "Uplifting Quotes" {
                    currentArr = inspirationalQuoteArr
                    stringLabel.text = currentArr[0]
                }
                else {
                    currentArr = jokeArr
                    stringLabel.text = currentArr[0]
                }
            }
        }
    }
    
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        print("Motion started")
    }
    
    // this is when stuff
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
     
        if mainContentShakeCount == currentArr.count - 1 {
            mainContentShakeCount = 0
            stringLabel.text = currentArr[mainContentShakeCount]
        }
        else {
            print("Motion ended and shakecount = ", mainContentShakeCount)
//            stringLabel.text = currentArr[mainContentShakeCount]
//            mainContentShakeCount += 1
//            print(currentArr[mainContentShakeCount])
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

