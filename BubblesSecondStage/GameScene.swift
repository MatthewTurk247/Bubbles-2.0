//
//  GameScene.swift
//  BubblesFirstStage
//
//  Created by Matthew Turk on 6/14/15.
//  Copyright (c) 2015 Bubbles, Inc. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit
import AVFoundation

class GameScene: SKScene {

    var language = NSBundle.mainBundle().preferredLocalizations.first as! NSString
    let versionLabel:SKLabelNode = SKLabelNode(fontNamed: "Futura")
    var version:AnyObject! = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString")
    func randRange (lower: CGFloat, upper: CGFloat) -> CGFloat {
        return lower + CGFloat(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    let title:SKLabelNode = SKLabelNode(fontNamed: "Futura")
    let highScoreLabel:SKLabelNode = SKLabelNode(fontNamed: "Futura")
    let playText:SKLabelNode = SKLabelNode(fontNamed: "Futura")
    let blue = SKColor(red: 29.0/255, green: 141.0/255, blue: 180.0/255, alpha: 1.0)
    let black = SKColor(red: 80.0/255, green: 80.0/255, blue: 80.0/255, alpha: 1.0)
    let yellow = SKColor(red: 255.0/255, green: 245.0/255, blue: 195.0/255, alpha: 1.0)
    let green = SKColor(red: 155.0/255, green: 215.0/255, blue: 213.0/255, alpha: 1.0)
    let red = SKColor(red: 255.0/255, green: 114.0/255, blue: 96.0/255, alpha: 1.0)
    let playButton:SKSpriteNode = SKSpriteNode(imageNamed: "playButton")
    let topVacuum = SKSpriteNode(imageNamed: "topVacuumIdle")
    let bottomVacuum = SKSpriteNode(imageNamed: "bottomVacuumIdle")
    var timePassed:Int = 0
    let topLeft = SKSpriteNode(imageNamed: "cornerButton")
    let topRight = SKSpriteNode(imageNamed: "cornerButton")
    let bottomLeft = SKSpriteNode(imageNamed: "cornerButton")
    let bottomRight = SKSpriteNode(imageNamed: "cornerButton")
    let settingsButton = SKSpriteNode(imageNamed: "settingsButton")
    let infoDisclosureButton = SKSpriteNode(imageNamed: "infoDisclosureButton")
    let pauseButton = SKSpriteNode(imageNamed: "pauseButton")
    var cloudMoveAndRemove = SKAction()
    var cloudTexture = SKTexture(imageNamed: "cloud")
    var lives:Int = 3
    let life1 = SKSpriteNode(imageNamed: "heart")
    let life2 = SKSpriteNode(imageNamed: "heart")
    let life3 = SKSpriteNode(imageNamed: "heart")
    var backgroundMusicPlayer:AVAudioPlayer = AVAudioPlayer()
    
    override func didMoveToView(view: SKView) {

        var bgMusicURL:NSURL = NSBundle.mainBundle().URLForResource("neverMind", withExtension: "mp3")!
        backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.volume = 0.5
        if NSUserDefaults.standardUserDefaults().boolForKey("music") == true {
            backgroundMusicPlayer.prepareToPlay()
            backgroundMusicPlayer.play()
        }
        println(bottomRight.yScale)
        println(bottomRight.frame.height)
        println(UIScreen.mainScreen().bounds)
        println(language)
        self.scene?.backgroundColor = blue
        func createAndMoveClouds() {
            //Cloud spawning
            let spawnACloud = SKAction.runBlock({let cloud = SKSpriteNode(imageNamed: "cloud")
                let y = arc4random() % UInt32(self.frame.size.height)
                var randomSize = CGFloat(Float(arc4random()) / Float(UINT32_MAX)) - 0.4
                if randomSize < 0.0 {
                    randomSize = 0.2
                }
                cloud.zPosition = -11
                var randomHeight = UInt32(self.frame.size.height / 1.5) + (arc4random() % UInt32(self.frame.size.height / 2))
                cloud.setScale(randomSize)
                cloud.position = CGPointMake(self.frame.size.width + cloud.size.width, CGFloat(randomHeight))
                
                cloud.runAction(self.cloudMoveAndRemove)
                self.addChild(cloud)})
            let spawnThenDelayCloud = SKAction.sequence([spawnACloud, SKAction.waitForDuration(6.0)])
            let spawnThenDelayCloudForever = SKAction.repeatActionForever(spawnThenDelayCloud)
            self.runAction(spawnThenDelayCloudForever)
            let clouddistanceToMove = CGFloat(self.frame.width + 4.0 * cloudTexture.size().width)
            let cloudmovement = SKAction.moveByX(-clouddistanceToMove, y: 0.0, duration: NSTimeInterval(0.025 * clouddistanceToMove))
            let removeCloud = SKAction.removeFromParent()
            cloudMoveAndRemove = SKAction.sequence([cloudmovement, removeCloud])
        }
        
        //createAndMoveClouds()
        
        title.fontColor = yellow
        title.text = "BUBBLES"
        if UIScreen.mainScreen().bounds == CGRect(x: 0.0, y: 0.0, width: 320.0, height: 480.0) {
            title.fontSize = 45
        } else {
            title.fontSize = 64
        }
        title.position = CGPoint(x: self.frame.width * 0.5, y: self.frame.height * 0.725)
        self.addChild(title)
        
        highScoreLabel.fontColor = yellow
        //Eventually will have the NSUserDefaults stuff here and SaveData.swift
        var highScore = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
        highScoreLabel.text = "BEST: \(highScore)"
        highScoreLabel.fontSize = 29
        highScoreLabel.position = CGPoint(x: self.frame.width * 0.5, y: title.position.y * 0.925)
        self.addChild(highScoreLabel)
        
        playButton.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.45)
        playButton.setScale(1/3)
        self.addChild(playButton)
        
        playText.fontColor = SKColor.whiteColor()
        playText.text = "Play"
        playText.fontSize = 26
        playText.position = CGPoint(x: playButton.position.x, y: playButton.position.y * 0.985)
        playText.zPosition = 3
        self.addChild(playText)
        
        topVacuum.setScale(1/3)
        topVacuum.position = CGPoint(x: self.frame.width * 0.5, y: self.frame.height - 0.5 * (topVacuum.frame.height))
        topVacuum.zPosition = 4
        self.addChild(topVacuum)
        
        bottomVacuum.setScale(1/3)
        bottomVacuum.position = CGPoint(x: self.frame.width * 0.5, y: 0.5 * (bottomVacuum.frame.height))
        bottomVacuum.zPosition = 4
        self.addChild(bottomVacuum)
        
        let topLeftRect = SKShapeNode(rect: CGRect(x: self.frame.origin.x, y: self.frame.height - (self.topVacuum.frame.height) + 1, width: self.frame.width * 0.5, height: self.topVacuum.frame.height))
        topLeftRect.zPosition = topVacuum.zPosition - 1
        topLeftRect.strokeColor = red
        topLeftRect.fillColor = red
        topLeftRect.name = "topLeftRect"
        self.addChild(topLeftRect)
        
        let topRightRect = SKShapeNode(rect: CGRect(x: self.frame.width/2, y: self.frame.height - (self.topVacuum.frame.height) + 1, width: self.frame.width * 0.5, height: self.topVacuum.frame.height))
        topRightRect.zPosition = topVacuum.zPosition - 1
        topRightRect.strokeColor = red
        topRightRect.fillColor = red
        topRightRect.name = "topRightRect"
        self.addChild(topRightRect)
        
        let bottomRightRect = SKShapeNode(rect: CGRect(x: self.frame.width/2, y: self.frame.origin.y, width: self.frame.width * 0.5, height: self.bottomVacuum.frame.height - 1))
        bottomRightRect.zPosition = bottomVacuum.zPosition - 1
        bottomRightRect.strokeColor = red
        bottomRightRect.fillColor = red
        topRightRect.name = "right"
        self.addChild(bottomRightRect)
        
        let bottomLeftRect = SKShapeNode(rect: CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width * 0.5, height: self.bottomVacuum.frame.height - 1))
        bottomLeftRect.zPosition = bottomVacuum.zPosition - 1
        bottomLeftRect.strokeColor = red
        bottomLeftRect.fillColor = red
        bottomLeftRect.name = "left"
        self.addChild(bottomLeftRect)
        println(bottomLeftRect.frame.height)
        
        topVacuum.setScale(1/3)
        //self.addChild(topLeft)
        
        topRight.position = CGPoint(x: (self.frame.width * 0.5) + topRight.frame.width, y: topLeft.position.y)
        topRight.setScale(1.0)
        topRight.zPosition = topVacuum.zPosition - 1
        println(UIScreen.mainScreen().bounds)
        
        //self.addChild(topRight)
        
        bottomLeft.position = CGPoint(x: topLeft.position.x, y: bottomLeft.frame.height/2.1)
        bottomLeft.setScale(1.0)
        bottomLeft.zPosition = topVacuum.zPosition - 1
        //self.addChild(bottomLeft)
        
        bottomRight.position = CGPoint(x: topRight.position.x, y: bottomLeft.position.y)
        bottomRight.setScale(1.0)
        bottomRight.zPosition = topVacuum.zPosition - 1
        //self.addChild(bottomRight)
        println("Hello \(bottomLeft.position)")
        settingsButton.position = CGPoint(x: (self.frame.width * 0.5) - topLeft.frame.width, y: bottomLeftRect.frame.height/2)
        settingsButton.zPosition = bottomLeft.zPosition + 5
        settingsButton.setScale(0.6667)
        self.addChild(settingsButton)
        
        infoDisclosureButton.position = CGPointMake((self.frame.width * 0.5) + topRight.frame.width, bottomRightRect.frame.height/2)
        println(infoDisclosureButton.position)
        infoDisclosureButton.zPosition = bottomRightRect.zPosition + 5
        infoDisclosureButton.setScale(0.6667)
        self.addChild(infoDisclosureButton)
        
        pauseButton.position = CGPoint(x: topLeft.position.x * 0.95, y: topLeft.position.y * 1.015)
        pauseButton.zPosition = topLeft.zPosition + 5
        
        life1.position = CGPoint(x: topRight.position.x * 0.95, y: topRight.position.y * 1.0388667)
        life1.zPosition = topRight.zPosition + 5
        
        life2.position = CGPoint(x: life1.position.x * 1.06667, y: life1.position.y * 0.975)
        life2.zPosition = topRight.zPosition + 5
        
        life3.position = CGPoint(x: life2.position.x * 1.06667, y: life2.position.y * 0.9725)
        life3.zPosition = topRight.zPosition + 5
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)

