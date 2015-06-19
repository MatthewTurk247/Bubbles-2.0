//
//  Emoji.swift
//  SecondMojimania
//
//  Created by Matthew Turk on 6/5/15.
//  Copyright (c) 2015 Turk Enterprises. All rights reserved.
//

import Foundation
import SpriteKit

class Emoji {
    var enemyMoveAndRemove: SKAction!
    var isDead = false
    var isSpawning = false
    var emoji:SKSpriteNode = SKSpriteNode(imageNamed: "emojiIdle")
    
    func createEmoji() -> SKSpriteNode {

        //Random stats
        var speed = CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * 0.01
        var size = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        
        emoji.position = CGPoint(x: GameScene().frame.width * 0.5, y: GameScene().frame.height * 0.5)
        emoji.physicsBody?.dynamic = true
        emoji.setScale(1.0)
        emoji.physicsBody?.restitution = 0.0
        emoji.physicsBody?.mass = 0
        emoji.zPosition = 10
        emoji.physicsBody?.allowsRotation = true
        //let delaytime = NSTimeInterval(arc4random_uniform(4))
        //emoji.physicsBody?.applyImpulse(CGVectorMake(0, 15))
        //emoji.physicsBody?.contactTestBitMask = ninjaCategory | groundCategory
        //emoji.physicsBody?.collisionBitMask = groundCategory
        
        playEmojiAnimation()
        
        return emoji
    }
    
    func playEmojiAnimation() {
        //Later this will be a switch depending on which random emoji comes out of the datamixer
        let moji1 = SKTexture(imageNamed: "emojiAnim1")
        let moji2 = SKTexture(imageNamed: "emojiAnim2")
        let moji3 = SKTexture(imageNamed: "emojiAnim3")
        let moji4 = SKTexture(imageNamed: "emojiAnim4")
        
        let textureAnim = SKAction.animateWithTextures([moji1, moji2, moji3, moji4], timePerFrame: 0.1)
        let mojiAnim = SKAction.repeatActionForever(textureAnim)
        emoji.runAction(mojiAnim)
    }
}
