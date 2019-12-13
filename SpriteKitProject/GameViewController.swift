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
        
        
        let _ = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(self.fire), userInfo:nil,repeats: true)
        //
    }
    
    
    
    @objc func fire()
    {
        if(scene.livesLeft == 0){
            self.performSegue(withIdentifier: "666", sender: self)
        }
        
    }
    
    
    
    

}
