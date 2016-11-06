//
//  AnimationViewController.swift
//  krombopulos-hw6
//
//  Created by Team Krombopulos on 9/27/16.
//  Copyright © 2016 Team Krombopulos. All rights reserved.
//
//  This class is an extension of DisplayViewController as an animation view controller.
//  Contains and sets up animations for supported students.
//

import UIKit

extension CGRect {
    var center : CGPoint { return CGPoint(x: self.midX, y: self.midY)
    }
    
}

class AnimationViewController: DisplayViewController {
    
    let bowlingBall = UIView()
    let pin = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animate()
    }
    
    func animate(){
        if(super.student.name == "Adam Tache"){
            self.animateAdam()
        }
        if(super.student.name == "Matt Battles"){
            self.animateMatt()
        }
        if(super.student.name == "Steven Katsohirakis"){
            self.animateSteven()
        }
    }
    
    /*
     Methods for starting animation for each supported student
    */
    
    func animateAdam(){
        self.setBowlingAlleyBackground()
        self.animatePin()
        self.animateCircle()
        self.animateBowling()
    }
    
    func animateMatt(){
        initialSetupForMatt()
        
    }
    
    func animateSteven(){
        
        initialSetupForSteven()
        
        //playBackgroundMusicForSteven("NYEH SQUIDWARD.mp3")
        
    }
    
    func initialSetupForMatt() {
        let guitarone = UIImage(named: "guitar1")!
        let guitartwo = UIImage(named: "guitar2")!
        let animatedImage = UIImage.animatedImage(with: [guitarone, guitartwo], duration: 0.5)
        
        let deadpool = UIImage(named: "deadpool")!
        //UIGraphicsBeginImageContextWithOptions(deadpool.size,false, 0)
        //UIGraphicsEndImageContext()
        //        let arr = [guitarone, guitartwo, guitarone, guitartwo, guitarone]
        let iv = UIImageView(image:animatedImage)
        iv.frame.origin = CGPoint(x: 100,y: 100)
        let iv2 = UIImageView(image:deadpool)
        iv2.frame.origin = CGPoint(x: 0, y: 400)
        self.view.addSubview(iv)
        self.view.addSubview(iv2)
        self.view.backgroundColor = UIColor.blue
        let rev = UIViewAnimationOptions.autoreverse
        let opts = UIViewAnimationOptions.repeat
        UIView.animate(withDuration: 1, delay: 0, options: [rev, opts],animations: {iv2.center.x += 180; self.view.backgroundColor = UIColor.green}, completion: nil)
    }
    
    func initialSetupForSteven() {
        
        self.view.backgroundColor = UIColor.green
        
        //let animationView = AnimationView(frame:CGRect(x: 100, y: 350, width: 200, height: 200))
        
        //self.view.addSubview(animationView)
        
        initializeBallForSteven()
        
    }
    
    
    
    func initializeBallForSteven() {
        
        let myBasketBall = UIImageView(image: UIImage(named: "basketball.png"))
        
        self.view.addSubview(myBasketBall)
        
        myBasketBall.frame.size = CGSize(width: 50, height: 50)
        
        myBasketBall.center = myBasketBall.superview!.bounds.center
        
        UIView.animate(withDuration: 2.0, delay: 0.3, options: [.repeat, .autoreverse], animations: {
            
            myBasketBall.frame =
                
                CGRect(x: myBasketBall.frame.midX, y: myBasketBall.frame.midY-200, width: 75, height: 75)
            
            
            
            }, completion: nil)
        
    }
    
    /*
    Helper methods for objects in Adam's animation
    */
    func setBowlingAlleyBackground(){
        let background = UIImage(named: "bowling-alley.png")
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }
    
    func animateBowling(){
        animatePin()
        animateBall()
    }
    
    func animatePin(){
        pin.image = UIImage(named: "bowling-pin.png")
        self.pin.frame = CGRect(x: 150, y: 75, width: 40, height: 40)
        self.view.addSubview(pin)
        
        let randomXOffset = CGFloat( arc4random_uniform(30))
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 150, y: 75))
        path.addCurve(to: CGPoint(x: 150, y: 50), controlPoint1: CGPoint(x: 150 + randomXOffset, y: 20), controlPoint2: CGPoint(x: 150 + randomXOffset, y: -20))
        
        let moveAnim = CAKeyframeAnimation(keyPath: "position")
        moveAnim.path = path.cgPath
        moveAnim.repeatCount = Float.infinity
        moveAnim.duration = 2.0
        
        self.pin.layer.add(moveAnim, forKey: "moveAnim")
    }
    
    func animateBall(){
        self.bowlingBall.frame = CGRect(x: 160, y: 500, width: 50, height: 50)
        self.bowlingBall.layer.cornerRadius = 25
        self.view.addSubview(bowlingBall)
        self.bowlingBall.backgroundColor = UIColor.black
        
        self.bowlingBall.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        UIView.animate(withDuration: 1.0, animations: { () -> Void in
            self.bowlingBall.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
        
        let fullRotation = CGFloat(M_PI * 2)
        
        let duration = 2.0
        let delay = 1.5
        let options = UIViewKeyframeAnimationOptions()
        
        UIView.animateKeyframes(withDuration: duration, delay: delay, options: options, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/3, animations: {
                self.bowlingBall.transform = CGAffineTransform(rotationAngle: 1/3 * fullRotation)
            })
            UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3, animations: {
                self.bowlingBall.transform = CGAffineTransform(rotationAngle: 2/3 * fullRotation)
            })
            UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3, animations: {
                self.bowlingBall.transform = CGAffineTransform(rotationAngle: 3/3 * fullRotation)
            })
            
            }, completion: {finished in
                self.animate()
        })
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 160,y: 500))
        path.addCurve(to: CGPoint(x: 145, y: 50), controlPoint1: CGPoint(x: 160, y: 20), controlPoint2: CGPoint(x: 170, y: -20))
        
        let moveAnim = CAKeyframeAnimation(keyPath: "position")
        moveAnim.path = path.cgPath
        moveAnim.rotationMode = kCAAnimationRotateAuto
        moveAnim.repeatCount = Float.infinity
        moveAnim.duration = 5.0
        
        self.bowlingBall.layer.add(moveAnim, forKey: "moveAnim")
    }
    
    func animateCircle(){
        let circleStartAngle = CGFloat(90.01 * M_PI/180)
        let circleEndAngle = CGFloat(90 * M_PI/180)
        let circle = CGRect(x: 110, y: 450, width: 100, height: 100)
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: circle.midX, y: circle.midY),
                                  radius: circle.width / 2,
                                  startAngle: circleStartAngle,
                                  endAngle: circleEndAngle, clockwise: true)
        let progress = CAShapeLayer()
        progress.path = path.cgPath
        progress.strokeColor = UIColor.red.cgColor
        progress.fillColor = UIColor.clear.cgColor
        progress.lineWidth = 5.0
        progress.lineCap = kCALineCapRound
        self.view.layer.addSublayer(progress)
        let animateStrokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        animateStrokeEnd.duration = 3.0
        animateStrokeEnd.fromValue = 0.0
        animateStrokeEnd.toValue = 1.0
        progress.add(animateStrokeEnd, forKey: "animate inner circle")
    }
    
}
