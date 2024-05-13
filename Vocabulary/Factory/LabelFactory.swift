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
    
}
