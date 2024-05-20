//
//  ButtonFactory.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/16/24.
//

import UIKit

class ButtonFactory {
    
    func makeButton(title: String, size: CGFloat = 20, color: UIColor = ThemeColor.mainColor, backgroundColor: UIColor = .white, radius: CGFloat  = 7, borderWidth: CGFloat = 1.5 ,completion: @escaping (UIButton) -> Void) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: size)
        button.setTitleColor(color, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = radius
        button.layer.borderWidth = borderWidth
        button.layer.borderColor = ThemeColor.mainCgColor
        button.contentMode = .center
        button.imageView?.tintColor = .black
        button.addAction(UIAction { action in
            guard let button = action.sender as? UIButton else { return }
            completion(button)
        }, for: .touchUpInside)
        return button
    }

}
