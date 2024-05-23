//
//  UIResponder+Extension.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/14/24.
//

import UIKit

extension UIResponder {
    var currentViewController: UIViewController? {
        return next as? UIViewController ?? next?.currentViewController
    }
}

//포커스 받고 있는 텍스트 필드 찾기
extension UIResponder {
    private static weak var currentResponder: UIResponder?
    
    public static func findFirstResponder() -> UIResponder? {
        UIResponder.currentResponder = nil
        UIApplication.shared.sendAction(#selector(UIResponder._trap), to: nil, from: nil, for: nil)
        return UIResponder.currentResponder
    }
    
    @objc private func _trap() {
        UIResponder.currentResponder = self
    }
}
