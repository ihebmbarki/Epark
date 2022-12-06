//
//  ViewController.swift
//  Epark
//
//  Created by iheb mbarki on 8/11/2022.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    var videoPlayer: AVPlayer?
    var videoPlayerLayer: AVPlayerLayer?

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         
        setUpelements()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //Set up video ini background
        setUpVideo()
    }
    
    
    func setUpelements() {
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleFilledButton(loginButton)
    }
    
    func setUpVideo() {
        
        //Get path of the resource in the bundle
        let bundlePath = Bundle.main.path(forResource: "Drone_shot", ofType: "mp4")
        
        //assert that we have a path to that resource
        guard bundlePath != nil else {
            return
        }
        
        //Create url
        let url = URL(fileURLWithPath: bundlePath!)
        
        //Create the video player item
        let item = AVPlayerItem(url: url)
        
        //Create video player
        videoPlayer = AVPlayer(playerItem: item)
        
        //Layer
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        
        //Size and frame
        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width * 1.5, y: 0,
                                         width: self.view.frame.size.width * 4,
                                         height: view.frame.size.height)

        
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        
        //Add it to viiew and play
        videoPlayer?.playImmediately(atRate: 0.5)
    }
    

}


