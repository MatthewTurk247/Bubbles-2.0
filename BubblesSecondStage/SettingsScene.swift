//
//  SettingsScene.swift
//  BubblesSecondStage
//
//  Created by Matthew Turk on 6/16/15.
//  Copyright (c) 2015 Bubbles, Inc. All rights reserved.
//

import SpriteKit
import Foundation

class SettingsScene:SKScene {
    let title:SKLabelNode = SKLabelNode(fontNamed: "Futura")
    let blue = SKColor(red: 29.0/255, green: 141.0/255, blue: 180.0/255, alpha: 1.0)
    let black = SKColor(red: 80.0/255, green: 80.0/255, blue: 80.0/255, alpha: 1.0)
    let yellow = SKColor(red: 255.0/255, green: 245.0/255, blue: 195.0/255, alpha: 1.0)
    let green = SKColor(red: 155.0/255, green: 215.0/255, blue: 213.0/255, alpha: 1.0)
    let red = SKColor(red: 255.0/255, green: 114.0/255, blue: 96.0/255, alpha: 1.0)
    let versionLabel:SKLabelNode = SKLabelNode(fontNamed: "Futura")
    var version:AnyObject! = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString")
    let moreInfoLabel = SKLabelNode(fontNamed: "Futura")
    let copyrightNoticeLabel = SKLabelNode(fontNamed: "Futura")
    let websiteButton = SKSpriteNode(imageNamed: "pillButtonGreen")
    let websiteText = SKLabelNode(fontNamed: "Futura")
    let restoreGameButton = SKSpriteNode(imageNamed: "pillButtonRed")
    let restoreGameText = SKLabelNode(fontNamed: "Futura")
    let gameCenterButton = SKSpriteNode(imageNamed: "pillButtonRed")
    let gameCenterText = SKLabelNode(fontNamed: "Futura")
    let removeAdsButton = SKSpriteNode(imageNamed: "pillButtonRed")
    let removeAdsText = SKLabelNode(fontNamed: "Futura")
    let musicSwitch = SKSpriteNode(imageNamed: "switchOn")
    let SFXSwitch = SKSpriteNode(imageNamed: "switchOn")
    let notificationsSwitch = SKSpriteNode(imageNamed: "switchOff")
    let musicText = SKLabelNode(fontNamed: "Futura")
    let SFXText = SKLabelNode(fontNamed: "Futura")
    let notificationsText = SKLabelNode(fontNamed: "Futura")
    var musicOn:Bool = true

    override func didMoveToView(view: SKView) {
        self.scene?.backgroundColor = blue
        title.fontColor = yellow
        title.text = "BUBBLES"
        title.fontSize = 64
        title.position = CGPoint(x: self.frame.width * 0.5, y: self.frame.height * 0.725)
        self.addChild(title)
        println(NSUserDefaults.standardUserDefaults().boolForKey("musicsIsEnabled"))
        
        copyrightNoticeLabel.fontColor = SKColor.whiteColor()
        copyrightNoticeLabel.text = "© \(NSCalendar.currentCalendar().component(NSCalendarUnit.CalendarUnitYear, fromDate: NSDate())) Bubbles, Inc."
        copyrightNoticeLabel.fontSize = 24
        copyrightNoticeLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.08)
        copyrightNoticeLabel.zPosition = 7
        self.addChild(copyrightNoticeLabel)
        
