//
//  GamePlayScene.swift
//  BubblesSecondStage
//
//  Created by Matthew Turk on 6/20/15.
//  Copyright (c) 2015 Bubbles, Inc. All rights reserved.
//

import Foundation
import SpriteKit

class GamePlayScene:SKScene, SKPhysicsContactDelegate {
    
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
    var score = 0
    var timePassed:Int = 0
    var isGamePaused:Bool = false
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
    let pauseButton = SKSpriteNode(imageNamed: "pauseButton")
    var cloudMoveAndRemove = SKAction()
    var cloudTexture = SKTexture(imageNamed: "cloud")
    var lives:Int = 3
    let life1 = SKSpriteNode(imageNamed: "heart")
    let life2 = SKSpriteNode(imageNamed: "heart")
    let life3 = SKSpriteNode(imageNamed: "heart")
    let pauseMenuQuitButton = SKSpriteNode(imageNamed: "pillButtonRed")
    let pauseMenuQuitText = SKLabelNode(fontNamed: "Futura")
    let pauseMenuRestartButton = SKSpriteNode(imageNamed: "pillButtonRed")
    let pauseMenuRestartText = SKLabelNode(fontNamed: "Futura")
    let bubbleCategory:UInt32 = 0x1 << 0
    let bottomCategory:UInt32 = 0x1 << 1

    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        self.view?.scene?.backgroundColor = blue
        title.fontColor = yellow
        title.text = "\(score)"
        title.fontSize = 64
        title.position = CGPoint(x: self.frame.width * 0.5, y: self.frame.height * 0.725)
        self.addChild(title)
        
        topVacuum.position = CGPoint(x: self.frame.width * 0.5, y: self.frame.height - 0.5 * (topVacuum.frame.height))
        topVacuum.setScale(1.2)
        topVacuum.zPosition = 4
        self.addChild(topVacuum)
        
        bottomVacuum.position = CGPoint(x: self.frame.width * 0.5, y: 0.5 * (bottomVacuum.frame.height))
        bottomVacuum.setScale(1.2)
        bottomVacuum.zPosition = 4
        self.addChild(bottomVacuum)
        
