//
//  MonsterImg.swift
//  mylittlemonster
//
//  Created by Bruce Burgess on 3/24/16.
//  Copyright © 2016 Red Raven Computing Studios. All rights reserved.
//

import Foundation
import UIKit

class MonsterImg: UIImageView {
    
    //var name: String = "idle"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //playIdleAnimation(name)
    }
    
    func playIdleAnimation(name: String) {
        self.image = UIImage(named: "\(name)1.png")
        
        self.animationImages = nil
        
        var imgArray = [UIImage]()
        for x in 1...4 {
            let img = UIImage(named: "\(name)\(x).png")
            imgArray.append(img!)
        }
        
        self.animationImages = imgArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 0
        self.startAnimating()
    }
    
    func playDeathAnimation(name: String) {
        
        self.image = UIImage(named: "\(name)5.png")
        
        self.animationImages = nil
        
        var imgArray = [UIImage]()
        for x in 1...5 {
            let img = UIImage(named: "\(name)\(x).png")
            imgArray.append(img!)
        }
        
        self.animationImages = imgArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 1
        self.startAnimating()

    }
}