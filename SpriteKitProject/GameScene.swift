//
//  GameScene.swift
//  SpriteKitProject
//
//  Created by Vadlakonda, Sujay V on 12/3/19.
//  Copyright © 2019 Vadlakonda, Sujay V. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
    static let none      : UInt32 = 0
    static let ball   : UInt32 = 0b1
    static let paddle: UInt32 = 0b10
    static let brick: UInt32 = 0b10
}

func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
}
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

class GameScene: SKScene {
    let ball = SKSpriteNode(imageNamed: "Ball")
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = PhysicsCategory.paddle

    
        backgroundColor = SKColor.black
        ball.position = CGPoint(x: size.width / 2, y: size.height * 0.1)
        ball.size.width /= 32
        ball.size.height /= 32
        addChild(ball)
        
        ball.physicsBody = SKPhysicsBody(rectangleOf: ball.size)
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.categoryBitMask = PhysicsCategory.ball
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.none
        ball.physicsBody?.collisionBitMask = PhysicsCategory.paddle
        
        ball.physicsBody?.restitution = 1.0;
        ball.physicsBody?.friction = 0.0;
        ball.physicsBody?.linearDamping = 0.0;
        ball.physicsBody?.angularDamping = 0.0;
        ball.physicsBody?.affectedByGravity = false;

        let impulse = CGVector(dx: 3.0, dy: 3.0);
        ball.physicsBody?.applyImpulse(impulse)
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
}

