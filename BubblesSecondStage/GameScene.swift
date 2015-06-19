//
//  GameScene.swift
//  BubblesFirstStage
//
//  Created by Matthew Turk on 6/14/15.
//  Copyright (c) 2015 Bubbles, Inc. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
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
    func playTopVacuumAnimation() {
        
        let topVacuum0 = SKTexture(imageNamed: "topVacuumAnim0")
        let topVacuum1 = SKTexture(imageNamed: "topVacuumAnim1")
        
        let topTextureAnim = SKAction.animateWithTextures([topVacuum0, topVacuum1], timePerFrame: 0.5)
        let topVacuumAnim = SKAction.repeatActionForever(topTextureAnim)
        topVacuum.runAction(topVacuumAnim)
    }
    func playBottomVacuumAnimation() {
        
        let bottomVacuum0 = SKTexture(imageNamed: "bottomVacuumAnim0")
        let bottomVacuum1 = SKTexture(imageNamed: "bottomVacuumAnim1")
        
        let bottomTextureAnim = SKAction.animateWithTextures([bottomVacuum0, bottomVacuum1], timePerFrame: 0.5)
        let bottomVacuumAnim = SKAction.repeatActionForever(bottomTextureAnim)
        bottomVacuum.runAction(bottomTextureAnim)
        
    }
    let topLeft = SKSpriteNode(imageNamed: "cornerButton")
    let topRight = SKSpriteNode(imageNamed: "cornerButton")
    let bottomLeft = SKSpriteNode(imageNamed: "cornerButton")
    let bottomRight = SKSpriteNode(imageNamed: "cornerButton")
    let settingsButton = SKSpriteNode(imageNamed: "settingsButton")
    let infoDisclosureButton = SKSpriteNode(imageNamed: "infoDisclosureButton")
    var cloudMoveAndRemove = SKAction()
    var cloudTexture = SKTexture(imageNamed: "cloud")
    
    
    override func didMoveToView(view: SKView) {
        self.scene?.backgroundColor = blue
        println(SaveData().SFXAreEnabled)
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
        title.fontSize = 64
        title.position = CGPoint(x: self.frame.width * 0.5, y: self.frame.height * 0.725)
        self.addChild(title)
        
        highScoreLabel.fontColor = yellow
        //Eventually will have the NSUserDefaults stuff here and SaveData.swift
        highScoreLabel.text = "BEST: 58"
        highScoreLabel.fontSize = 29
        highScoreLabel.position = CGPoint(x: self.frame.width * 0.5, y: title.position.y * 0.925)
        self.addChild(highScoreLabel)
        
        playButton.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.45)
        playButton.setScale(1.25)
        self.addChild(playButton)
        
        playText.fontColor = SKColor.whiteColor()
        playText.text = "Play"
        playText.fontSize = 26
        playText.position = CGPoint(x: playButton.position.x, y: playButton.position.y * 0.985)
        playText.zPosition = 3
        self.addChild(playText)
        
        topVacuum.position = CGPoint(x: self.frame.width * 0.5, y: self.frame.height - 0.5 * (topVacuum.frame.height))
        topVacuum.setScale(1.2)
        topVacuum.zPosition = 4
        self.addChild(topVacuum)
        
        bottomVacuum.position = CGPoint(x: self.frame.width * 0.5, y: 0.5 * (bottomVacuum.frame.height))
        bottomVacuum.setScale(1.2)
        bottomVacuum.zPosition = 4
        self.addChild(bottomVacuum)
        
        
        topLeft.position = CGPoint(x: (self.frame.width * 0.5) - topLeft.frame.width, y: self.frame.height - (topLeft.frame.height/2.1))
        topLeft.setScale(1.2)
        topLeft.zPosition = topVacuum.zPosition - 1
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            topLeft.xScale = 2.4
        } else {
            
            topLeft.xScale = 1.2
            
        }
        
        self.addChild(topLeft)
        
        topRight.position = CGPoint(x: (self.frame.width * 0.5) + topRight.frame.width, y: topLeft.position.y)
        topRight.setScale(1.2)
        topRight.zPosition = topVacuum.zPosition - 1
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            topRight.xScale = 2.4
        } else {
            
            topRight.xScale = 1.2
            
        }
        
        self.addChild(topRight)
        
        bottomLeft.position = CGPoint(x: topLeft.position.x, y: bottomLeft.frame.height/2.1)
        bottomLeft.setScale(1.2)
        bottomLeft.zPosition = topVacuum.zPosition - 1
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            bottomLeft.xScale = 2.4
        } else {
            
            bottomLeft.xScale = 1.2
            
        }
        
        self.addChild(bottomLeft)
        
        bottomRight.position = CGPoint(x: topRight.position.x, y: bottomLeft.position.y)
        bottomRight.setScale(1.2)
        bottomRight.zPosition = topVacuum.zPosition - 1
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            bottomRight.xScale = 2.4
        } else {
            
            bottomRight.xScale = 1.2
            
        }
        self.addChild(bottomRight)
        
        settingsButton.position = CGPoint(x: bottomLeft.position.x * 0.9, y: bottomLeft.position.y * 0.8)
        settingsButton.zPosition = bottomLeft.zPosition + 5
        self.addChild(settingsButton)
        
        infoDisclosureButton.position = CGPoint(x: bottomRight.position.x * 1.05, y: settingsButton.position.y)
        infoDisclosureButton.zPosition = bottomRight.zPosition + 5
        self.addChild(infoDisclosureButton)
        
    }
    
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            if CGRectContainsPoint(bottomRight.frame, location) {
                var theInfo = InfoScene(size: self.size)
                let skView = self.view as SKView!
                skView.ignoresSiblingOrder = true
                theInfo.scaleMode = scaleMode
                theInfo.size = skView.bounds.size
                self.removeAllChildren()
                skView.presentScene(theInfo)
            }
            
            if CGRectContainsPoint(bottomLeft.frame, location) {
                var theSettings = SettingsScene(size: self.size)
                let skView = self.view as SKView!
                skView.ignoresSiblingOrder = true
                theSettings.scaleMode = scaleMode
                theSettings.size = skView.bounds.size
                self.removeAllChildren()
                skView.presentScene(theSettings)
            }

            
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        timePassed++
        
        let spawnABubble = SKAction.runBlock({let bubble:SKSpriteNode = SKSpriteNode(imageNamed: "bubble")
            let bubbleCategoryName = "bubble"
            let bubbleCatagory:UInt64 = 0x1 << 0   //0000000000000000000000000000000000000000000000000000000000000001
            bubble.physicsBody = SKPhysicsBody(circleOfRadius: bubble.frame.size.width/2)
            bubble.physicsBody?.affectedByGravity = false
            bubble.physicsBody?.mass = 1.0
            bubble.physicsBody?.friction = 0.2
            bubble.physicsBody?.restitution = 0.6
            bubble.physicsBody?.linearDamping = 0
            bubble.xScale = 1
            bubble.yScale = 1
            bubble.position = CGPoint(x: self.randRange(self.frame.width * 0.35, upper: self.frame.width * 0.65), y: self.randRange(self.frame.height * 0.25, upper: self.frame.height * 0.75))
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
