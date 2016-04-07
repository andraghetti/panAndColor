//
//  TextureController.swift
//  applicaPuntoInTexture
//
//  Created by Andraghetti on 26/11/15.
//  Copyright © 2015 Lorenzo Andraghetti. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import SpriteKit

class TextureViewController: UIViewController{
    
    
    @IBOutlet weak var TextureImageView: UIImageView!
    @IBOutlet weak var SKImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup() -> Void {
    
    }
    
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}

