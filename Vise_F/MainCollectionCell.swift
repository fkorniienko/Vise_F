//
//  MainCollectionCell.swift
//  Vise
//
//  Created by Fedir Korniienko on 03.10.17.
//  Copyright © 2017 Fedir Korniienko. All rights reserved.
//

import UIKit

class MainCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView:           UIImageView!
    @IBOutlet weak var labelDescription:    UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //fill cell with data
    func fillCell(data: Clips?){
        
        guard let data = data else{return}
        
        if  UserDefaults.standard.string(forKey: "Ln") == "english"{
            
            labelDescription.text = data.descriptions?.english?.name ?? ""

        }
        
        if  UserDefaults.standard.string(forKey: "Ln") == "rus"{
            
            labelDescription.text = data.descriptions?.rus?.name ?? ""
            
        }
        
        if  UserDefaults.standard.string(forKey: "Ln") == "ukrain"{
            
            labelDescription.text = data.descriptions?.ukrain?.name ?? ""
            
        }
        
        
        let id = data.preview?.id ?? 0
        
        let url = URL(string: ServerManager.sharedManager.BaseAPIUrl + APIEndPoints.getImage.urlSufix + id.description + "&size=\(self.contentView.frame.width)")
        
        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "imageNotFound"), options: .transformAnimatedImage, completed: nil)
        
    }

}
