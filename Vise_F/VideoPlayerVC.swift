//
//  VideoPlayerController.swift
//  Vise
//
//  Created by Fedir Korniienko on 01.10.17.
//  Copyright © 2017 Ttech. All rights reserved.
//

import UIKit
import AVFoundation

protocol SendVideoDelegate{
    func sendVideo(url: String, duration: CMTime?, data: Clips?)
}

final class VideoPlayerViewController: UIViewController, ChangeQualityDelegate {
    
    @IBOutlet weak var invisibleButton: UIButton!
    @IBOutlet weak var playButton:              UIButton!
    @IBOutlet weak var minimizeButton:          UIBarButtonItem!
    @IBOutlet weak var navBar:                  UINavigationBar!
    @IBOutlet weak var loadingIndicatorView:    UIActivityIndicatorView!
    @IBOutlet weak var buttonCancel:            UIBarButtonItem!
    @IBOutlet weak var buttonQuality:           UIButton!
    @IBOutlet weak var seekSlider:              UISlider!
    @IBOutlet weak var timeRemainingLabel:      UILabel!
    @IBOutlet weak var bottomView:              UIView!
    
    private   var avPlayerLayer:        AVPlayerLayer!
    private   var qualityView:          QualityView?
    private   var timeObserver:         AnyObject!
    private   var avPlayer:             AVPlayer?
    private   var playerRateBeforeSeek: Float = 0
    private   var playbackLikelyToKeepUpContext = 0
    private let urlBase = ServerManager.sharedManager.BaseAPIUrl + APIEndPoints.getVideo.urlSufix
    
