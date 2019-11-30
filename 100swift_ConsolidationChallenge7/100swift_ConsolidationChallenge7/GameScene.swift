//
//  GameScene.swift
//  100swift_ConsolidationChallenge7
//
//  Created by MAC on 29/11/2019.
//  Copyright © 2019 Gera Volobuev. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var gameOver: SKSpriteNode!
    var timerLabel: SKLabelNode!
    var gameScore: SKLabelNode!
    var shots: SKSpriteNode?
    var gameTime: Timer?
    var counter: Int = 60
    var rounds = 3 {
        didSet {
            shots?.texture = SKTexture(imageNamed: "shots\(rounds)")
        }
    }
    var numOfTries = 4
    var score: Int = 0 {
        didSet {
            gameScore.text = "Your score is \(score)"
        }
    }
    override func didMove(to view: SKView) {
        
        gameTime = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        let background = SKSpriteNode(imageNamed: "wood-background")
        background.position = CGPoint(x: 512, y: 384)
        background.size = self.size
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        let grass = SKSpriteNode(imageNamed: "grass-trees")
        grass.position = CGPoint(x: 512, y: 256)
        grass.size.width = self.size.width
        grass.zPosition = 1 //
        addChild(grass)
        
        let waterBg = SKSpriteNode(imageNamed: "water-bg")
        waterBg.position = CGPoint(x: 512, y: 12)
        waterBg.size.width = self.size.width
        waterBg.zPosition = 3 //
        addChild(waterBg)
        
        let waterFg = SKSpriteNode(imageNamed: "water-fg")
        waterFg.position = CGPoint(x: 512, y: 0)
        waterFg.size.width = self.size.width + 128
        waterFg.zPosition = 4 //
        addChild(waterFg)
        
        let moveRight = SKAction.moveBy(x: 128, y:0, duration:1.5)
        let moveLeft = moveRight.reversed()
        let sequence = SKAction.sequence([moveRight, moveLeft])
        let waterRun = SKAction.repeatForever(sequence)
        waterFg.run(waterRun)
        
        
        shots = SKSpriteNode(imageNamed: "shots\(rounds)")
        shots!.position = CGPoint(x: 960, y: 32)
        shots!.zPosition = 999 //
        addChild(shots!)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        gameScore.zPosition = 999
        addChild(gameScore)
        
        timerLabel = SKLabelNode(fontNamed: "Chalkduster")
        timerLabel.text = "\(counter)"
        timerLabel.position = CGPoint(x: 52, y: 700)
        timerLabel.fontSize = 48
        timerLabel.zPosition = 999
        addChild(timerLabel)
        
        gameOver = SKSpriteNode(imageNamed: "game-over")
        gameOver.position = CGPoint(x: 512, y: 384)
        gameOver.zPosition = 999
        gameOver.isHidden = true
        addChild(gameOver)
        

        
        for i in [50,250,450] {
            let duck = SKSpriteNode(imageNamed: "target1")
            duck.position = CGPoint(x: 50+i, y: 525)
            duck.zPosition = 98
            duck.name = "DuckTop"
            addChild(duck)
            
            let moveRight = SKAction.moveBy(x: 500, y:0, duration:0.5)
            let moveLeft = moveRight.reversed()
            let sequence = SKAction.sequence([moveRight, moveLeft])
            let endlessAction = SKAction.repeatForever(sequence)
            duck.run(endlessAction)
        }
        
        for i in [50,200,350] {
            let duck = SKSpriteNode(imageNamed: "target2")
            duck.position = CGPoint(x: 50+i, y: 300)
            duck.zPosition = 98
            duck.name = "DuckMiddle"
            addChild(duck)
            
            let moveRight = SKAction.moveBy(x: 500, y:0, duration:2.0)
            let moveLeft = moveRight.reversed()
            let sequence = SKAction.sequence([moveRight, moveLeft])
            let endlessAction = SKAction.repeatForever(sequence)
            duck.run(endlessAction)
        }
        
        for i in [250,550,850] {
            let duck = SKSpriteNode(imageNamed: "target3")
            duck.position = CGPoint(x: 50+i, y: 82)
            duck.zPosition = 100
            duck.name = "DuckBottom"
            addChild(duck)
            
            let moveRight = SKAction.moveBy(x: 200, y:0, duration:1.5)
            let moveLeft = moveRight.reversed()
            let sequence = SKAction.sequence([moveLeft,moveRight])
            let endlessAction = SKAction.repeatForever(sequence)
            duck.run(endlessAction)
        }
        
        
    }
    
    @objc func updateCounter() {
        //example functionality
        if counter > 0 {
            timerLabel.text = "\(counter)"
            counter -= 1
        }
        if counter == 0 {
            gameOver.isHidden = false
            rounds = 0
            numOfTries = 0

        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.atPoint(location)
            
            if rounds != 0 && numOfTries != 0 {
                run(SKAction.playSoundFileNamed("shot.wav", waitForCompletion: false))
                if touchedNode.name == "DuckBottom" {
                    score+=1
                    rounds -= 1
                    run(SKAction.playSoundFileNamed("hit.aiff", waitForCompletion: false))
                    touchedNode.removeFromParent()
                } else if touchedNode.name == "DuckMiddle" {
                    score+=5
                    rounds -= 1
                    run(SKAction.playSoundFileNamed("hit.aiff", waitForCompletion: false))
                    touchedNode.removeFromParent()
                    
                } else if touchedNode.name == "DuckTop" {
                    score+=10
                    run(SKAction.playSoundFileNamed("hit.aiff", waitForCompletion: false))
                    touchedNode.removeFromParent()
                    
                } else {
                    rounds -= 1
                }
            } else if rounds == 0 && numOfTries > 1 {
                run(SKAction.playSoundFileNamed("reload.wav", waitForCompletion: false))
                rounds += 3
                numOfTries -= 1
            } else {
                run(SKAction.playSoundFileNamed("empty.wav", waitForCompletion: false))
                gameOver.isHidden = false
            }
        }
    }
    
}
