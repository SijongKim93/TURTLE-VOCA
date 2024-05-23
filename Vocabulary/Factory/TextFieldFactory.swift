//
//  TextFieldFactory.swift
//  Vocabulary
//
//  Created by t2023-m0049 on 5/16/24.
//

import Foundation
import UIKit

class TextFieldFactory {
    
    func makeTextField(placeholder: String, action: Selector, dictAction: Selector) -> UITextField {
        
        let textField = UITextField()
        
        textField.placeholder = placeholder
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.autocapitalizationType = .none
        textField.clearButtonMode = .always
        textField.clearsOnBeginEditing = false
        textField.returnKeyType = .done
        
        //테두리 색상 추가
        textField.layer.borderColor = ThemeColor.mainCgColor
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 8
        
        // 텍스트 필드 높이 설정
        let heightConstraint = NSLayoutConstraint(item: textField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 46)
        textField.addConstraint(heightConstraint)
        
        // Placeholder 왼쪽에 여백 추가
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        // Toolbar 추가
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIView().frame.size.width, height: 36))
        toolBar.barStyle = .default
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: action) // 매개변수를 직접 사용
        
        
        let dictButton = UIBarButtonItem(
            image: UIImage(systemName: "character.book.closed"),
            style: .plain,
            target: self,
            action: dictAction)
 
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            dictButton,doneButton
        ]
        
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
        return textField
    }
    
}
