//
//  TextFieldFactory.swift
//  Vocabulary
//
//  Created by t2023-m0049 on 5/16/24.
//

import Foundation
import UIKit

class TextFieldFactory {
    
    func makeTextField(placeholder: String) -> UITextField {
        
        let textField = UITextField()
        
        textField.placeholder = placeholder
        textField.backgroundColor = .lightGray
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.autocapitalizationType = .none
        textField.clearButtonMode = .always
        textField.clearsOnBeginEditing = false
        textField.returnKeyType = .done
        
        return textField
    }
}