        moreInfoLabel.fontColor = SKColor.whiteColor()
        moreInfoLabel.text = "For More Info Visit Bubbles.com"
        moreInfoLabel.fontSize = 24
        moreInfoLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.025)
        moreInfoLabel.zPosition = 7
        self.addChild(moreInfoLabel)
        
        versionLabel.fontColor = yellow
        versionLabel.text = "VERSION: \(version.description)"
        versionLabel.fontSize = 29
        versionLabel.position = CGPoint(x: self.frame.width * 0.5, y: title.position.y * 0.925)
        self.addChild(versionLabel)
        
        let backButton = SKShapeNode(rect: CGRect(x: self.frame.origin.x, y: self.frame.height - (self.frame.height * 0.14), width: self.frame.width * 0.25, height: self.frame.height * 0.14))
        backButton.fillColor = red
        backButton.strokeColor = red
        backButton.zPosition = 6
        backButton.name = "backButton"
        self.addChild(backButton)
        
        let backButtonIcon = SKSpriteNode(imageNamed: "backButtonIcon")
        backButtonIcon.position = CGPoint(x: backButton.frame.width/2.222, y: self.frame.height * 0.9333)
        backButtonIcon.zPosition = 7
        backButtonIcon.name = "backButtonIcon"
        self.addChild(backButtonIcon)
        
        let blackStrip = SKShapeNode(rect: CGRect(x: backButton.frame.width, y: self.frame.height - (self.frame.height * 0.14), width: self.frame.width * 0.75, height: self.frame.height * 0.14))
        blackStrip.fillColor = black
        blackStrip.strokeColor = black
        blackStrip.zPosition = 5
        blackStrip.name = "blackStrip"
        self.addChild(blackStrip)
        
        websiteButton.position = CGPoint(x: backButton.frame.width + (backButton.frame.width * 1.5), y: self.frame.height * 0.93)
        websiteButton.zPosition = 6
        self.addChild(websiteButton)
        
        restoreGameButton.position = CGPoint(x: (self.frame.width/2) * 0.52, y: versionLabel.position.y * 0.9)
        restoreGameButton.zPosition = 2
        self.addChild(restoreGameButton)
        
        gameCenterButton.position = CGPoint(x: (self.frame.width/2) * 1.48, y: versionLabel.position.y * 0.9)
        gameCenterButton.zPosition = 2
        self.addChild(gameCenterButton)
        
        removeAdsButton.position = CGPoint(x: self.frame.width/2, y: versionLabel.position.y * 0.7333)
        removeAdsButton.zPosition = 2
        self.addChild(removeAdsButton)
        
        let redStrip = SKShapeNode(rect: CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height * 0.14))
        redStrip.fillColor = red
        redStrip.strokeColor = red
        redStrip.zPosition = 5
        redStrip.name = "redStrip"
        self.addChild(redStrip)
        
        websiteText.fontColor = SKColor.whiteColor()
        websiteText.text = "Visit Website"
        websiteText.fontSize = 24
        websiteText.position = CGPoint(x: websiteButton.position.x, y: websiteButton.position.y * 0.99)
        websiteText.zPosition = websiteButton.zPosition + 1
        self.addChild(websiteText)
        
        restoreGameText.fontColor = SKColor.whiteColor()
        restoreGameText.text = "Restore Game"
        restoreGameText.fontSize = 16
        restoreGameText.position = CGPoint(x: restoreGameButton.position.x, y: restoreGameButton.position.y * 0.99)
        restoreGameText.zPosition = restoreGameButton.zPosition + 1
        self.addChild(restoreGameText)
        
        gameCenterText.fontColor = SKColor.whiteColor()
        gameCenterText.text = "Game Center"
        gameCenterText.fontSize = 16
        gameCenterText.position = CGPoint(x: gameCenterButton.position.x, y: gameCenterButton.position.y * 0.99)
        gameCenterText.zPosition = gameCenterButton.zPosition + 1
        self.addChild(gameCenterText)
        
        removeAdsText.fontColor = SKColor.whiteColor()
        removeAdsText.text = "Remove Ads ¢99"
        removeAdsText.fontSize = 16
        removeAdsText.position = CGPoint(x: removeAdsButton.position.x, y: removeAdsButton.position.y * 0.99)
        removeAdsText.zPosition = removeAdsButton.zPosition + 1
        self.addChild(removeAdsText)
        
        if musicOn == true {
            
            musicSwitch.texture = SKTexture(imageNamed: "switchOn")
            
        }
        
        if musicOn == false {
            
            musicSwitch.texture = SKTexture(imageNamed: "switchOff")
            
        }
        
        musicSwitch.position = CGPoint(x: (self.frame.width/2) * 0.6, y: removeAdsButton.position.y * 0.8)
        musicSwitch.zPosition = 2
        self.addChild(musicSwitch)
        
        musicText.fontColor = yellow
        musicText.text = "Music"
        musicText.fontSize = 20
        musicText.position = CGPoint(x: musicSwitch.position.x, y: musicSwitch.position.y * 0.825)
        musicText.zPosition = 3
        self.addChild(musicText)
        
        if NSUserDefaults.standardUserDefaults().boolForKey("SFXAreEnabled") == true {
            
            SFXSwitch.texture = SKTexture(imageNamed: "switchOn")
            
        }
        
        if NSUserDefaults.standardUserDefaults().boolForKey("SFXAreEnabled") == false {
            
            SFXSwitch.texture = SKTexture(imageNamed: "switchOff")
            
        }
        
        SFXSwitch.position = CGPoint(x: (self.frame.width/2) * 1.4, y: removeAdsButton.position.y * 0.8)
        SFXSwitch.zPosition = 2
        self.addChild(SFXSwitch)
        
        SFXText.fontColor = yellow
        SFXText.text = "SFX"
        SFXText.fontSize = 20
        SFXText.position = CGPoint(x: SFXSwitch.position.x, y: SFXSwitch.position.y * 0.825)
        self.addChild(SFXText)
        
        if NSUserDefaults.standardUserDefaults().boolForKey("notificationsAreEnabled") == true {
            
            notificationsSwitch.texture = SKTexture(imageNamed: "switchOn")
            
        }
        
        if NSUserDefaults.standardUserDefaults().boolForKey("notificationsAreEnabled") == false {
            
            notificationsSwitch.texture = SKTexture(imageNamed: "switchOff")
            
        }
        
        notificationsSwitch.position = CGPoint(x: self.frame.width/2, y: removeAdsButton.position.y * 0.525)
        notificationsSwitch.zPosition = 2
        self.addChild(notificationsSwitch)
        
        notificationsText.fontColor = yellow
        notificationsText.text = "Notifications"
        notificationsText.fontSize = 20
        notificationsText.position = CGPoint(x: notificationsSwitch.position.x, y: notificationsSwitch.position.y * 0.725)
        self.addChild(notificationsText)
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        //
        
        println(musicOn)
        
        if musicOn == false {
            
            musicSwitch.texture = SKTexture(imageNamed: "switchOff")
            
        }
        
        if musicOn == true {
            
            musicSwitch.texture = SKTexture(imageNamed: "switchOn")
            
        }
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            let backButton = self.childNodeWithName("backButton")
            if CGRectContainsPoint(backButton!.frame, location) {
                var theGame = GameScene(size: self.size)
                let skView = self.view as SKView!
                skView.ignoresSiblingOrder = true
                theGame.scaleMode = scaleMode
                theGame.size = skView.bounds.size
                self.removeAllChildren()
                skView.presentScene(theGame)
            }
            
            if CGRectContainsPoint(websiteButton.frame, location) || CGRectContainsPoint(websiteText.frame, location) {
                
                UIApplication.sharedApplication().openURL(NSURL(string:"http://stackexchange.com/")!)
                
            }
            
            if CGRectContainsPoint(musicSwitch.frame, location) && musicOn == true {
                musicOn = false
            }
            
            if CGRectContainsPoint(musicSwitch.frame, location) && musicOn == false {
                musicOn = true
            }
            
        }
    }
}