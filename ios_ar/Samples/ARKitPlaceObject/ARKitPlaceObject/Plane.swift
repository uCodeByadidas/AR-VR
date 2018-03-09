//
//  Plane.swift
//  ARKitPlaceObject
//
//  Created by Marcen, Rafael on 3/8/18.
//  Copyright © 2018 MARCEN, RAFAEL. All rights reserved.
//

import ARKit

class Plane : SCNNode {
    
    private var anchor : ARPlaneAnchor
    private var plane : SCNPlane
    
    init(anchor : ARPlaneAnchor) {
        self.anchor = anchor
        self.plane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        
        super.init()
        
        let image = UIImage(named: "grid")
        let material = SCNMaterial()
        material.diffuse.contents = image
        //material.isDoubleSided = true
        
        self.plane.materials = [material]
        
        // Create a node with the plane geometry we created
        let planeNode = SCNNode(geometry: self.plane)
        planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        
        // SCNPlanes are vertically oriented in their local coordinate space.
        // Rotate it to match the horizontal orientation of the ARPlaneAnchor.
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        
        self.setTextureScale()
        self.addChildNode(planeNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(anchor : ARPlaneAnchor) {
        self.plane.width = CGFloat(anchor.extent.x)
        self.plane.height = CGFloat(anchor.extent.z)
        
        self.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
        self.setTextureScale()
    }
    
    func setTextureScale() {
        let width = self.plane.width
        let height = self.plane.height
        
        let material = self.plane.materials.first!
        
        material.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(width), Float(height), 1)
        material.diffuse.wrapS = .repeat
        material.diffuse.wrapT = .repeat
    }
}