            if CGRectContainsPoint(infoDisclosureButton.frame, location) || CGRectContainsPoint(CGRect(x: self.frame.width/2, y: self.frame.origin.y, width: self.frame.width * 0.5, height: self.bottomVacuum.frame.height - 1), location) {
                var theInfo = InfoScene(size: self.view!.bounds.size)
                let skView = self.view as SKView!
                skView.ignoresSiblingOrder = true
                theInfo.scaleMode = .AspectFill
                theInfo.size = skView.bounds.size
                self.removeAllChildren()
                self.removeAllActions()
                if NSUserDefaults.standardUserDefaults().boolForKey("music") == true {
                    backgroundMusicPlayer.pause()
                }
                skView.presentScene(theInfo, transition: SKTransition.crossFadeWithDuration(0.25))
            }
            
            if CGRectContainsPoint(settingsButton.frame, location) || CGRectContainsPoint(CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width * 0.5, height: self.bottomVacuum.frame.height - 1), location) {
                var theSettings = SettingsScene(size: self.view!.bounds.size)
                let skView = self.view as SKView!
                skView.ignoresSiblingOrder = true
                theSettings.scaleMode = .AspectFill
                theSettings.size = skView.bounds.size
                self.removeAllChildren()
                self.removeAllActions()
                if NSUserDefaults.standardUserDefaults().boolForKey("music") == true {
                    backgroundMusicPlayer.pause()
                }
                skView.presentScene(theSettings, transition: SKTransition.crossFadeWithDuration(0.25))
            }

      
            if CGRectContainsPoint(playButton.frame, location) || CGRectContainsPoint(playText.frame, location) {
                    var theGamePlay = GamePlayScene(size: self.view!.bounds.size)
                    let skView = self.view as SKView!
                    skView.ignoresSiblingOrder = true
                    theGamePlay.scaleMode = .ResizeFill
                    theGamePlay.size = skView.bounds.size
                    self.removeAllChildren()
                    self.removeAllActions()
                if NSUserDefaults.standardUserDefaults().boolForKey("music") == true {
                    backgroundMusicPlayer.pause()
                }
                    skView.presentScene(theGamePlay, transition: SKTransition.crossFadeWithDuration(0.25))
            }
                
            
        }
    }
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
            timePassed++
            let spawnABubble = SKAction.runBlock({let bubble:SKSpriteNode = SKSpriteNode(imageNamed: "bubble")
            let bubbleCategory:UInt64 = 0x1 << 0   //0000000000000000000000000000000000000000000000000000000000000001
            bubble.zPosition = self.playButton.zPosition - 1
            bubble.physicsBody = SKPhysicsBody(circleOfRadius: bubble.frame.size.width/2)
            bubble.physicsBody?.mass = 1.0
            bubble.physicsBody?.friction = 1.0
            bubble.physicsBody?.restitution = 1.0
            bubble.physicsBody?.linearDamping = 0
            bubble.physicsBody?.density = 0.5
            bubble.physicsBody?.affectedByGravity = false
            bubble.xScale = 1
            bubble.yScale = 1
            bubble.position = CGPoint(x: self.randRange(self.frame.width * 0.35, upper: self.frame.width * 0.65), y: self.randRange(self.frame.height * 0.25, upper: self.frame.height * 0.75))
            bubble.name = "bubble"
            bubble.setScale(1/3)
            let bubbleRotationAction = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            bubble.runAction(SKAction.repeatActionForever(bubbleRotationAction))
            if self.timePassed % 500 == 0 || self.timePassed == 1 {
                self.addChild(bubble)
            }
        })
        let handleBubbles = SKAction.sequence([spawnABubble])
        self.runAction(handleBubbles)
        println(timePassed)
    }
}
