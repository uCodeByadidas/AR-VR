//
//  ViewController.swift
//  ARKitPlaceObject
//
//  Created by Marcen, Rafael on 3/8/18.
//  Copyright © 2018 MARCEN, RAFAEL. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    private let session = ARSession()
    
    private var planes : [UUID : Plane] = [:]
    private var virtualObject = VirtualObject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    private func setupScene() {
        // Set the view's delegate
        self.sceneView.delegate = self
        
        self.planes = [:]
        
        // Show statistics such as fps and timing information
        self.sceneView.showsStatistics = true
        
        self.sceneView.autoenablesDefaultLighting = true
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        
        self.sceneView.session = session
        self.sceneView.antialiasingMode = .multisampling4X
        self.sceneView.automaticallyUpdatesLighting = false
        
        self.sceneView.preferredFramesPerSecond = 60
        self.sceneView.contentScaleFactor = 1.3
        //sceneView.showsStatistics = true
        
        self.enableEnvironmentMapWithIntensity(25.0)
        
        if let camera = sceneView.pointOfView?.camera {
            camera.wantsHDR = true
            camera.wantsExposureAdaptation = true
            camera.exposureOffset = -1
            camera.minimumExposure = -1
        }
    }
    
    private func setupSession() {
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Specify that we do want to track horizontal planes
        configuration.planeDetection = .horizontal
        
        configuration.isLightEstimationEnabled =  true
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: sceneView)
            let planeHitTestResults = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
            
            // Use the first result which is the closest intersection to the camera
            if let result = planeHitTestResults.first, let planeAnchor = result.anchor {
                
                virtualObject = VirtualObject(name: "Predator.scn")
                virtualObject.loadModel()
                
                virtualObject.transform = SCNMatrix4(planeAnchor.transform)
                sceneView.scene.rootNode.addChildNode(virtualObject)
            }
        }
    }
}

// MARK: - ARSCNViewDelegate
extension ViewController : ARSCNViewDelegate {
    
    // When a plane is detected, make a new plane for it
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        
        let plane = Plane(anchor : planeAnchor)
        self.planes.updateValue(plane, forKey: anchor.identifier)
        node.addChildNode(plane)
    }
    
    // When a detected plane is updated, update the plane
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        
        guard let plane = self.planes[anchor.identifier] else {
            return
        }
        
        plane.update(anchor : planeAnchor)
    }
    
    // When a detected plane is removed, remove the plane
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        
        guard anchor is ARPlaneAnchor else {
            return
        }
        
        self.planes.removeValue(forKey: anchor.identifier)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            // If light estimation is enabled, update the intensity of the model's lights and the environment map
            if let lightEstimate = self.session.currentFrame?.lightEstimate {
                self.enableEnvironmentMapWithIntensity(lightEstimate.ambientIntensity / 40)
            } else {
                self.enableEnvironmentMapWithIntensity(25)
            }
        }
    }
    
    func enableEnvironmentMapWithIntensity(_ intensity: CGFloat) {
        if sceneView.scene.lightingEnvironment.contents == nil {
            if let environmentMap = UIImage(named: "art.scnassets/sharedImages/environment_blur.exr") {
                sceneView.scene.lightingEnvironment.contents = environmentMap
            }
        }
        sceneView.scene.lightingEnvironment.intensity = intensity
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        virtualObject.unLoadModel(child: virtualObject)
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
