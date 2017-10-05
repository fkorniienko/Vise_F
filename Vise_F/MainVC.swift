//
//  MainVC.swift
//  Vise
//
//  Created by Fedir Korniienko on 03.10.17.
//  Copyright © 2017 Fedir Korniienko. All rights reserved.
//

import UIKit
import AVFoundation

class MainVC: UIViewController, SendVideoDelegate {
    var data: ClipsData?
    var collectionView: MainCollectionView?
    var avPlayer = AVPlayer()
    var curVideoData: Clips?
    
    @IBOutlet weak var minimizeWindow: UIView!
    @IBOutlet weak var minimizeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView = MainCollectionView(frame: self.view.frame, collectionViewLayout: UICollectionViewLayout.init())
        
        self.view.addSubview(collectionView!)
        self.view.bringSubview(toFront: minimizeWindow)
        self.view.bringSubview(toFront: minimizeView)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(resumeFullscreen(_:)))
        minimizeView.addGestureRecognizer(gesture)
        minimizeView.layer.cornerRadius = 10
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    //get video after minimize
    func sendVideo(url: String, duration: CMTime?, data: Clips?) {
        
        minimizeWindow.isHidden = false
        let url = NSURL(string: url)
        let playerItem = AVPlayerItem(url: url! as URL)
        self.curVideoData = data
        self.avPlayer.replaceCurrentItem(with: playerItem)
        
        let  avPlayerLayer = AVPlayerLayer(player: avPlayer)
        if duration != nil{
            avPlayer.seek(to: duration!)
        }
        let layerView = UIView()
        layerView.frame = minimizeView.bounds
        layerView.bounds = minimizeView.bounds
        layerView.backgroundColor = .black
        layerView.layer.cornerRadius = 5
        layerView.layer.borderWidth = 5
        layerView.layer.borderColor = UIColor.black.cgColor
        minimizeView.addSubview(layerView)
        minimizeView.layer.insertSublayer(avPlayerLayer, at: 0)
        avPlayerLayer.frame = minimizeView.bounds
        avPlayerLayer.bounds = minimizeView.bounds
        avPlayerLayer.cornerRadius = 10
        avPlayer.play()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        avPlayer.pause()
    }
    
    //MARK: resume full video
    @IBAction func closeButton(_ sender: UIButton) {
        avPlayer.pause()
        self.minimizeWindow.isHidden = true
    }
    
    func resumeFullscreen(_ tap: UITapGestureRecognizer){
        if let destinationVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: StoryboardIds.VideoPlayerViewController) as? VideoPlayerViewController {
            DispatchQueue.main.async {
                guard let data = self.curVideoData else {return}
                destinationVC.urlString = data.files[0]?.id?.description ?? "0"
                destinationVC.clips = data
                destinationVC.curTime = self.avPlayer.currentItem?.currentTime()
                destinationVC.videoData = data.files
                destinationVC.titleVideo = data.descriptions?.english?.name ?? "Movie name"
                destinationVC.videoDelegate = self
                self.present(destinationVC, animated: true, completion: nil)
                self.minimizeWindow.isHidden = true
                
            }
        }
    }
}
