//
//  VirtualObject.swift
//  ARKitPlaceObject
//
//  Created by Marcen, Rafael on 3/8/18.
//  Copyright © 2018 MARCEN, RAFAEL. All rights reserved.
//

import SceneKit

class VirtualObject: SCNNode {
    
    var objectName: String!
    var isPlaced: Bool = false
    
    override init() {
        super.init()
    }
    
    init(name objectName: String) {
        super.init()
        self.objectName = objectName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadModel() {
        guard let virtualObject = SCNScene(named: objectName, inDirectory: "art.scnassets", options: nil) else {
            return
        }
        
        let wrapperNode = SCNNode()
        for child in virtualObject.rootNode.childNodes {
            child.geometry?.firstMaterial?.lightingModel = .phong
            wrapperNode.addChildNode(child)
        }
        
        self.addChildNode(wrapperNode)
        isPlaced = true
    }
    
    func unLoadModel(child: SCNNode) {
        child.removeFromParentNode()
        isPlaced = false
    }
}
