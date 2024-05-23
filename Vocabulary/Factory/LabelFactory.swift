//
//  LabelFactory.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/13/24.
//

import UIKit

class LabelFactory {
    
    func makeLabel (title: String, color: UIColor = .black, size: CGFloat, textAlignment: NSTextAlignment = .center, isBold: Bool) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = color
        if isBold == true {
            label.font = UIFont.boldSystemFont(ofSize: size)
        } else {
            label.font = UIFont.systemFont(ofSize: size)
        }
        label.textAlignment = textAlignment
        label.numberOfLines = 0
        
        return label
    }
    
    func hangManLabel (title: String, color: UIColor = .black, size: CGFloat, textAlignment: NSTextAlignment = .center, isBold: Bool) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = color
        if isBold == true {
            label.font = UIFont.boldSystemFont(ofSize: size)
        } else {
            label.font = UIFont.systemFont(ofSize: size)
        }
        label.textAlignment = textAlignment
        label.numberOfLines = 0
        
        return label
    }
    
    func detailVCLabel (title: String, color: UIColor = .black, size: CGFloat, textAlignment: NSTextAlignment = .center, isBold: Bool) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = color
        if isBold == true {
            label.font = UIFont.boldSystemFont(ofSize: size)
        } else {
            label.font = UIFont.systemFont(ofSize: size)
        }
        label.textAlignment = textAlignment
        label.numberOfLines = 0
        
        return label
    }
    
    func detailTextFieldLabel() -> PaddedLabel {
        
        let label = PaddedLabel()
        
        label.textInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        label.textColor = .black
        label.textAlignment = .left
        label.backgroundColor = .white
   
        //테두리 색상 추가
        label.layer.borderColor = ThemeColor.mainCgColor
        label.layer.borderWidth = 2
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 0
        
        
        // 레이블 높이 설정
        let heightConstraint = NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 46)
        label.addConstraint(heightConstraint)
        
        return label
    }
    
}

class PaddedLabel: UILabel {
    var textInsets = UIEdgeInsets.zero
    
    override func drawText(in rect: CGRect) {
        let insets = textInsets
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInsets.left + textInsets.right,
                      height: size.height + textInsets.top + textInsets.bottom)
    }
}
