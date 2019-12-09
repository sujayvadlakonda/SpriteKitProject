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
    var motionManager = CMMotionManager()
    var timer: Timer!
    
    
    override func didMove(to view: SKView) {
        if (motionManager.isGyroAvailable) {
            startGyros()
        } else {
            // TODO show button controls instead
        }
        
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
        
        // paddle for the user
        paddle.position = CGPoint(x: size.width / 2, y: size.height * 0.1)
        paddle.size.width /= 4
        paddle.size.height /= 5
        addChild(paddle)
        
        paddle.physicsBody = SKPhysicsBody(rectangleOf: ball.size)
        paddle.physicsBody?.isDynamic = true
        paddle.physicsBody?.categoryBitMask = PhysicsCategory.ball
        paddle.physicsBody?.contactTestBitMask = PhysicsCategory.none
        paddle.physicsBody?.collisionBitMask = PhysicsCategory.paddle
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