        let bottomRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.width, 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFromRect: bottomRect)
        
        self.addChild(bottom)
        
        bottom.physicsBody?.categoryBitMask = bottomCategory
        
        
        let worldBorder = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody = worldBorder
        self.physicsBody?.friction = 0
        
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
        
        highScoreLabel.fontColor = yellow
        //Eventually will have the NSUserDefaults stuff here and SaveData.swift
        var highScore = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
        highScoreLabel.text = "BEST: \(highScore)"
        highScoreLabel.fontSize = 29
        highScoreLabel.position = CGPoint(x: self.frame.width * 0.5, y: title.position.y * 0.925)
        self.addChild(highScoreLabel)
        let bubble:SKSpriteNode = SKSpriteNode(imageNamed: "bubble")
        let bubbleCatagory:UInt64 = 0x1 << 0   //0000000000000000000000000000000000000000000000000000000000000001
        bubble.name = "bubble"
        pauseButton.position = CGPoint(x: topLeft.position.x * 0.85, y: topLeft.position.y * 1.02)
        pauseButton.zPosition = topLeft.zPosition + 5
        life1.position = CGPoint(x: topRight.position.x * 0.9, y: topRight.position.y * 1.045)
        life1.zPosition = topRight.zPosition + 5
        
        life2.position = CGPoint(x: life1.position.x * 1.1, y: life1.position.y * 0.975)
        life2.zPosition = topRight.zPosition + 5
        
        life3.position = CGPoint(x: life2.position.x * 1.09, y: life2.position.y * 0.9725)
        life3.zPosition = topRight.zPosition + 5

        self.addChild(pauseButton)
        self.addChild(life1)
        self.addChild(life2)
        self.addChild(life3)
        
        pauseMenuQuitButton.position = CGPoint(x: (self.frame.width/2) * 0.52, y: highScoreLabel.position.y * 0.9)
        pauseMenuQuitButton.zPosition = 2
        pauseMenuQuitButton.setScale(0.089)
        
        pauseMenuRestartButton.position = CGPoint(x: (self.frame.width/2) * 1.48, y: highScoreLabel.position.y * 0.9)
        pauseMenuRestartButton.zPosition = 2
        pauseMenuRestartButton.setScale(0.089)
        
        pauseMenuQuitText.fontColor = SKColor.whiteColor()
        pauseMenuQuitText.text = "Quit"
        pauseMenuQuitText.fontSize = 16
        pauseMenuQuitText.position = CGPoint(x: pauseMenuQuitButton.position.x, y: pauseMenuQuitButton.position.y * 0.99)
        pauseMenuQuitText.zPosition = pauseMenuQuitButton.zPosition + 1
        
        pauseMenuRestartText.fontColor = SKColor.whiteColor()
        pauseMenuRestartText.text = "Restart"
        pauseMenuRestartText.fontSize = 16
        pauseMenuRestartText.position = CGPoint(x: pauseMenuRestartButton.position.x, y: pauseMenuRestartButton.position.y * 0.99)
        pauseMenuRestartText.zPosition = pauseMenuRestartButton.zPosition + 1

    }
    
    func pauseGame() {
        
        isGamePaused = true
        self.paused = true
        //Add pause menu etc.
        let tintScreenRect = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height)
        let tintScreen = SKShapeNode(rect: tintScreenRect)
        tintScreen.strokeColor = SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.25)
        tintScreen.fillColor = SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.25)
        tintScreen.zPosition = 2
        tintScreen.name = "tintScreen"
        self.addChild(tintScreen)
        title.zPosition = 3
        highScoreLabel.zPosition = 3
        highScoreLabel.text = "PAUSED"
        pauseButton.texture = SKTexture(imageNamed: "resumeButton")
        pauseButton.setScale(0.9)
        self.addChild(pauseMenuQuitButton)
        self.addChild(pauseMenuQuitText)
        self.addChild(pauseMenuRestartButton)
        self.addChild(pauseMenuRestartText)
        //Added Pause Menu
    }
    
    func resumeGame() {
        
        isGamePaused = false
        self.paused = false
        //Remove pause menu etc.
        childNodeWithName("tintScreen")?.removeFromParent()
        title.zPosition = 2
        highScoreLabel.zPosition = 2
        var highScore = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
        highScoreLabel.text = "BEST: \(highScore)"
        pauseButton.texture = SKTexture(imageNamed: "pauseButton")
        //Removed Pause Menu
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            var node = self.nodeAtPoint(location)
            if self.nodeAtPoint(location).name == "bubble" {
                
                println("TOUCHED")
                self.nodeAtPoint(location).physicsBody?.applyImpulse(CGVectorMake(randRange(-5, upper: 5), randRange(self.nodeAtPoint(location).position.y + 5, upper: 25)))
                score++
                
            } else {
            
                println("MISSED")
            
            }

            if CGRectContainsPoint(pauseButton.frame, location) && (!isGamePaused) {
                
                pauseGame()
                
            }
            if CGRectContainsPoint(pauseMenuQuitButton.frame, location) == true || CGRectContainsPoint(pauseMenuQuitText.frame, location) == true && isGamePaused == true {
            var theGame = GameScene(size: self.view!.bounds.size)
            let skView = self.view as SKView!
            skView.ignoresSiblingOrder = true
            theGame.scaleMode = .AspectFill
            theGame.size = skView.bounds.size
            self.removeAllChildren()
            self.removeAllActions()
            skView.presentScene(theGame, transition: SKTransition.crossFadeWithDuration(0.25))
            }
            
            if CGRectContainsPoint(pauseMenuRestartButton.frame, location) == true || CGRectContainsPoint(pauseMenuRestartText.frame, location) == true && isGamePaused == true {
            var theGamePlay = GamePlayScene(size: self.view!.bounds.size)
            let skView = self.view as SKView!
            skView.ignoresSiblingOrder = true
            theGamePlay.scaleMode = .AspectFill
            theGamePlay.size = skView.bounds.size
            self.removeAllChildren()
            self.removeAllActions()
            skView.presentScene(theGamePlay, transition: SKTransition.crossFadeWithDuration(0.25))
            }
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        let bubble:SKSpriteNode = SKSpriteNode(imageNamed: "bubble")
        bubble.physicsBody = SKPhysicsBody(circleOfRadius: bubble.frame.size.width/2)
        bubble.physicsBody?.friction = 0.2
        bubble.physicsBody?.restitution = 0.6
        bubble.physicsBody?.linearDamping = 0.0
        bubble.physicsBody?.affectedByGravity = true
        bubble.xScale = 1
        bubble.yScale = 1
        bubble.position = CGPoint(x: self.randRange(self.frame.width * 0.35, upper: self.frame.width * 0.65), y: self.randRange(self.frame.height * 0.25, upper: self.frame.height * 0.75))
        bubble.name = "bubble"
        let bubbleRotationAction = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        bubble.runAction(SKAction.repeatActionForever(bubbleRotationAction))
        bubble.physicsBody?.categoryBitMask = self.bubbleCategory
        bubble.physicsBody?.contactTestBitMask = self.bottomCategory
        
        if firstBody.categoryBitMask == bubbleCategory && secondBody.categoryBitMask == bottomCategory {
            
            firstBody.node?.removeFromParent()
            //self.addChild(bubble)
            //bubble.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 0))
            
        }
        
    }

    
    override func update(currentTime: NSTimeInterval) {
        if score > NSUserDefaults.standardUserDefaults().integerForKey("highscore") {
            //Do anything here when the user has a new highscore
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey: "highscore")
            NSUserDefaults.standardUserDefaults().synchronize()
            highScoreLabel.text = "NEW BEST"
            highScoreLabel.fontColor = red
            title.fontColor = red
        }
        timePassed++
        println(timePassed)
        println(lives)
        var elapsedTime = 0...timePassed
        for time in elapsedTime {
            
            switch time {
                
            case 0...10: title.text = "READY"
            case 11...20: title.text = "SET"
            case 21: title.text = "GO"
            case 22...27: title.text = ""
            default: title.text = "\(score)"
                
            }
            
        }
        
        let spawnABubble = SKAction.runBlock({let bubble:SKSpriteNode = SKSpriteNode(imageNamed: "bubble")
            bubble.physicsBody = SKPhysicsBody(circleOfRadius: bubble.frame.size.width/2)
            //bubble.physicsBody?.mass = 1.0
            bubble.physicsBody?.friction = 0.2
            bubble.physicsBody?.restitution = 0.6
            bubble.physicsBody?.linearDamping = 0.0
            bubble.physicsBody?.affectedByGravity = true
            bubble.xScale = 1
            bubble.yScale = 1
            bubble.position = CGPoint(x: self.randRange(self.frame.width * 0.35, upper: self.frame.width * 0.65), y: self.randRange(self.frame.height * 0.25, upper: self.frame.height * 0.75))
            bubble.name = "bubble"
            let bubbleRotationAction = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            bubble.runAction(SKAction.repeatActionForever(bubbleRotationAction))
            bubble.physicsBody?.categoryBitMask = self.bubbleCategory
            bubble.physicsBody?.contactTestBitMask = self.bottomCategory
            if self.timePassed % 500 == 0 || self.timePassed == 30 {
                self.addChild(bubble)
                bubble.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 0))
            }
        })
        let handleBubbles = SKAction.sequence([spawnABubble])
        self.runAction(handleBubbles)
    }

}