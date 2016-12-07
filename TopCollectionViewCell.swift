//
//  TopCollectionViewCell.swift
//  ScrollMenu
//
//  Created by lyf on 15/7/15.
//  Copyright © 2015年 lyf. All rights reserved.
//  －－topMenu对应的cell

import UIKit

class TopCollectionViewCell: UICollectionViewCell {
    
   
    var fontSize: CGFloat = 14
    
    var titleColor:UIColor = UIColor.black {
        willSet{
            self.titleLabel?.textColor = newValue as UIColor
        }
    }
    var titleName:NSString {
        get{
            return self.titleName
        }
        set{
            self.titleLabel?.text = newValue as String
        }
    
    }
    
    var titleLabel : UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLable()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setupLable()
    }
    
    
    func setupLable(){
        self.titleLabel?.removeFromSuperview()
        self.backgroundColor = UIColor.groupTableViewBackground
        let titleLabel = UILabel()
        titleLabel.textAlignment = NSTextAlignment.center
        
        titleLabel.textColor = UIColor(red: 102 / 255, green: 102 / 255, blue: 102 / 255, alpha: 1)
        
        titleLabel.font = YD_Font(fontSize)
        
        titleLabel.tag = 101
        
        self.titleLabel = titleLabel
        
        self.addSubview(titleLabel)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel?.frame = self.bounds
    }
    
}