    var videoDelegate: SendVideoDelegate?
    var urlString = ""
    var clips: Clips?
    var videoData : [Files?] = []
    var titleVideo: String? = "Movie name"
    var curTime: CMTime?
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mainSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadingIndicatorView.startAnimating()
        self.avPlayer!.play()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.avPlayerLayer.frame = view.bounds
        loadingIndicatorView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
    }
    
    //MARK: IBActions
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        avPlayer?.removeTimeObserver(timeObserver)
        avPlayer?.removeObserver(self, forKeyPath: "currentItem.playbackLikelyToKeepUp")
        avPlayer?.pause()
        avPlayerLayer = nil
        avPlayer = nil
        videoData = []
        qualityView = nil
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //close controller and prepare minimize view
    @IBAction func minimizeButton(_ sender: Any) {
        
        self.videoDelegate?.sendVideo(url: urlBase+urlString, duration: curTime, data: clips)
        avPlayer?.pause()
        avPlayer?.removeTimeObserver(timeObserver)
        avPlayer?.removeObserver(self, forKeyPath: "currentItem.playbackLikelyToKeepUp")
        avPlayerLayer = nil
        videoData = []
        qualityView = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playButton(_ sender: UIButton) {
        
        if sender.tag == 0 {
            self.avPlayer!.pause()
            sender.setImage(UIImage(named: "play"), for: .normal)
            sender.tag = 1
        }else{
            
            self.avPlayer!.play()
            sender.setImage(UIImage(named: "pause"), for: .normal)
            sender.tag = 0
        }
    }
    
    @IBAction func invisibleButton(_ sender: UIButton) {
        if self.avPlayer?.timeControlStatus == .waitingToPlayAtSpecifiedRate {return}
        UIView.animate(withDuration: 1.0, animations: {
            self.navBar.alpha = self.navBar.alpha == 1 ? 0:1
            self.bottomView.alpha = self.bottomView.alpha == 1 ? 0:1
            self.qualityView?.alpha = self.bottomView.alpha == 1 ? 0:1
        })
    }
    //MARK: setup controller
    //setup controller
    private func mainSetup(){
        view.backgroundColor = .black
        avPlayer = AVPlayer()
        setupPlayer()
        setupActions()
        loadingIndicatorView.hidesWhenStopped = true
        buttonQuality.setTitle(videoData[0]?.type ?? "", for: .normal)
        buttonQuality.layer.cornerRadius = 5
        navBar.topItem?.title = titleVideo
        avPlayerLayer = AVPlayerLayer(player: avPlayer!)
        self.view.layer.insertSublayer(avPlayerLayer, at: 0)
        if curTime != nil{
            avPlayer?.seek(to: curTime!)
        }
    }
    //setup IBActions
    private func setupActions(){
        
        self.seekSlider.addTarget(self, action: #selector(sliderBeganTracking), for: .touchDown)
        self.seekSlider.addTarget(self, action: #selector(sliderEndedTracking), for: [.touchUpInside, .touchUpOutside])
        self.seekSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        self.buttonQuality.addTarget(self, action: #selector(showQualityView), for: .touchUpInside)
        
    }
    
    // setup player and observers for player
    private func setupPlayer(){
        
        let url = NSURL(string: urlBase + urlString)
        let playerItem = AVPlayerItem(url: url! as URL)
        self.playButton.setTitle("play", for: .normal)
        self.avPlayer?.replaceCurrentItem(with: playerItem)
        self.avPlayer?.addObserver(self, forKeyPath: "currentItem.playbackLikelyToKeepUp",
                                   options: .new, context: &playbackLikelyToKeepUpContext)
        
        let timeInterval: CMTime = CMTimeMakeWithSeconds(1.0, 10)
        self.timeObserver = self.avPlayer?.addPeriodicTimeObserver(forInterval: timeInterval,
                                                                   queue: DispatchQueue.main) {
                                                                    (elapsedTime: CMTime) -> Void in
                                                                    self.observeTime(elapsedTime: elapsedTime)
                                                                    self.seekSlider.value = Float(CMTimeGetSeconds(self.avPlayer!.currentItem!.currentTime()))
                                                                    if self.seekSlider.maximumValue == 1.0{
                                                                        
                                                                        if !CMTimeGetSeconds((self.avPlayer?.currentItem!.duration)!).isNaN{
                                                                            self.seekSlider.maximumValue = Float((CMTimeGetSeconds((self.avPlayer?.currentItem!.duration)!)))
                                                                        }
                                                                    }
                                                                    
            } as AnyObject
    }
    
   // check video loading
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &playbackLikelyToKeepUpContext {
            guard (avPlayer != nil), ((avPlayer?.currentItem) != nil) else{return}
            if avPlayer!.currentItem!.isPlaybackLikelyToKeepUp {
                loadingIndicatorView.stopAnimating()
            } else {
                loadingIndicatorView.startAnimating()
            }
        }
    }
    
    //MARK: slider actions
    //check time
    func observeTime(elapsedTime: CMTime) {
        let duration = CMTimeGetSeconds(avPlayer!.currentItem!.duration)
        if duration >= CMTimeGetSeconds(avPlayer!.currentItem!.currentTime()) {
            let elapsedTime = CMTimeGetSeconds(elapsedTime)
            curTime = avPlayer!.currentItem!.currentTime()
            updateTimeLabel(elapsedTime: elapsedTime, duration: duration)
        }
    }
    func sliderBeganTracking(slider: UISlider) {
        playerRateBeforeSeek = avPlayer!.rate
        avPlayer?.pause()
    }
    
    func sliderEndedTracking(slider: UISlider) {
        let videoDuration = CMTimeGetSeconds(avPlayer!.currentItem!.duration)
        let elapsedTime: Float64 =  Float64(self.seekSlider.value)/60
        updateTimeLabel(elapsedTime: elapsedTime, duration: videoDuration)
        avPlayer?.seek(to: CMTimeMakeWithSeconds(elapsedTime*60, 100)) { (completed: Bool) -> Void in
            if self.playerRateBeforeSeek > 0 {
                self.avPlayer?.play()
                
            }
        }
    }
    
    func sliderValueChanged(slider: UISlider) {
        
        let videoDuration = CMTimeGetSeconds(avPlayer!.currentItem!.duration)
        let elapsedTime: Float64 =  Float64(slider.value)
        updateTimeLabel(elapsedTime: elapsedTime, duration: videoDuration)
    }
    
    // update time label after change
    private func updateTimeLabel(elapsedTime: Float64, duration: Float64) {
        let timeRemaining: Float64 = CMTimeGetSeconds(avPlayer!.currentItem!.duration) - elapsedTime
        self.timeRemainingLabel.text = String(format: "%02d:%02d", ((lround(timeRemaining) / 60) % 60), lround(timeRemaining) % 60)
    }
    
    //MARK: quality view
    //add or remove quality view
    func showQualityView(){
        let count = self.view.subviews.filter{$0 is QualityView}
        if count.count == 0 {
            qualityView = QualityView(frame: CGRect.null, style: .plain)
            qualityView?.videoData = videoData
            self.view.addSubview(qualityView!)
            qualityView?.delegateQuality = self
            qualityView?.translatesAutoresizingMaskIntoConstraints = false
            qualityView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8).isActive = true
            qualityView?.bottomAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: -8).isActive = true
            qualityView?.widthAnchor.constraint(equalToConstant: 80).isActive = true
            qualityView?.heightAnchor.constraint(equalToConstant: 100).isActive = true
        }else{
            qualityView?.removeFromSuperview()
        }
    }
    
    //Delegate method after change value in quality view
    func change(quality: Files?){
        
        guard let quality = quality else{return}
        urlString = quality.id?.description ?? ""
        buttonQuality.setTitle(quality.type ?? "", for: .normal)
        qualityView?.removeFromSuperview()
        setupPlayer()
        
    }
}
