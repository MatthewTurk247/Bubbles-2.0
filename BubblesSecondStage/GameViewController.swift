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
import GoogleMobileAds

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

class GameViewController: UIViewController {
    
    var googleBannerView:GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
        
        googleBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        googleBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        googleBannerView.rootViewController = self
        var request:GADRequest = GADRequest()
        googleBannerView.loadRequest(request)
        googleBannerView.frame = CGRectMake(view.bounds.origin.x, view.bounds.height - googleBannerView.frame.size.height, googleBannerView.frame.size.width, googleBannerView.frame.size.height)
        self.view.addSubview(googleBannerView!)
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
