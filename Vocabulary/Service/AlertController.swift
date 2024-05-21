//
//  AlertController.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/15/24.
//

import UIKit

class AlertController {
    
    func makeAlertWithCompletion(title: String, message: String, completion: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        applyDesign(to: alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: completion))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        return alert
    }
  
    func makeNormalAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        applyDesign(to: alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        return alert
    }

    private func applyDesign(to alertController: UIAlertController) {
        if let subview = alertController.view.subviews.first, let alertContentView = subview.subviews.first {
            alertContentView.layer.cornerRadius = 10
            alertContentView.layer.borderWidth = 2
            alertContentView.layer.borderColor = ThemeColor.mainCgColor
            
            alertController.view.tintColor = UIColor.black
        }
    }
}
