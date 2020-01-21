//
//  ViewController.swift
//  ObjectAR
//
//  Created by Damian Jahn on 21/01/2020.
//  Copyright © 2020 Damian Jahn. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var SceneView: ARSCNView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = ARWorldTrackingConfiguration()
        SceneView.session.run(config)
        
        addCube()
        addTapGestureToSceneView()
        
    }

    override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            SceneView.session.pause()
        }

        func addCube(x: Float = 0, y: Float = 0, z: Float = -0.3) {
            let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
            
            let cubeNode = SCNNode()
            cubeNode.geometry = cube
            cubeNode.position = SCNVector3(x, y, z)
            
            let scene = SCNScene()
            scene.rootNode.addChildNode(cubeNode)
            SceneView.scene = scene
        }
        
        func addTapGestureToSceneView() {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap(withGestureRecognizer:)))
            SceneView.addGestureRecognizer(tapGestureRecognizer)
        }
        
        @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer) {
            let tapLocation = recognizer.location(in: SceneView)
            let hitTestResults = SceneView.hitTest(tapLocation)
            
            guard let node = hitTestResults.first?.node else {
                let hitTestResultsWithFeaturePoints = SceneView.hitTest(tapLocation, types: .featurePoint)
                if let hitTestResultWithFeaturePoints = hitTestResultsWithFeaturePoints.first {
                    
                    let translation = hitTestResultWithFeaturePoints.worldTransform.translation
                    addCube(x: translation.x, y: translation.y, z: translation.z)
                }
                return
            }
            
            node.removeFromParentNode()
        }

    }

    extension float4x4 {
        var translation: float3 {
            let translation = self.columns.3
            return float3(translation.x, translation.y, translation.z)
        }
    }
    


