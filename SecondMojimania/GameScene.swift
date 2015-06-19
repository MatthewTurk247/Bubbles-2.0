//
//  GameScene.swift
//  SecondMojimania
//
//  Created by Matthew Turk on 6/4/15.
//  Copyright (c) 2015 Turk Enterprises. All rights reserved.
//

import AVFoundation
import Foundation
import SpriteKit

class GameScene: SKScene {
    
    func randRange (lower: CGFloat , upper: CGFloat) -> CGFloat {
        return lower + CGFloat(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    var ball:SKSpriteNode = SKSpriteNode(imageNamed: "emojiIdle")
    var buttonSoundPlayer:AVAudioPlayer = AVAudioPlayer()
    var coins = NSUserDefaults.standardUserDefaults().integerForKey("coins")
    var lives:Int = 0
    let startButton = SKSpriteNode(imageNamed: "startButton")
    let shopButton = SKSpriteNode(imageNamed: "startButton")
    let moreButton = SKSpriteNode(imageNamed: "startButton")
    let greenInfo = SKSpriteNode(imageNamed: "startGreen")
    let title = SKSpriteNode(imageNamed: "title")
    var moving: SKNode!
    var isGameOver = false
    let heartTexture = SKTexture(imageNamed: "heart")
    let lives1 = SKSpriteNode(imageNamed: "heart")
    let lives2 = SKSpriteNode(imageNamed: "heart")
    let lives3 = SKSpriteNode(imageNamed: "heart")
    let gamePlayIntHUD:SKSpriteNode = SKSpriteNode(imageNamed: "gamePlayIntHUD")
    var highScoreText = SKLabelNode(fontNamed: "Helvetica Neue Bold")
    let startText = SKLabelNode(fontNamed: "Helvetica Neue Bold")
    let shopText = SKLabelNode(fontNamed: "Helvetica Neue Bold")
    let moreText = SKLabelNode(fontNamed: "Helvetica Neue Bold")
    var coinText = SKLabelNode(fontNamed: "Helvetica Neue Bold")
    var dollarTexture = SKTexture(imageNamed: "dollar")
    var dollarMoveAndRemove = SKAction()
    let theTextColor = SKColor(red: 216.0/255, green: 216.0/255, blue: 216.0/255, alpha: 1.0)
    let thatGorgeousYellow = SKColor(red: 255.0/255, green: 206.0/255, blue: 100.0/255, alpha: 1.0)
    let thatWeirdPurple = SKColor(red: 155.0/255, green: 89.0/255, blue: 182.0/255, alpha: 1.0)
    let backgroundImage = SKSpriteNode(imageNamed: "bg")
    let pauseButton = SKSpriteNode(imageNamed: "pauseButton")
    
    override func didMoveToView(view: SKView) {
        
        ball.position = CGPoint(x: self.frame.width * 0.5, y: self.frame.height)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.size.width/2)
        ball.physicsBody?.affectedByGravity = true
        ball.physicsBody?.mass = 0.5
        ball.physicsBody?.friction = 0.2
        ball.physicsBody?.restitution = 0.6
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.allowsRotation = false
        
        lives = 3
        func createLivesBoard() {
            
            self.lives1.position = CGPoint(x: self.frame.width/1.07, y: self.frame.height/1.04)
            self.lives1.texture = heartTexture
            self.lives1.zPosition = 5
            self.lives1.setScale(1.0)
            self.lives2.position = CGPoint(x: lives1.position.x - 35, y: self.frame.height/1.04)
            self.lives2.texture = heartTexture
            self.lives2.zPosition = 5
            self.lives2.setScale(1.0)
            self.lives3.position = CGPoint(x: lives2.position.x - 35, y: self.frame.height/1.04)
            self.lives3.texture = heartTexture
            self.lives3.zPosition = 5
            self.lives3.setScale(1.0)
            if lives > 0 {
                
                self.addChild(lives1)
                
            }
            
            if lives > 1 {
                
                self.addChild(lives2)
                
            }
            
            if lives > 2 {
                
                self.addChild(lives3)
                
            }
            
        }
        createLivesBoard()
        backgroundImage.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        backgroundImage.size.height = self.frame.height
        backgroundImage.size.width = backgroundImage.size.height
        self.addChild(backgroundImage)
        func createAndMovedollars() {
            //dollar spawning
                let spawnAdollar = SKAction.runBlock({let dollar = SKSpriteNode(imageNamed: "dollar")
                let y = arc4random() % UInt32(self.frame.size.height)
                var randomSize = CGFloat(self.randRange(0.5, upper: 1.1))
                if randomSize < 0.0 {
                    randomSize = 0.2
                }
                dollar.zPosition = self.backgroundImage.zPosition + 2
                var randomHeight = UInt32(self.frame.size.height / 1.5) + (arc4random() % UInt32(self.frame.size.height / 2))
                dollar.setScale(randomSize)
                dollar.position = CGPointMake(self.frame.size.width + dollar.size.width, CGFloat(randomHeight))
                
                dollar.runAction(self.dollarMoveAndRemove)
                self.addChild(dollar)})
            let spawnThenDelaydollar = SKAction.sequence([spawnAdollar, SKAction.waitForDuration(6.0)])
            let spawnThenDelaydollarForever = SKAction.repeatActionForever(spawnThenDelaydollar)
            self.runAction(spawnThenDelaydollarForever)
            let dollardistanceToMove = CGFloat(self.frame.width + 4.0 * dollarTexture.size().width)
            let dollarmovement = SKAction.moveByX(-dollardistanceToMove, y: 0.0, duration: NSTimeInterval(0.025 * dollardistanceToMove))
            let removedollar = SKAction.removeFromParent()
            dollarMoveAndRemove = SKAction.sequence([dollarmovement, removedollar])
        }
        
        createAndMovedollars()
        
        moving = SKNode()
        self.addChild(moving)
        moving.speed = 0.09
        
        self.greenInfo.setScale(0.56666667)
        self.greenInfo.position = CGPoint(x: self.frame.width/2, y: self.frame.height/10)
        self.greenInfo.zPosition = moving.zPosition + 2
        self.addChild(greenInfo)
        
        //Buttons
        self.startButton.setScale(0.56666667)
        self.startButton.position = CGPointMake(frame.width/2, self.frame.height/1.62)
        self.shopButton.setScale(0.566666667)
        self.shopButton.zPosition = moving.zPosition + 1
        self.shopButton.position = CGPointMake(self.frame.width/2, self.startButton.position.y - 90)
        self.moreButton.position = CGPointMake(self.startButton.position.x, shopButton.position.y - 90)
        self.moreButton.setScale(0.566666667)
        self.moreButton.zPosition = moving.zPosition + 1
        self.addChild(self.shopButton)
        self.addChild(self.startButton)
        self.addChild(self.moreButton)
        startText.text = ("Play")
        startText.fontColor = SKColor.whiteColor()
        startText.fontSize = 48
        shopText.text = ("Devices")
        shopText.fontColor = SKColor.whiteColor()
        shopText.fontSize = 48
        moreText.text = ("Settings/Extras")
        moreText.fontColor = SKColor.whiteColor()
        moreText.fontSize = 48
        startText.position = CGPointMake(0, -self.startButton.size.height / 8)
        shopText.position = CGPointMake(0, -self.shopButton.size.height / 8)
        moreText.position = CGPointMake(0, -self.moreButton.size.height / 8)
        self.startButton.addChild(startText)
        self.shopButton.addChild(shopText)
        self.moreButton.addChild(moreText)
        //Coin Display
        coinText.fontSize = 18
        coinText.fontColor = SKColor.whiteColor()
        coinText.text = "Balance: \(coins)"
        coinText.zPosition = greenInfo.zPosition + 2
        coinText.position = CGPoint(x: frame.width/2, y: self.greenInfo.position.y/1.4)
        self.addChild(coinText)
        
        //Text
        title.setScale(0.6)
        title.position = CGPoint(x: frame.width/2, y: frame.height/1.2)
        self.addChild(title)
        let theRect = CGRect(x: frame.width/3.2, y: frame.height/1.4, width: self.frame.width/2.666667, height: 10)
        let underlineRect:SKShapeNode = SKShapeNode(rect: theRect)
        underlineRect.fillColor = thatWeirdPurple
        underlineRect.strokeColor = thatWeirdPurple
        self.addChild(underlineRect)
        
        let mojiDataMixerTexture = SKTexture(imageNamed: "mojiDataMixer")
        mojiDataMixerTexture.filteringMode = .Nearest
        
        let movemojiDataMixerSprite = SKAction.moveByX(-mojiDataMixerTexture.size().width * 2.0, y: 0, duration: NSTimeInterval(0.006 * mojiDataMixerTexture.size().width * 2.0))
        let resetmojiDataMixerSprite = SKAction.moveByX(mojiDataMixerTexture.size().width * 2.0, y: 0, duration: 0.0)
        let movemojiDataMixerSpritesForever = SKAction.repeatActionForever(SKAction.sequence([movemojiDataMixerSprite,resetmojiDataMixerSprite]))
        
        //Move mojiDataMixer
        for var i:CGFloat = 0; i < 2.0 + self.frame.size.width / ( mojiDataMixerTexture.size().width * 0.5 ); ++i {
            let sprite = SKSpriteNode(texture: mojiDataMixerTexture)
            sprite.setScale(0.6)
            sprite.position = CGPointMake(self.frame.width/2, sprite.size.height / 2)
            //sprite.runAction(movemojiDataMixerSpritesForever, withKey: "movemojiDataMixerSprite")
            sprite.physicsBody?.dynamic = false
            sprite.size.width = self.frame.width
            moving.addChild(sprite)
        }
        
        //Set initial inventory value
        NSUserDefaults.standardUserDefaults().integerForKey("inventory")
        if (NSUserDefaults.standardUserDefaults().integerForKey("inventory") == 0) {
            NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "inventory")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        NSUserDefaults.standardUserDefaults().integerForKey("inventory")
        
        //Set initial throwing star recharge speed
        NSUserDefaults.standardUserDefaults().floatForKey("rechargeSpeed")
        if (NSUserDefaults.standardUserDefaults().floatForKey("rechargeSpeed") == 0) {
            NSUserDefaults.standardUserDefaults().setFloat(2.5, forKey: "rechargeSpeed")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        NSUserDefaults.standardUserDefaults().floatForKey("rechargeSpeed")
        
        //Display highscore
        //if (SaveData().highScore != 0) {
            //highScoreText.text = ("HIGH SCORE: " + String(SaveData().highScore))
        highScoreText.text = "High Score:"
            highScoreText.fontColor = SKColor.whiteColor()
            highScoreText.fontSize = 18
        highScoreText.zPosition = greenInfo.zPosition + 1
            highScoreText.position = CGPoint(x: frame.width/2, y: self.greenInfo.position.y)
            
            self.addChild(highScoreText)
        //}
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            /*  if (self.nodeAtPoint(location) == self.startButton) || (self.nodeAtPoint(location) == self.startText) {
            var scene = PlayScene(size: self.size)
            let skView = self.view as SKView!
            skView.ignoresSiblingOrder = true
            scene.scaleMode = .ResizeFill
            scene.size = skView.bounds.size
            self.removeAllChildren()
            skView.presentScene(scene)
            
            } */
            
            /*if CGRectContainsPoint(settingsButton.frame, location) || CGRectContainsPoint(settingsText.frame, location) {
                println("INDEED")
                var buttonSoundURL:NSURL = NSBundle.mainBundle().URLForResource("button", withExtension: "mp3")!
                buttonSoundPlayer = AVAudioPlayer(contentsOfURL: buttonSoundURL, error: nil)
                buttonSoundPlayer.numberOfLoops = 1
                buttonSoundPlayer.prepareToPlay()
                buttonSoundPlayer.play()
                var theSettings = SettingsScene(size: self.size)
                let skView = self.view as SKView!
                skView.ignoresSiblingOrder = true
                theSettings.scaleMode = .AspectFill
                theSettings.size = skView.bounds.size
                self.removeAllChildren()
                skView.presentScene(theSettings)
            }*/
            
            if CGRectContainsPoint(startButton.frame, location) || CGRectContainsPoint(startText.frame, location) {
                println("INDEED")
                //var buttonSoundURL:NSURL = NSBundle.mainBundle().URLForResource("button", withExtension: "mp3")!
                //buttonSoundPlayer = AVAudioPlayer(contentsOfURL: buttonSoundURL, error: nil)
                //buttonSoundPlayer.numberOfLoops = 1
                //buttonSoundPlayer.prepareToPlay()
                //buttonSoundPlayer.play()
                func commenseGame() {
                startButton.runAction(SKAction.fadeOutWithDuration(0.75))
                shopButton.runAction(SKAction.fadeOutWithDuration(0.75))
                moreButton.runAction(SKAction.fadeOutWithDuration(0.75))
                title.runAction(SKAction.fadeOutWithDuration(0.75))
                greenInfo.runAction(SKAction.fadeOutWithDuration(0.75))
                highScoreText.runAction(SKAction.fadeOutWithDuration(0.75))
                coinText.runAction(SKAction.fadeOutWithDuration(0.75))
                    
                    func playEmojiAnimation() {
                        //Later this will be a switch depending on which random emoji comes out of the datamixer
                        let moji0 = SKTexture(imageNamed: "emojiIdle")
                        let moji1 = SKTexture(imageNamed: "emojiAnim1")
                        let moji2 = SKTexture(imageNamed: "emojiAnim2")
                        let moji3 = SKTexture(imageNamed: "emojiAnim3")
                        let moji4 = SKTexture(imageNamed: "emojiAnim4")
                        let moji5 = SKTexture(imageNamed: "emojiAnim5")
                        let moji6 = SKTexture(imageNamed: "emojiAnim6")
                        let moji7 = SKTexture(imageNamed: "emojiAnim7")
                        
                        let textureAnim = SKAction.animateWithTextures([moji0, moji1, moji2, moji3, moji4, moji5, moji6, moji7], timePerFrame: 0.125)
                        let mojiAnim = SKAction.repeatActionForever(textureAnim)
                        ball.runAction(mojiAnim)
                    }
                    playEmojiAnimation()
                    self.addChild(ball)
                    ball.physicsBody?.applyImpulse(CGVectorMake(self.randRange(-50, upper: 50), 333))
                    //Pause Button
                    pauseButton.setScale(0.7)
                    pauseButton.position = CGPoint(x: self.frame.width * 0.32, y: self.frame.height * 0.96)
                    pauseButton.zPosition = 5
                    self.addChild(pauseButton)
                    gamePlayIntHUD.setScale(0.55)
                    gamePlayIntHUD.position = CGPoint(x: self.frame.size.width * 0.433, y: self.pauseButton.position.y)
                    gamePlayIntHUD.zPosition = 5
                    self.addChild(gamePlayIntHUD)
                
             }
                commenseGame()
            }
        
            /*if (self.nodeAtPoint(location) == self.settingsButton) {
            println("yup")
            var theSettings = SettingsScene(size: self.size)
            let theSettingsView = self.view as SKView!
            theSettingsView.ignoresSiblingOrder = true
            theSettings.scaleMode = .ResizeFill
            theSettings.size = theSettingsView.bounds.size
            self.removeAllChildren()
            theSettingsView.presentScene(theSettings)
            
            }*/
            
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if lives < 3 {
            
            lives3.removeFromParent()
            
        }
        
        if lives < 2 {
            
            lives2.removeFromParent()
            
        }
        
        if lives < 1 {
            
            lives1.removeFromParent()
            isGameOver = true
            
        }
        
    }
    
}

