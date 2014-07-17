//
//  ViewController.swift
//  MonkeyPinch
//
//  Created by James Nocentini on 17/07/2014.
//  Copyright (c) 2014 James Nocentini. All rights reserved.
//

import UIKit

//Necessary to play a sound
import AVFoundation

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    //By default, once one gesture recognizer on the view "claims" the gesture, no others can recognize
    //a gesture from that point on.
    //Here we override a function in the UIGestureRecognizerDelegate
    func gestureRecognizer(UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
            return true
    }
    
    @IBAction func handlePan(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(self.view)
        sender.view.center = CGPoint(x: sender.view.center.x + translation.x, y: sender.view.center.y + translation.y)
        sender.setTranslation(CGPointZero, inView: self.view)
        
        if sender.state == UIGestureRecognizerState.Ended {
            
            let velocity = sender.velocityInView(self.view)
            let magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y))
            let slideMultiplier = magnitude / 200
            
            let slideFactor = slideMultiplier * 0.1
            
            var finalPoint = CGPoint(x: sender.view.center.x + (velocity.x * slideFactor), y: sender.view.center.y + (velocity.y * slideFactor))
            
            finalPoint.x = min(max(finalPoint.x, 0), self.view.bounds.width)
            finalPoint.y = min(max(finalPoint.y, 0), self.view.bounds.height)
            
            UIView.animateWithDuration(Double(slideFactor * 2), delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {sender.view.center = finalPoint}, completion: nil)
            
        }
        
    }
    
    //Get the scale from UIPinchGestureRecognizer
    @IBAction func handlePinch(recognizer: UIPinchGestureRecognizer) {
        recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale)
        recognizer.scale = 1
    }
    
    //Get the rotation from UIRotationGestureRecognizer
    @IBAction func handleRotate(recognizer: UIRotationGestureRecognizer) {
        recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation)
        recognizer.rotation = 0
    }
    
    //NOTE: We reset the scale and rotation because we update on each function call
    //It would compound otherwise
    
    var chompPlayer: AVAudioPlayer? = nil
    
    func loadSound(filename: NSString) -> AVAudioPlayer {
        let url = NSBundle.mainBundle().URLForResource(filename, withExtension: "caf")
        var error: NSError? = nil
        let player = AVAudioPlayer(contentsOfURL: url, error: &error)
        if player == nil {
            
        } else {
            player.prepareToPlay()
        }
        return player
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Cycle through all the subviews (here just the monkey and bananas)
        for view: UIView! in self.view.subviews {
            //Create a Tap Gesture Recognizer for each
            let recognizer = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
            //Set the delegate of the recognizer
            recognizer.delegate = self
            //add the recognizer to the view
            view.addGestureRecognizer(recognizer)
        }
        self.chompPlayer = self.loadSound("chomp")
        
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        self.chompPlayer?.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

