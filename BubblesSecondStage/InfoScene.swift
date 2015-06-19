//
//  InfoScene.swift
//  BubblesFirstStage
//
//  Created by Matthew Turk on 6/15/15.
//  Copyright (c) 2015 Bubbles, Inc. All rights reserved.
//

import SpriteKit
import Foundation

class InfoScene:SKScene {
    let title:SKLabelNode = SKLabelNode(fontNamed: "Futura")
    let blue = SKColor(red: 29.0/255, green: 141.0/255, blue: 180.0/255, alpha: 1.0)
    let black = SKColor(red: 80.0/255, green: 80.0/255, blue: 80.0/255, alpha: 1.0)
    let yellow = SKColor(red: 255.0/255, green: 245.0/255, blue: 195.0/255, alpha: 1.0)
    let green = SKColor(red: 155.0/255, green: 215.0/255, blue: 213.0/255, alpha: 1.0)
    let red = SKColor(red: 255.0/255, green: 114.0/255, blue: 96.0/255, alpha: 1.0)
    let versionLabel:SKLabelNode = SKLabelNode(fontNamed: "Futura")
    var version:AnyObject! = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString")
    let leadDeveloperLabel = SKLabelNode(fontNamed: "Futura")
    let gameDesignerLabel = SKLabelNode(fontNamed: "Futura")
    let marketingAmpersandPRLabel = SKLabelNode(fontNamed: "Futura")
    let financeAmpersandLaw = SKLabelNode(fontNamed: "Futura")
    let copyrightNoticeLabel = SKLabelNode(fontNamed: "Futura")
    let moreInfoLabel = SKLabelNode(fontNamed: "Futura")
    let tutorialButton = SKSpriteNode(imageNamed: "pillButtonGreen")
    let tutorialText = SKLabelNode(fontNamed: "Futura")
    
    override func didMoveToView(view: SKView) {
        self.scene?.backgroundColor = blue
        
        title.fontColor = yellow
        title.text = "BUBBLES"
        title.fontSize = 64
        title.position = CGPoint(x: self.frame.width * 0.5, y: self.frame.height * 0.725)
        self.addChild(title)
        
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
        
        leadDeveloperLabel.fontColor = SKColor.whiteColor()
        leadDeveloperLabel.text = "Lead Developer: Matthew Turk"
        leadDeveloperLabel.fontSize = 24
        leadDeveloperLabel.position = CGPoint(x: self.frame.width/2, y: versionLabel.position.y * 0.9)
        self.addChild(leadDeveloperLabel)
        
        gameDesignerLabel.fontColor = SKColor.whiteColor()
        gameDesignerLabel.text = "Game Designer: Matthew Turk"
        gameDesignerLabel.fontSize = 24
        gameDesignerLabel.position = CGPoint(x: self.frame.width/2, y: versionLabel.position.y * 0.75)
        self.addChild(gameDesignerLabel)
        
        marketingAmpersandPRLabel.fontColor = SKColor.whiteColor()
        marketingAmpersandPRLabel.text = "Marketing & PR: First Last"
        marketingAmpersandPRLabel.fontSize = 24
        marketingAmpersandPRLabel.position = CGPoint(x: self.frame.width/2, y: versionLabel.position.y * 0.6)
        self.addChild(marketingAmpersandPRLabel)
        
        financeAmpersandLaw.fontColor = SKColor.whiteColor()
        financeAmpersandLaw.text = "Finance & Law: First Last"
        financeAmpersandLaw.fontSize = 24
        financeAmpersandLaw.position = CGPoint(x: self.frame.width/2, y: versionLabel.position.y * 0.45)
        self.addChild(financeAmpersandLaw)
        
        let backButton = SKShapeNode(rect: CGRect(x: self.frame.origin.x, y: self.frame.height - (self.frame.height * 0.14), width: self.frame.width * 0.25, height: self.frame.height * 0.14))
        backButton.fillColor = red
        backButton.strokeColor = red
        backButton.zPosition = 6
        backButton.name = "backButton"
        self.addChild(backButton)
        println("backButtonAdded")
        
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
        
        tutorialButton.position = CGPoint(x: backButton.frame.width + (backButton.frame.width * 1.5), y: self.frame.height * 0.93)
        tutorialButton.zPosition = 6
        self.addChild(tutorialButton)
        
        let redStrip = SKShapeNode(rect: CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height * 0.14))
        redStrip.fillColor = red
        redStrip.strokeColor = red
        redStrip.zPosition = 5
        redStrip.name = "redStrip"
        self.addChild(redStrip)
        
        tutorialText.fontColor = SKColor.whiteColor()
        tutorialText.text = "Watch Tutorial"
        tutorialText.fontSize = 24
        tutorialText.position = CGPoint(x: tutorialButton.position.x, y: tutorialButton.position.y * 0.99)
        tutorialText.zPosition = tutorialButton.zPosition + 1
        self.addChild(tutorialText)
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        //
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
                //theGame.size = skView.bounds.size
                self.removeAllChildren()
                skView.presentScene(theGame)
            }
            
        }
    }
}