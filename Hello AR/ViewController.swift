//
//  ViewController.swift
//  Hello AR
//
//  Created by 黄智超 on 2020/5/26.
//  Copyright © 2020 yellow. All rights reserved.
//

import UIKit
import SceneKit
import ARKit


class ViewController: UIViewController, ARSCNViewDelegate {

    var trackingStatus: String = ""

    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var styleButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var startButton: UIButton!

    @IBAction func clickStyle(_ sender: UIButton) {
    }
    @IBAction func clickRest(_ sender: Any) {
    }
    @IBAction func clickStart(_ sender: Any) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the view's delegate
//        sceneView.delegate = self
//
//        // Show statistics such as fps and timing information
////        sceneView.showsStatistics = true
//
//        // Create a new scene
//        let scene = SCNScene(named: "ARResource.scnassets/SimpleScene.scn")! //指定加载场景模型
//
//        // Set the scene to the view
//        sceneView.scene = scene  wire frame

        initSceneView()
        let scene = SCNScene(named: "ARResource.scnassets/SimpleScene.scn")! //指定加载场景模型
        sceneView.scene = scene
        sceneView.showsStatistics = true
        sceneView.debugOptions = [
            SCNDebugOptions.showFeaturePoints,
            SCNDebugOptions.showWorldOrigin,
            SCNDebugOptions.showBoundingBoxes,
            SCNDebugOptions.showWireframe
        ]
    }


    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    // MARK: - private function
    func initSceneView() {
        guard ARWorldTrackingConfiguration.isSupported else {
            print("not support")
            return
        }
        let config = ARWorldTrackingConfiguration()
        config.worldAlignment = .gravity
        sceneView.session.run(config)
        sceneView.delegate = self
    }
}

extension ViewController: ARSessionDelegate {

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            self.statusLabel.text = self.trackingStatus
        }
    }

    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
        case .normal:
            trackingStatus = "normal"
        case .notAvailable:
            trackingStatus = "not available"
        case .limited(let reason):
            switch reason {
            case .excessiveMotion:
                trackingStatus = "too shake"
            case .initializing:
                trackingStatus = "initializing"
            case .insufficientFeatures:
                trackingStatus = "curent scence can not distinguish"
            case .relocalizing:
                trackingStatus = "interruption"
            }
        }
    }

}
