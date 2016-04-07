//
//  GameViewController.swift
//  applicaPuntoInTexture
//
//  Created by Andraghetti on 25/11/15.
//  Copyright (c) 2015 Lorenzo Andraghetti. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import SpriteKit

class GameViewController: UIViewController {
    
    // create a new scene
    let scene = SCNScene(named: "art.scnassets/ship.scn")!

    var nodeToDrawOn: SCNNode!
    var skScene: SKScene!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
    
    func initialSetup() -> Void {
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = UIColor.darkGrayColor()
        scene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        //IMPORTANTE:
        //1. get ship
        nodeToDrawOn = scene.rootNode.childNodeWithName("shipMesh", recursively: true)!
        
        // 2. set up that node's texture as a SpriteKit scene
        let currentImageURL = nodeToDrawOn.geometry!.firstMaterial!.diffuse.contents as! NSURL
        let currentImage = UIImage(data: NSData(contentsOfURL: currentImageURL)!)!
        
        //let texture: SKTexture = textureFromNode(nodeToDrawOn)
        skScene = SKScene(size: currentImage.size)
        
        nodeToDrawOn.geometry!.firstMaterial!.diffuse.contents = skScene
        
        let translate = SCNMatrix4MakeTranslation(0, 1, 0)
        let yFlippedTranslate = SCNMatrix4Scale(translate, 1, -1, 1)
        nodeToDrawOn.geometry!.firstMaterial!.diffuse.contentsTransform = yFlippedTranslate
        
        
        // 3. put the currentImage into a background sprite for the skScene
        let background = SKSpriteNode(texture: SKTexture(image: currentImage))
        background.position = CGPoint(x: skScene.frame.midX, y: skScene.frame.midY)
        
        skScene.addChild(background)
        
        // add a pan gesture recognizer
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(GameViewController.handlePan(_:)))
        scnView.addGestureRecognizer(panGesture)

    }
    
    @IBOutlet weak var tempImageView: UIImageView!
    
    func printSpot(result: SCNHitTestResult) {
        
        let sprite = SKSpriteNode(color: SKColor.redColor(), size: CGSize(width: 10, height: 10))
        
        let texcoord = result.textureCoordinatesWithMappingChannel(0)
        sprite.position.x = texcoord.x * skScene.size.width
        sprite.position.y = (1 - texcoord.y) * skScene.size.height
        
        skScene.addChild(sprite)
    }
    
    func handlePan(sender: UIPanGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        let results = scnView.hitTest(sender.locationInView(scnView), options: [SCNHitTestFirstFoundOnlyKey: true]) as [SCNHitTestResult]
        for result in results {
//            if result.node === nodeToDrawOn {
//                printSpot(result);
//            }
            printSpot(result);
        }
        
        nodeToDrawOn.position = SCNVector3(x: 0, y: 0, z: 5)
        nodeToDrawOn.position = SCNVector3(x: 0, y: 0, z: 0)

    }
    
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
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
