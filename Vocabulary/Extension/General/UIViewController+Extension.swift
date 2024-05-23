//
//  UIViewController+Extension.swift
//  Vocabulary
//
//  Created by Luz on 5/23/24.
//

import Foundation
import UIKit

//MARK: - setupKeyboardEvent 함수 : 텍스트 필드 입력 시 키보드가 가리지 않게

extension UIViewController {

    func setupKeyboardEvent() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        let activeField = UIResponder.findFirstResponder() as? UIView
        
        guard let activeField = activeField else { return }
        
        let fieldFrame = activeField.convert(activeField.bounds, to: view)
        let fieldBottom = fieldFrame.origin.y + fieldFrame.size.height
        
        let overlap = fieldBottom - (view.frame.height - keyboardHeight) + 20
        if overlap > 0 {
            UIView.animate(withDuration: animationDuration) {
                self.view.frame.origin.y = -overlap
            }
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        guard let userInfo = sender.userInfo,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        UIView.animate(withDuration: animationDuration) {
            self.view.frame.origin.y = 0
        }
    }
}
