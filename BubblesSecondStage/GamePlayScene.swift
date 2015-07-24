//
//  GamePlayScene.swift
//  BubblesSecondStage
//
//  Created by Matthew Turk on 6/20/15.
//  Copyright (c) 2015 Bubbles, Inc. All rights reserved.
//

import Foundation
import SpriteKit
import iAd
import GameKit
import AVFoundation
import QuartzCore

class GamePlayScene:SKScene, SKPhysicsContactDelegate, UINavigationControllerDelegate, GKGameCenterControllerDelegate, ADBannerViewDelegate {
    
    let versionLabel:SKLabelNode = SKLabelNode(fontNamed: "Futura")
    var version:AnyObject! = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString")
    func randRange (lower: CGFloat, upper: CGFloat) -> CGFloat {
        return lower + CGFloat(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    var bubblePop = SKAction.playSoundFileNamed("bubblePop.mp3", waitForCompletion: false)
    var bubbleSFX = SKAction.playSoundFileNamed("bubbleSFX.mp3", waitForCompletion: false)
    func playSound(sound : SKAction)
    {
        runAction(sound)
    }
    var adBannerView:ADBannerView!
    var justFailed:Bool = false
    var isGameOver = false
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
    //let gameOver
    let bubbleCategory:UInt32 = 0x1 << 0
    let bottomCategory:UInt32 = 0x1 << 1
    let topCategory:UInt32 = 0x1 << 2
    var isAntiGravity:Bool = false
    let topVacuumTextures = [SKTexture(imageNamed: "topAnim0"), SKTexture(imageNamed: "topAnim1")]
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
        println(isAntiGravity)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -3.333)
        self.physicsWorld.contactDelegate = self
        self.view?.scene?.backgroundColor = blue
        title.fontColor = yellow
        title.text = "\(score)"
        if UIScreen.mainScreen().bounds == CGRect(x: 0.0, y: 0.0, width: 320.0, height: 480.0) {
            title.fontSize = 45
        } else {
        title.fontSize = 64
        }
        title.position = CGPoint(x: self.frame.width * 0.5, y: self.frame.height * 0.725)
        self.addChild(title)
        pauseMenuQuitButton.zPosition = -1
        pauseMenuQuitText.zPosition = -1
        pauseMenuRestartButton.zPosition = -1
        pauseMenuRestartText.zPosition = -1
        
        topVacuum.position = CGPoint(x: self.frame.width * 0.5, y: self.frame.height - (topVacuum.frame.height/2))
        topVacuum.setScale(1.0)
        
//        topVacuum.yScale = 1.2
//        topVacuum.xScale = 1.2
        topVacuum.zPosition = 4
        self.addChild(topVacuum)
        bottomVacuum.position = CGPoint(x: self.frame.width * 0.5, y: (bottomVacuum.frame.height/2))
        bottomVacuum.setScale(1.0)
//        bottomVacuum.yScale = 1.2
//        bottomVacuum.xScale = 1.2
        bottomVacuum.zPosition = 4
        self.addChild(bottomVacuum)
        
        var bottomRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.width, 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFromRect: bottomRect)
        //bottom.physicsBody?.usesPreciseCollisionDetection = true
        self.addChild(bottom)
        
        bottom.physicsBody?.categoryBitMask = bottomCategory
        
        var topRect = CGRectMake(self.frame.origin.x, self.frame.height, self.frame.width, 1)
        let top = SKNode()
        top.physicsBody = SKPhysicsBody(edgeLoopFromRect: topRect)
        //top.physicsBody?.usesPreciseCollisionDetection = true
        self.addChild(top)
        
        top.physicsBody?.categoryBitMask = topCategory
        
        
        let worldBorder = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody = worldBorder
        self.physicsBody?.friction = 0
        
        topLeft.position = CGPoint(x: (self.frame.width * 0.5) - topLeft.frame.width, y: self.frame.height - (topLeft.frame.height/2.1))
        topLeft.setScale(1.0)
        topLeft.zPosition = topVacuum.zPosition - 1

