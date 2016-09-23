//
//  ViewController.swift
//  CrashScene
//
//  Created by Thaddeus Ternes on 9/23/16.
//  Copyright © 2016 Thaddeus Ternes. All rights reserved.
//

import UIKit
import SceneKit

class ViewController: UIViewController {

    @IBOutlet var carModelView: SCNView!
    var scene: SCNScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        carModelView?.scene = SCNScene(named: "SL_Derby_Assembly_1116_centered.obj")!
        
        let scaleFactor: Float = 0.5
        let identity = SCNMatrix4Identity
        let scale = SCNMatrix4Scale(identity, scaleFactor, scaleFactor, scaleFactor)
        
        var initialOrientation = SCNMatrix4Rotate(scale, Float(M_PI_2), 1, 0, 0)
        initialOrientation = SCNMatrix4Rotate(initialOrientation, Float(M_PI_2), 0, 1, 0)
        
        carModelView.scene!.rootNode.childNodes.first?.transform = initialOrientation
    }
}

