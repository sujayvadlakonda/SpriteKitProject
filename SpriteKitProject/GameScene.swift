import SpriteKit
import CoreMotion

struct PhysicsCategory {
    static let none      : UInt32 = 0
    static let ball   : UInt32 = 0b1
    static let paddle: UInt32 = 0b10
    static let brick: UInt32 = 0b11
    static let wall: UInt32 = 0b100
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    let ball = SKSpriteNode(imageNamed: "Ball")
    let paddle = SKSpriteNode(imageNamed: "Paddle")
    var hearts = [SKSpriteNode(imageNamed: "Heart"), SKSpriteNode(imageNamed: "Heart"), SKSpriteNode(imageNamed: "Heart")]
    var motionManager = CMMotionManager()
    var timer: Timer!
    var time = 0
    var newRound = true
    var livesLeft = 3
    var leftBtn: FTButtonNode!
    var rightBtn: FTButtonNode!
    
    //brick layout controls
    let brickMaxWidth: Int = 100
    let brickMinWidth: Int = 50
    let brickHeight: Int = 25
    let brickGap: Int = 10
    let brickRowSeperation: Int = 10
    
    
    override func didMove(to view: SKView) {
        if (motionManager.isGyroAvailable) {
            startGyros()
        } else {
            leftBtn = FTButtonNode(imageNamed: "Area")
            leftBtn.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(leftBtnTap))
            leftBtn.position = CGPoint(x: size.width / 4, y: size.height / 2)
            leftBtn.size.width = size.width / 2;
            leftBtn.size.height = size.height;
            leftBtn.name = "leftBtn"
            self.addChild(leftBtn)

            rightBtn = FTButtonNode(imageNamed: "Area")
            rightBtn.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(rightBtnTap))
            rightBtn.position = CGPoint(x: size.width / 4 * 3, y: size.height / 2)
            rightBtn.size.width = size.width / 2;
            rightBtn.size.height = size.height;
            rightBtn.name = "rightBtn"
            self.addChild(rightBtn)
        }
        
        // music setup
        let backgroundMusic = SKAudioNode(fileNamed: "/Sounds/Atari Arcade Music - Super Breakout.mp3")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        let outerBounds = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.frame.width - 25, height: self.frame.height)) //Makes space for the notch on the iPhone XR
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: outerBounds)
        self.physicsBody?.categoryBitMask = PhysicsCategory.wall

    
        backgroundColor = SKColor.black
        ball.position = CGPoint(x: size.width / 2, y: size.height * 0.3)
        ball.size.width /= 32
        ball.size.height /= 32
        ball.name = "ball"
        addChild(ball)
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.categoryBitMask = PhysicsCategory.ball
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.none
        ball.physicsBody?.collisionBitMask = PhysicsCategory.wall | PhysicsCategory.paddle | PhysicsCategory.brick
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
        
        paddle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: paddle.size.width, height: paddle.size.height))
        paddle.physicsBody?.isDynamic = false
        paddle.physicsBody?.categoryBitMask = PhysicsCategory.paddle
        paddle.physicsBody?.contactTestBitMask = PhysicsCategory.ball
        paddle.physicsBody?.collisionBitMask = PhysicsCategory.ball
        
        //Laying bricks
        var brickYPos: Int = Int(size.height) - brickHeight
        var brickColor: UIColor
        
        for n in 1...5
        {
            switch(n)
            {//rows color
            case 1:
                brickColor = .red
            case 2:
                brickColor = .orange
            case 3:
                brickColor = .yellow
            case 4:
                brickColor = .green
            case 5:
                brickColor = .blue
            
            default:
                brickColor = UIColor.black
            }
            
            var screenWidth = 0
            
            while(screenWidth < Int(size.width))
            {
                let newBrick = SKSpriteNode(imageNamed: "Brick")
                var width = Int.random(in: brickMinWidth...brickMaxWidth)
                
                newBrick.size.width = CGFloat(width)
                
                if Int(size.width) - (width + screenWidth) < brickMinWidth + brickGap //This prevents tiny bricks on the screen edge
                {
                    width = Int(size.width) - screenWidth
                }
                
                
                newBrick.size.height = CGFloat(brickHeight)
                newBrick.position = CGPoint(x: CGFloat(screenWidth) + newBrick.size.width/2, y: CGFloat(brickYPos))
                
                newBrick.physicsBody = SKPhysicsBody(rectangleOf: newBrick.size)
                newBrick.physicsBody?.isDynamic = false
                newBrick.physicsBody?.categoryBitMask = PhysicsCategory.brick
                newBrick.physicsBody?.collisionBitMask = PhysicsCategory.ball
                newBrick.physicsBody?.contactTestBitMask = PhysicsCategory.ball
                
                newBrick.colorBlendFactor = 1.0
                newBrick.color = brickColor
                
                addChild(newBrick)
                
                screenWidth += Int(newBrick.size.width) + brickGap
            }
            brickYPos -= (brickHeight + brickRowSeperation)
        }

        
        hearts[0].position = CGPoint(x: size.width * 0.033, y: size.height * 0.1)
        hearts[1].position = CGPoint(x: size.width * 0.066, y: size.height * 0.1)
        hearts[2].position = CGPoint(x: size.width * 0.099, y: size.height * 0.1)

        for heart in hearts {
            heart.size.width /= 64
            heart.size.height /= 64
            addChild(heart)
        }
        
        
    }
    
    @objc func leftBtnTap() {
        print("leftBtnTap tapped")
        paddle.position = CGPoint(x: paddle.position.x - 10, y: paddle.position.y)
    }
    
    @objc func rightBtnTap() {
        print("rightBtnTap tapped")
        paddle.position = CGPoint(x: paddle.position.x + 10, y: paddle.position.y)
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
            if(time == 50)
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
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("Contact Occurred")
        if contact.bodyA.node?.name == "ball" {
            if contact.bodyB.node?.physicsBody?.categoryBitMask == PhysicsCategory.paddle
            {
                ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                randomImpulse()
            }
        }
        if contact.bodyB.node?.name == "ball" {
            if contact.bodyA.node?.physicsBody?.categoryBitMask == PhysicsCategory.paddle
            {
                ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                randomImpulse()
            }
        }
        if contact.bodyA.categoryBitMask == PhysicsCategory.brick
        {
            if contact.bodyB.node?.name == "ball" {
                contact.bodyA.node?.removeFromParent()
            }
        }
        if contact.bodyB.categoryBitMask == PhysicsCategory.brick
        {
            if contact.bodyA.node?.name == "ball" {
                contact.bodyB.node?.removeFromParent()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if newRound
        {
            let dx = Double.random(in: -3..<3)
            let impulse = CGVector(dx: 0, dy: 5.0)//Replace with randomImpulse() eventually
            ball.physicsBody?.applyImpulse(impulse)
            newRound = false
        }
    }
    
    func randomImpulse() {
        let dx = Double.random(in: -3..<3)
        let impulse = CGVector(dx: dx, dy: 6.0)
        ball.physicsBody?.applyImpulse(impulse)
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