        //self.addChild(topLeft)
        
        topRight.position = CGPoint(x: (self.frame.width * 0.5) + topRight.frame.width, y: topLeft.position.y)
        topRight.setScale(1.0)
        topRight.zPosition = topVacuum.zPosition - 1
        
        //self.addChild(topRight)
        
        bottomLeft.position = CGPoint(x: topLeft.position.x, y: bottomLeft.frame.height/2.1)
        bottomLeft.setScale(1.0)
        bottomLeft.zPosition = topVacuum.zPosition - 1
        
        //self.addChild(bottomLeft)
        
        bottomRight.position = CGPoint(x: topRight.position.x, y: bottomLeft.position.y)
        bottomRight.setScale(1.0)
        bottomRight.zPosition = topVacuum.zPosition - 1
        //self.addChild(bottomRight)
        
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
        topRightRect.name = "bottomRightRect"
        self.addChild(bottomRightRect)
        
        let bottomLeftRect = SKShapeNode(rect: CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width * 0.5, height: self.bottomVacuum.frame.height - 1))
        bottomLeftRect.zPosition = bottomVacuum.zPosition - 1
        bottomLeftRect.strokeColor = red
        bottomLeftRect.fillColor = red
        bottomLeftRect.name = "bottomLeftRect"
        self.addChild(bottomLeftRect)
        
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
        pauseButton.position = CGPoint(x: topLeftRect.frame.width * 0.25, y: topLeft.position.y * 1.02)
        pauseButton.zPosition = topLeft.zPosition + 5
        pauseButton.name = "pauseButton"
        life1.position = CGPoint(x: topRightRect.frame.width/1.3, y: topRight.position.y * 1.045)
        life1.zPosition = topRight.zPosition + 5
        life1.setScale(0.9)
        
        life2.position = CGPoint(x: life1.position.x * 1.1, y: life1.position.y * 0.975)
        life2.zPosition = topRight.zPosition + 5
        life2.setScale(0.9)
        
        life3.position = CGPoint(x: life2.position.x * 1.09, y: life2.position.y * 0.9725)
        life3.zPosition = topRight.zPosition + 5
        life3.setScale(0.9)

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
        
        pauseMenuRestartText.fontColor = SKColor.whiteColor()
        pauseMenuRestartText.text = "Restart"
        pauseMenuRestartText.fontSize = 16
        pauseMenuRestartText.position = CGPoint(x: pauseMenuRestartButton.position.x, y: pauseMenuRestartButton.position.y * 0.99)

    }
    
    func gameOver() {
        
        self.topVacuum.texture = SKTexture(imageNamed: "topVacuumIdle")
        self.bottomVacuum.texture = SKTexture(imageNamed: "bottomVacuumIdle")
        self.topVacuum.color = SKColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0/255.0)
        self.bottomVacuum.color = SKColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0/255.0)
        isGamePaused = true
        self.paused = true
        let tintScreenRect = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height)
        let tintScreen = SKShapeNode(rect: tintScreenRect)
        tintScreen.strokeColor = SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.25)
        tintScreen.fillColor = SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.25)
        tintScreen.zPosition = 2
        tintScreen.name = "tintScreen"
        self.addChild(tintScreen)
        
        let gameOverBackground = SKSpriteNode(imageNamed: "gameOver")
        gameOverBackground.zPosition = 3
        gameOverBackground.position = CGPoint(x: self.frame.width/2, y: self.highScoreLabel.position.y * 0.65)
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            gameOverBackground.yScale = 1.5
        } else if UIScreen.mainScreen().bounds == CGRect(x: 0.0, y: 0.0, width: 320.0, height: 480.0) {
            gameOverBackground.yScale = 0.85
        } else {
            gameOverBackground.yScale = 1.0
        }
        self.addChild(gameOverBackground)
        
        let gameOverMainMenuButton = SKSpriteNode(imageNamed: "pillButtonGreen")
        gameOverMainMenuButton.zPosition = 4
        gameOverMainMenuButton.position = CGPoint(x: self.frame.width/2, y: gameOverBackground.position.y * 1.3)
        gameOverMainMenuButton.setScale(0.1)
        gameOverMainMenuButton.name = "MainMenuButton"
        self.addChild(gameOverMainMenuButton)
        
        let gameOverPlayAgainButton = SKSpriteNode(imageNamed: "pillButtonBlue")
        gameOverPlayAgainButton.zPosition = 4
        gameOverPlayAgainButton.position = CGPoint(x: self.frame.width/2, y: gameOverBackground.position.y * 1.0)
        gameOverPlayAgainButton.setScale(0.1)
        gameOverPlayAgainButton.name = "PlayAgainButton"
        self.addChild(gameOverPlayAgainButton)
        
        let gameOverGameCenterButton = SKSpriteNode(imageNamed: "pillButtonGrey")
        gameOverGameCenterButton.zPosition = 4
        gameOverGameCenterButton.position = CGPoint(x: self.frame.width/2, y: gameOverBackground.position.y * 0.7)
        gameOverGameCenterButton.setScale(0.1)
        gameOverGameCenterButton.name = "GameCenterButton"
        self.addChild(gameOverGameCenterButton)
        
        let gameOverMainMenuLabel = SKLabelNode(fontNamed: "Futura")
        gameOverMainMenuLabel.fontColor = SKColor.whiteColor()
        gameOverMainMenuLabel.fontSize = 16
        gameOverMainMenuLabel.position = CGPoint(x: gameOverMainMenuButton.position.x, y: gameOverMainMenuButton.position.y * 0.99)
        gameOverMainMenuLabel.zPosition = 5
        gameOverMainMenuLabel.text = "Main Menu"
        gameOverMainMenuLabel.name = "MainMenuLabel"
        self.addChild(gameOverMainMenuLabel)
        
        let gameOverPlayAgainLabel = SKLabelNode(fontNamed: "Futura")
        gameOverPlayAgainLabel.fontColor = SKColor.whiteColor()
        gameOverPlayAgainLabel.fontSize = 16
        gameOverPlayAgainLabel.position = CGPoint(x: gameOverPlayAgainButton.position.x, y: gameOverPlayAgainButton.position.y * 0.99)
        gameOverPlayAgainLabel.zPosition = 5
        gameOverPlayAgainLabel.text = "Play Again"
        gameOverPlayAgainLabel.name = "PlayAgainLabel"
        self.addChild(gameOverPlayAgainLabel)
        
        let gameOverGameCenterLabel = SKLabelNode(fontNamed: "Futura")
        gameOverGameCenterLabel.fontColor = SKColor.whiteColor()
        gameOverGameCenterLabel.fontSize = 16
        gameOverGameCenterLabel.position = CGPoint(x: gameOverGameCenterButton.position.x, y: gameOverGameCenterButton.position.y * 0.99)
        gameOverGameCenterLabel.zPosition = 5
        gameOverGameCenterLabel.text = "Game Center"
        gameOverGameCenterLabel.name = "GameCenterLabel"
        self.addChild(gameOverGameCenterLabel)
        
        title.zPosition = 3
        highScoreLabel.zPosition = 3
        var highScore = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
        pauseButton.removeFromParent()
    }
    
    func pauseGame() {
        
        isGamePaused = true
        self.paused = true
        backgroundMusicPlayer.pause()
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
        pauseMenuQuitButton.zPosition = 3
        pauseMenuQuitText.zPosition = 3
        pauseMenuRestartButton.zPosition = 3
        pauseMenuRestartText.zPosition = 3
        self.addChild(pauseMenuQuitButton)
        self.addChild(pauseMenuQuitText)
        self.addChild(pauseMenuRestartButton)
        self.addChild(pauseMenuRestartText)
        //Added Pause Menu
    }
    
    func resumeGame() {
        
        isGamePaused = false
        self.paused = false
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
        //Remove pause menu etc.
        childNodeWithName("tintScreen")?.removeFromParent()
        title.zPosition = 2
        highScoreLabel.zPosition = 2
        var highScore = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
        highScoreLabel.text = "BEST: \(highScore)"
        pauseButton.texture = SKTexture(imageNamed: "pauseButton")
        pauseMenuQuitButton.zPosition = 1
        pauseMenuQuitText.zPosition = 1
        pauseMenuRestartButton.zPosition = 1
        pauseMenuRestartText.zPosition = 1
        pauseMenuQuitButton.removeFromParent()
        pauseMenuQuitText.removeFromParent()
        pauseMenuRestartButton.removeFromParent()
        pauseMenuRestartText.removeFromParent()
        //Removed Pause Menu
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            var node = self.nodeAtPoint(location)
            if self.nodeAtPoint(location).name == "bubble" && isAntiGravity == false {

                if NSUserDefaults.standardUserDefaults().boolForKey("SFX") == true {
                    playSound(bubbleSFX)
                }
                self.nodeAtPoint(location).physicsBody?.applyImpulse(CGVectorMake(randRange(-50, upper: 50), randRange(500, upper: 650)))
                println("TOUCHED")
                score++
                
            } else {
            
                println("MISSED")
            
            }
            if CGRectContainsPoint(pauseButton.frame, location) && isGamePaused == true {
                println("PIHUEOFDJOE: RESUME")
            }
            
            if self.nodeAtPoint(location).name == "MainMenuButton" || self.nodeAtPoint(location).name == "MainMenuLabel" && isGameOver == true {
                var theGame = GameScene(size: self.view!.bounds.size)
                let skView = self.view as SKView!
                skView.ignoresSiblingOrder = true
                theGame.scaleMode = .AspectFill
                theGame.size = skView.bounds.size
                self.removeAllChildren()
                self.removeAllActions()
                adBannerView.removeFromSuperview()
                if backgroundMusicPlayer.playing == true {
                    backgroundMusicPlayer.pause()
                }
                skView.presentScene(theGame, transition: SKTransition.crossFadeWithDuration(0.25))
            }
            
            if self.nodeAtPoint(location).name == "PlayAgainButton" || self.nodeAtPoint(location).name == "PlayAgainLabel" && isGameOver == true {
                var theGamePlay = GamePlayScene(size: self.view!.bounds.size)
                let skView = self.view as SKView!
                skView.ignoresSiblingOrder = true
                theGamePlay.scaleMode = .AspectFill
                theGamePlay.size = skView.bounds.size
                self.removeAllChildren()
                self.removeAllActions()
                adBannerView.removeFromSuperview()
                if backgroundMusicPlayer.playing == true {
                    backgroundMusicPlayer.pause()
                }
                skView.presentScene(theGamePlay, transition: SKTransition.crossFadeWithDuration(0.25))
            }
            
            if self.nodeAtPoint(location).name == "GameCenterButton" || self.nodeAtPoint(location).name == "GameCenterLabel" && isGameOver == true {
                func showLeader() {
                    var vc = self.view?.window?.rootViewController
                    var gc = GKGameCenterViewController()
                    vc?.presentViewController(gc, animated: true, completion: nil)
                    //gc.delegate = self.view?.window?.rootViewController?.navigationController?.delegate
                    gc.delegate = self
                    //gc.delegate = self
                }
                func saveHighscoreToLeaderboard(score:Int) {
                    
                    //check if user is signed in
                    if GKLocalPlayer.localPlayer().authenticated {
                        
                        var scoreReporter = GKScore(leaderboardIdentifier: "bubblesgameleaderboard2015") //leaderboard id here
                        
                        scoreReporter.value = Int64(score) //score variable here (same as above)
                        
                        var scoreArray: [GKScore] = [scoreReporter]
                        GKScore.reportScores(scoreArray, withCompletionHandler: {(error : NSError!) -> Void in
                            if error != nil {
                                println("error")
                            }
                        })
                        
                    }
                    
                }
                println(NSUserDefaults.standardUserDefaults().integerForKey("highscore"))
                saveHighscoreToLeaderboard(NSUserDefaults.standardUserDefaults().integerForKey("highscore"))
                showLeader()
            }
            
            println(isAntiGravity)
            
            if self.nodeAtPoint(location).name == "bubble" && isAntiGravity == true {
                
                if NSUserDefaults.standardUserDefaults().boolForKey("SFX") == true {
                    playSound(bubbleSFX)
                }
                self.nodeAtPoint(location).physicsBody?.applyImpulse(CGVectorMake(randRange(-50, upper: 50), randRange(-650, upper: -500)))
                println("GERILUGUIRIUERFGIRUE")
                score++
                
            }
            
//            if self.nodeAtPoint(location).name == "continueText" && isGameOver == true {
//                println("Ïˆ´¨Óıˆ∑º™•™ª£†¶•ÓÏ˚ÔÆÒÎ∏Ô Ø´ÔÏˆ¨ÓÎ´ıÔŒÓˆ´Ó¨´‰")
//            }

            if CGRectContainsPoint(pauseButton.frame, location) && (!isGamePaused) {
                
                pauseGame()
                
            }
            
            if self.nodeAtPoint(location) == pauseMenuQuitButton || self.nodeAtPoint(location) == pauseMenuQuitText && isGamePaused == true {
                var theGame = GameScene(size: self.view!.bounds.size)
                let skView = self.view as SKView!
                skView.ignoresSiblingOrder = true
                theGame.scaleMode = .AspectFill
                theGame.size = skView.bounds.size
                self.removeAllChildren()
                self.removeAllActions()
                if backgroundMusicPlayer.playing == true {
                    backgroundMusicPlayer.pause()
                }
                skView.presentScene(theGame, transition: SKTransition.crossFadeWithDuration(0.25))
            }
            
            if self.nodeAtPoint(location) == pauseMenuRestartButton || self.nodeAtPoint(location) == pauseMenuRestartText && isGamePaused == true {
                var theGamePlay = GamePlayScene(size: self.view!.bounds.size)
                let skView = self.view as SKView!
                skView.ignoresSiblingOrder = true
                theGamePlay.scaleMode = .AspectFill
                theGamePlay.size = skView.bounds.size
                self.removeAllChildren()
                self.removeAllActions()
                if backgroundMusicPlayer.playing == true {
                    backgroundMusicPlayer.pause()
                }
                skView.presentScene(theGamePlay, transition: SKTransition.crossFadeWithDuration(0.25))
            }
            
//            if CGRectContainsPoint(pauseMenuQuitButton.frame, location) == true || CGRectContainsPoint(pauseMenuQuitText.frame, location) == true && isGamePaused == true {
//            var theGame = GameScene(size: self.view!.bounds.size)
//            let skView = self.view as SKView!
//            skView.ignoresSiblingOrder = true
//            theGame.scaleMode = .AspectFill
//            theGame.size = skView.bounds.size
//            self.removeAllChildren()
//            self.removeAllActions()
//            skView.presentScene(theGame, transition: SKTransition.crossFadeWithDuration(0.25))
//            }
            
//            if CGRectContainsPoint(pauseMenuRestartButton.frame, location) == true || CGRectContainsPoint(pauseMenuRestartText.frame, location) == true && isGamePaused == true {
//            var theGamePlay = GamePlayScene(size: self.view!.bounds.size)
//            let skView = self.view as SKView!
//            skView.ignoresSiblingOrder = true
//            theGamePlay.scaleMode = .AspectFill
//            theGamePlay.size = skView.bounds.size
//            self.removeAllChildren()
//            self.removeAllActions()
//            skView.presentScene(theGamePlay, transition: SKTransition.crossFadeWithDuration(0.25))
//            }
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
        bubble.physicsBody?.friction = 1.0
        bubble.physicsBody?.restitution = 1.0
        bubble.physicsBody?.linearDamping = 0.0
        bubble.physicsBody?.affectedByGravity = true
        bubble.xScale = 1
        bubble.yScale = 1
        bubble.position = CGPoint(x: self.randRange(self.frame.width * 0.35, upper: self.frame.width * 0.65), y: self.frame.height/2)
        bubble.name = "bubble"
        bubble.physicsBody?.usesPreciseCollisionDetection = true
        let bubbleRotationAction = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        bubble.runAction(SKAction.repeatActionForever(bubbleRotationAction))
        bubble.physicsBody?.categoryBitMask = self.bubbleCategory
        bubble.physicsBody?.contactTestBitMask = self.bottomCategory | self.topCategory
        
        if firstBody.categoryBitMask == bubbleCategory && secondBody.categoryBitMask == bottomCategory && isAntiGravity == false {
            if NSUserDefaults.standardUserDefaults().boolForKey("SFX") == true {
            playSound(bubblePop)
            }
            firstBody.node?.removeFromParent()
            --lives
            justFailed = true
            if lives < 3 {
                
                life1.removeFromParent()

            }
            
            if lives < 1 {
                
                life2.removeFromParent()
                
            }
            
            if lives < -1 {
                
                life3.removeFromParent()
                isGameOver = true
                gameOver()
                loadAds()
                //game is over at this point
                
            }
            //self.addChild(bubble)
            //bubble.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 0))
        }
        
        if firstBody.categoryBitMask == bubbleCategory && secondBody.categoryBitMask == topCategory && isAntiGravity == true {
            println("SUCSESS: ƒ©´ø´ƒ©¥ø¨´∑¥ƒ∫˙∆¬¨¬¨∑∂ˆ©ˆ†¥√∑∂§∑¨ç¥®")
            if NSUserDefaults.standardUserDefaults().boolForKey("SFX") == true {
                playSound(bubblePop)
            }
            firstBody.node?.removeFromParent()
            --lives
            justFailed = true
            if lives < 3 {
                
                life1.removeFromParent()
                
            }
            
            if lives < 1 {
                
                life2.removeFromParent()
                
            }
            
            if lives < -1 {
                
                life3.removeFromParent()
                isGameOver = true
                gameOver()
                //game is over at this point
                
            }
            //self.addChild(bubble)
            //bubble.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 0))
        }
    }

    func didEndContact(contact: SKPhysicsContact) {
        
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
        if self.physicsWorld.gravity.dy > 0 {
            isAntiGravity = true
        } else if physicsWorld.gravity.dy < 0 {
            isAntiGravity = false
        }
        
        func saveHighscoreToLeaderboard(score_:Int) {
            
            //check if user is signed in
            if GKLocalPlayer.localPlayer().authenticated {
                
                var scoreReporter = GKScore(leaderboardIdentifier: "bubblesgameleaderbooard2015") //leaderboard id here
                
                scoreReporter.value = Int64(score_) //score variable here (same as above)
                
                var scoreArray: [GKScore] = [scoreReporter]
                
                GKScore.reportScores(scoreArray, withCompletionHandler: {(error : NSError!) -> Void in
                    if error != nil {
                        println("error")
                    }
                })
                
            }
            
        }
        saveHighscoreToLeaderboard(NSUserDefaults.standardUserDefaults().integerForKey("highscore"))
        if self.isGamePaused == false && self.isGameOver == false {
        timePassed++
        }
        
        if isAntiGravity == true && timePassed % 3 == 0 {
            self.topVacuum.texture = SKTexture(imageNamed: "topAnim0")
        } else if isAntiGravity == true && timePassed % 3 != 0 {
            self.topVacuum.texture = SKTexture(imageNamed: "topAnim1")
        } else {
            self.topVacuum.texture = SKTexture(imageNamed: "topVacuumIdle")
        }
        
        if isAntiGravity == false && timePassed % 3 == 0 {
            self.bottomVacuum.texture = SKTexture(imageNamed: "bottomAnim0")
        } else if isAntiGravity == false && timePassed % 3 != 0 {
            self.bottomVacuum.texture = SKTexture(imageNamed: "bottomAnim1")
        } else {
            self.bottomVacuum.texture = SKTexture(imageNamed: "bottomVacuumIdle")
        }
        
        if isGameOver == true {
            self.topVacuum.texture = SKTexture(imageNamed: "topVacuumIdle")
            self.bottomVacuum.texture = SKTexture(imageNamed: "bottomVacuumIdle")
        }
        
        println(timePassed)
        println("ISANTIGRAVITY: \(isAntiGravity)")
        println("LIVES!!! \(lives)")
        println("HIGH SCORE LABEL: \(highScoreLabel.text)")
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
        
        if timePassed != 0 && timePassed % 450 == 0 {
            self.physicsWorld.gravity.dy *= -1
        }
        
        if self.isGameOver == true {
            
            var highScore = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
            if score >= highScore {
                title.text = "NICE"
            } else {
                title.text = "FAIL"
            }
            highScoreLabel.text = "SCORE: \(score)   BEST: \(highScore)"
            
        }
        
        let spawnABubble = SKAction.runBlock({let bubble:SKSpriteNode = SKSpriteNode(imageNamed: "bubble")
            bubble.physicsBody = SKPhysicsBody(circleOfRadius: bubble.frame.size.width/2)
            bubble.physicsBody?.mass = 1.0
            bubble.physicsBody?.friction = 1.0
            bubble.physicsBody?.restitution = 1.0
            bubble.physicsBody?.linearDamping = 0.0
            bubble.physicsBody?.affectedByGravity = true
            bubble.xScale = 1
            bubble.yScale = 1
            bubble.position = CGPoint(x: self.randRange(self.frame.width * 0.35, upper: self.frame.width * 0.65), y: self.frame.height/2)
            bubble.name = "bubble"
            bubble.physicsBody?.usesPreciseCollisionDetection = true
            let bubbleRotationAction = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            bubble.runAction(SKAction.repeatActionForever(bubbleRotationAction))
            bubble.physicsBody?.categoryBitMask = self.bubbleCategory
            bubble.physicsBody?.contactTestBitMask = self.bottomCategory | self.topCategory
            if self.timePassed % 500 == 0 || self.timePassed == 30 || self.justFailed == true {
                self.addChild(bubble)
                bubble.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 0))
                self.justFailed = false
            }
        })
        let handleBubbles = SKAction.sequence([spawnABubble])
        self.runAction(handleBubbles)
    }

    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        println("Leaving app to the Ad")
        
        return true
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        
        adBannerView.center = CGPoint(x: adBannerView.center.x, y: self.view!.bounds.size.height - GamePlayScene().bottomVacuum.frame.height / 0.78)
        adBannerView.frame = CGRectOffset(adBannerView.frame,0.0,0.0)
        println(GamePlayScene().bottomVacuum.frame.height)
        adBannerView.hidden = false
        println("Displaying the Ad")
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        //adBannerView.center = CGPoint(x: adBannerView.center.x, y: self.view!.bounds.size.height + self.view!.bounds.size.height)
        println("Ad is not available")
    }
    
    func loadAds() {
        adBannerView = ADBannerView(frame: CGRect.zeroRect)
        adBannerView.frame = CGRectOffset(adBannerView.frame,0,0.0)
        adBannerView.delegate = self
        adBannerView.hidden = true
        self.view!.addSubview(adBannerView)
    }
    
}