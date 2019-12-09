import SpriteKit


struct PhysicsCategory {
    static let none      : UInt32 = 0
    static let ball   : UInt32 = 0b1
    static let paddle: UInt32 = 0b10
    static let brick: UInt32 = 0b10
}


class GameScene: SKScene {
    let ball = SKSpriteNode(imageNamed: "Ball")
    let paddle = SKSpriteNode(imageNamed: "Paddle")
    var timer = 0
    var newRound = true
    
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        let outerBounds = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.frame.width - 25, height: self.frame.height)) //Makes space for the notch on the iPhone XR
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: outerBounds)
        self.physicsBody?.categoryBitMask = PhysicsCategory.paddle

    
        backgroundColor = SKColor.black
        ball.position = CGPoint(x: size.width / 2, y: size.height * 0.3)
        ball.size.width /= 32
        ball.size.height /= 32
        addChild(ball)
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.categoryBitMask = PhysicsCategory.ball
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.none
        ball.physicsBody?.collisionBitMask = PhysicsCategory.paddle
        
        ball.physicsBody?.restitution = 1.0
        ball.physicsBody?.friction = 0.0
        ball.physicsBody?.linearDamping = 0.0
        ball.physicsBody?.angularDamping = 0.0
        ball.physicsBody?.affectedByGravity = false


        // paddle for the user
        paddle.position = CGPoint(x: size.width / 2, y: size.height * 0.1)
        paddle.size.width /= 4
        paddle.size.height /= 5
        addChild(paddle)
        
        paddle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: paddle.size.width, height: paddle.size.height - 20))
        paddle.physicsBody?.isDynamic = false
        paddle.physicsBody?.categoryBitMask = PhysicsCategory.paddle
        paddle.physicsBody?.contactTestBitMask = PhysicsCategory.none
        paddle.physicsBody?.collisionBitMask = PhysicsCategory.ball
    }
    
    override func update(_ currentTime: TimeInterval) {
        //Stops the ball from moving if it touches the bottom
        if ball.position.y <= 20
        {
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            timer += 1
            if(timer == 200)
            {
                ball.position = CGPoint(x: size.width / 2, y: size.height * 0.3)
                newRound = true
            }
        }
        else{
            timer = 0
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if newRound
        {
            let impulse = CGVector(dx: 3.0, dy: 3.0)
            ball.physicsBody?.applyImpulse(impulse)
            newRound = false
        }
    }
    
    
}

extension GameScene: SKPhysicsContactDelegate {
    
}

