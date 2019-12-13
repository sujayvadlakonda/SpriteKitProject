import SpriteKit
import CoreMotion

struct PhysicsCategory {
    static let none      : UInt32 = 0
    static let ball   : UInt32 = 0b1
    static let paddle: UInt32 = 0b10
    static let brick: UInt32 = 0b10
}


class GameScene: SKScene {
    let ball = SKSpriteNode(imageNamed: "Ball")
    let paddle = SKSpriteNode(imageNamed: "Paddle")
    var hearts = [SKSpriteNode(imageNamed: "Heart"), SKSpriteNode(imageNamed: "Heart"), SKSpriteNode(imageNamed: "Heart")]
    var motionManager = CMMotionManager()
    var timer: Timer!
    var time = 0
    var newRound = true
    var livesLeft = 3
    
    
    override func didMove(to view: SKView) {
        if (motionManager.isGyroAvailable) {
            startGyros()
        } else {
            // TODO show button controls instead
        }
        
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
        
        hearts[0].position = CGPoint(x: size.width * 0.033, y: size.height * 0.9)
        hearts[1].position = CGPoint(x: size.width * 0.066, y: size.height * 0.9)
        hearts[2].position = CGPoint(x: size.width * 0.099, y: size.height * 0.9)

        for heart in hearts {
            heart.size.width /= 64
            heart.size.height /= 64
            addChild(heart)
        }
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        //Stops the ball from moving if it touches the bottom
        if livesLeft == 0
        {
            newRound = false
        } else if ball.position.y <= 20
        {
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            time += 1
            if(time == 200)
            {
                ball.position = CGPoint(x: size.width / 2, y: size.height * 0.3)
                newRound = true
                livesLeft -= 1
                removeChildren(in: [hearts[hearts.count - 1]])
                hearts.removeLast()
            }
        }
        else{
            time = 0
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if newRound
        {
            let dx = Double.random(in: -3..<3)
            let impulse = CGVector(dx: dx, dy: 3.0)
            ball.physicsBody?.applyImpulse(impulse)
            newRound = false
        }
    }
    
    func startGyros() {
        
        if motionManager.isGyroAvailable {
            self.motionManager.gyroUpdateInterval = 1.0 / 60.0
            self.motionManager.startGyroUpdates()
            
            // Configure a timer to fetch the accelerometer data.
            timer = Timer(fire: Date(), interval: (1.0/60.0),
                          repeats: true, block: { (timer) in
                            // Get the gyro data.
                            if let data = self.motionManager.gyroData {
                                let z = data.rotationRate.z
                                
                                // Use the gyroscope data in your app.
                                self.paddle.position = CGPoint(x: CGFloat(self.paddle.position.x) - CGFloat(z * 10), y: self.paddle.position.y)
                            }
            })
            
            // Add the timer to the current run loop.
            RunLoop.current.add(timer!, forMode: RunLoop.Mode.default)
        }
    }
    
    func stopGyros() {
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
            
            self.motionManager.stopGyroUpdates()
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
}

