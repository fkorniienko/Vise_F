//
//  MainCollectionView.swift
//  Vise
//
//  Created by Fedir Korniienko on 03.10.17.
//  Copyright © 2017 Fedir Korniienko. All rights reserved.
//

import UIKit
import SDWebImage

class MainCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var cell : MainCollectionCell?
    var page = 1
    var clipsData: DataList?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        let sizeCollectionItem  = frame.width/2 - 10
        layout.itemSize = CGSize(width: sizeCollectionItem, height: sizeCollectionItem)
        layout.minimumLineSpacing = 5
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        super.init(frame: frame, collectionViewLayout: layout)
        setupCollectionView()
        fetchData(page: self.page)
    }
    
    private func setupCollectionView(){
        self.delegate = self
        self.dataSource = self
        self.contentSize = CGSize(width: frame.size.height, height: frame.size.height)
        self.frame.size.height = frame.size.height
        self.showsHorizontalScrollIndicator = false
        self.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        self.register(UINib.init(nibName: "MainCollectionCell", bundle: nil), forCellWithReuseIdentifier: "MainCollectionCell")
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
//MARK: collection Data source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return clipsData?.clips.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell: MainCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionCell", for: indexPath) as? MainCollectionCell {
            guard  let data = clipsData?.clips[indexPath.row] else {return UICollectionViewCell()}
            cell.fillCell(data: data)
            return cell
        }
        return UICollectionViewCell()

    }
    
    //MARK: collection delegate
    
    //make paggination
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if page*50 == indexPath.row + 1{
            page += 1
            fetchData(page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let destinationVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: StoryboardIds.VideoPlayerViewController) as? VideoPlayerViewController {
            DispatchQueue.main.async {
                guard let data = self.clipsData?.clips[indexPath.row] else{return}
                //TODO: need allert
                
                guard data.files.count != 0 else {return}
                let id = data.files[0]?.id?.description ?? ""
                destinationVC.urlString = id
                destinationVC.clips = data
                destinationVC.videoData = data.files
                destinationVC.titleVideo = data.descriptions?.english?.name ?? "Movie name"
                let mainVC = self.getTargetViewController()
                destinationVC.videoDelegate = mainVC as! SendVideoDelegate
                mainVC?.present(destinationVC, animated: true, completion: nil)
            }
            return
        }
    }
    //MARK: fetch server
    //get data from server
    private func fetchData(page: Int){
        ServerManager.sharedManager.fetchDataWithEndPoint(type: ClipsData.init(json: nil), endPoint: .getClips, urlStringParams: "?page=\(page)") { (data, error) in
            if let data = data as? ClipsData{
                if data.error == 0{
                    if self.page == 1{
                        self.clipsData = data.dataList
                    }else{
                        self.clipsData?.clips += data.dataList!.clips
                    }
                    self.reloadData()
                }
            }
        }
    }
}

struct StoryboardIds {
    
    static let VideoPlayerViewController: String = "VideoPlayerViewController"
}
