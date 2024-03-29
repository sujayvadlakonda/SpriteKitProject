//
//  GameViewController.swift
//  SpriteKitProject
//
//  Created by Vadlakonda, Sujay V on 12/3/19.
//  Copyright © 2019 Vadlakonda, Sujay V. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import CoreMotion

class GameViewController: UIViewController {
    var scene : GameScene!
    var motionManager : CMMotionManager!
    var arrowKeySpeed:Int = 10
    var loopRun: Timer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        
        
        loopRun = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(self.loop), userInfo:nil,repeats: true)
        //
    }
    
    
    
    @objc func loop()
    {
        if(scene.livesLeft == 0){
            loopRun.invalidate()
            loopRun = nil
            self.performSegue(withIdentifier: "666", sender: self)
            scene = GameScene(size: view.bounds.size)
            loopRun = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(self.loop), userInfo:nil,repeats: true)
        }
        
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var keyCommands: [UIKeyCommand]? {
        return [
            UIKeyCommand(input: UIKeyCommand.inputLeftArrow, modifierFlags: .shift, action: #selector(left), discoverabilityTitle: "Back"),
            UIKeyCommand(input: UIKeyCommand.inputRightArrow, modifierFlags: .shift, action: #selector(right), discoverabilityTitle: "Back")
        ]
    }
    
    @objc private func left() {
        scene.paddle.position.x -= CGFloat(arrowKeySpeed)
    }
    @objc private func right() {
        scene.paddle.position.x += CGFloat(arrowKeySpeed)
    }
}
