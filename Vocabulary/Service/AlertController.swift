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
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: completion))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        return alert
    }
    
    func makeAlertWithCancelCompletion(title: String, message: String, completion: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: completion))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        return alert
    }
    
    func makeNormalAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        return alert
    }
    
}
