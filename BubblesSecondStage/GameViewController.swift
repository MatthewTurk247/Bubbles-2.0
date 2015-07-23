//
//  GameViewController.swift
//  BubblesSecondStage
//
//  Created by Matthew Turk on 6/16/15.
//  Copyright (c) 2015 Bubbles, Inc. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit
import iAd
import AVFoundation

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController, ADBannerViewDelegate {
    
    var backgroundMusicPlayer:AVAudioPlayer = AVAudioPlayer()
    var adBannerView:ADBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
            
            var bgMusicURL:NSURL = NSBundle.mainBundle().URLForResource("neverMind", withExtension: "mp3")!
            backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
            backgroundMusicPlayer.numberOfLoops = -1
            backgroundMusicPlayer.volume = 0.5
            if NSUserDefaults.standardUserDefaults().boolForKey("music") == true {
                backgroundMusicPlayer.prepareToPlay()
                backgroundMusicPlayer.play()
            }
        }
        
            func authenticateLocalPlayer(){
                
                var localPlayer = GKLocalPlayer.localPlayer()
                
                localPlayer.authenticateHandler = {(ViewController:UIViewController!, error:NSError!) -> Void in
                    println(GKLocalPlayer.localPlayer().authenticated)
                }
                
            }
            authenticateLocalPlayer()
            loadAds()
        //}
        
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        println("Leaving app to the Ad")
        
        return true
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        
        adBannerView.center = CGPoint(x: adBannerView.center.x, y: self.view.bounds.size.height - GamePlayScene().bottomVacuum.frame.height / 0.78)
        adBannerView.frame = CGRectOffset(adBannerView.frame,0.0,0.0)
        println(GamePlayScene().bottomVacuum.frame.height)
            adBannerView.hidden = false
        println("Displaying the Ad")
        
    }
    
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        adBannerView.center = CGPoint(x: adBannerView.center.x, y: self.view.bounds.size.height + self.view.bounds.size.height)
        println("Ad is not available")
    }
    
    func loadAds() {
        adBannerView = ADBannerView(frame: CGRect.zeroRect)
        adBannerView.frame = CGRectOffset(adBannerView.frame,0,0.0)
        adBannerView.delegate = self
        adBannerView.hidden = true
        self.view.addSubview(adBannerView)
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.Portrait.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.Portrait.rawValue)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
