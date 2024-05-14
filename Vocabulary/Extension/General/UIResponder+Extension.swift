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
