//
//  ButtonFactory.swift
//  Vocabulary
//
//  Created by 김시종 on 5/14/24.
//

import UIKit

class ButtonFactory {
    
    func makeButton(normalImageName: String, selectedImageName: String, tintColor: UIColor) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: normalImageName), for: .normal)
        button.setImage(UIImage(systemName: selectedImageName), for: .selected)
        button.tintColor = tintColor
        return button
    }
}
