//
//  QualityView.swift
//  Vise
//
//  Created by Fedir Korniienko on 02.10.17.
//  Copyright © 2017 Ttech. All rights reserved.
//

import UIKit
protocol ChangeQualityDelegate{
    func change(quality: Files?)
}
class QualityView: UITableView, UITableViewDelegate,UITableViewDataSource{
    
    var delegateQuality: ChangeQualityDelegate?
    var videoData : [Files?] = []
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
        self.separatorStyle = .none
        self.sectionHeaderHeight = 0.1
        self.sectionFooterHeight = 0.1
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return videoData.count 
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell()
        let quality = videoData[indexPath.row]?.type
        cell.textLabel?.text = quality ?? ""
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegateQuality?.change(quality: videoData[indexPath.row] ?? nil)
    }
    
    
    deinit {
        print("quality view deinit")
    }
}
