//
//  UIViewControllerTransitioningDelegate.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/20/24.
//

import UIKit

extension GameMainPageViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return ManageModalPresentationController(presentedViewController: presented, presenting: presenting)
        }
}
