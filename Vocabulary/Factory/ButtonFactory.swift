//
//  ButtonFactory.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/16/24.
//

import UIKit

class ButtonFactory {
    
    func makeButton(title: String, color: UIColor = .black, backgroundColor: UIColor = .lightGray, completion: @escaping (UIButton) -> Void) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.borderWidth = 0.3
        button.contentMode = .center
        button.imageView?.tintColor = .black
        button.addAction(UIAction { action in
            guard let button = action.sender as? UIButton else { return }
            completion(button)
        }, for: .touchUpInside)
        return button
    }

}
