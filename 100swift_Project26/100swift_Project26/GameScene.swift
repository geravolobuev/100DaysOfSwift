//
//  GameScene.swift
//  100swift_Project26
//
//  Created by MAC on 04/01/2020.
//  Copyright © 2020 Gera Volobuev. All rights reserved.
//

import CoreMotion
import SpriteKit

enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case teleport1 = 10
    case teleport2 = 12
    case finish = 16
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint!
    
    var teleportPosition: CGPoint!
    var motionManager: CMMotionManager?
    
    var gameOver: SKLabelNode!
    var isGameOver = false
    
    var scoreLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        gameOver = SKLabelNode(fontNamed: "Chalkduster")
        gameOver.text = "GAME OVER"
        gameOver.fontSize = 80
        gameOver.position = CGPoint(x: 512, y: 512)
        gameOver.horizontalAlignmentMode = .center
        gameOver.zPosition = -2
        addChild(gameOver)
        
        loadLevel()
        createPlayer()
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
    }
    
    func loadLevel() {
        guard let levelURL = Bundle.main.url(forResource: "level1", withExtension: "txt") else { fatalError("Could not find level1.txt in the app bundle.") }
        guard let levelString = try? String(contentsOf: levelURL) else { fatalError("Could not find level1.txt in the app bundle.") }
        
        let lines = levelString.components(separatedBy: "\n")
        
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                
                if letter != " " {
                    var node = SKSpriteNode()
                    if letter == "x" {
                        node = SKSpriteNode(imageNamed: "block")
                        node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
                        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
                        
                    } else if letter == "v" {
                        node = SKSpriteNode(imageNamed: "vortex")
                        node.name = "vortex"
                        node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
                        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
                        
                    } else if letter == "s" {
                        node = SKSpriteNode(imageNamed: "star")
                        node.name = "star"
                        node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
                        
                    } else if letter == "f" {
                        node = SKSpriteNode(imageNamed: "finish")
                        node.name = "finish"
                        node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
                        
                    } else if letter == "t" {
                        node = SKSpriteNode(imageNamed: "teleport")
                        node.name = "teleport"
                        node.physicsBody?.categoryBitMask = CollisionTypes.teleport1.rawValue
                        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
                        
                    }  else if letter == "T" {
                        node = SKSpriteNode(imageNamed: "teleport")
                        node.name = "Teleport"
                        node.physicsBody?.categoryBitMask = CollisionTypes.teleport2.rawValue
                        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
                        teleportPosition = position
                    }
                    
                    
                    node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                    node.physicsBody?.isDynamic = false
                    node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
                    node.physicsBody?.collisionBitMask = 0
                    node.position = position
                    addChild(node)
                    
                } else if letter == " " {
                    // do nothing with whitespace
                } else {
                    fatalError("Uknown level letter: \(letter).")
                }
                
            }
        }
    }
    
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 96, y: 672)
        player.zPosition = 1
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        addChild(player)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard isGameOver == false else { return }
        
        #if targetEnvironment(simulator)
        if let lastTouchPosition = lastTouchPosition {
            let diff = CGPoint(x: lastTouchPosition.x - player.position.x, y: lastTouchPosition.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        #else
        if let accelerometerData = motionManager?.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: CMAccelerometerData.acceleration.x * 50)
        }
        #endif
        
        if score < 0 {
            isGameOver = true
            gameOver.zPosition = 999
            physicsWorld.speed = 0
            isUserInteractionEnabled = false
            
            // restart the game after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.isGameOver = false
                let scene = GameScene(size: self.size) // Whichever scene you want to restart (and are in)
                let animation = SKTransition.crossFade(withDuration: 0.5) // ...Add transition if you like
                self.view?.presentScene(scene, transition: animation)
            }
            
            
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == "vortex" {
            
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) { [weak self] in
                self?.createPlayer()
                self?.isGameOver = false
            }
            
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "teleport" {
            let pos = teleportPosition!
            let move = SKAction.move(to: pos, duration: 0)
            let sequence = SKAction.sequence([move])            
            player.run(sequence)
            
        } else if node.name == "finish" {
            // next level?

        }
    }
}
