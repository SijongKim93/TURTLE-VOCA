//
//  MenuDetailPresentationController.swift
//  Vocabulary
//
//  Created by 김시종 on 5/16/24.
//

import UIKit


//MARK: - 메뉴 탭 커스텀 뷰
class MenuPresentationController: UIPresentationController {
    
    private let dimmingView = UIView()
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return CGRect.zero }
        
        let presentedHeight = containerView.bounds.height * 0.3
        let presentedY = containerView.bounds.height - presentedHeight
        return CGRect(x: 0, y: presentedY, width: containerView.bounds.width, height: presentedHeight)
    }
    
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView, let presentedView = presentedView else { return }
        
        dimmingView.frame = containerView.bounds
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        dimmingView.alpha = 0
        containerView.insertSubview(dimmingView, at: 0)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped))
        dimmingView.addGestureRecognizer(tapGesture)
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1
        }, completion: nil)
        
        presentedView.frame = frameOfPresentedViewInContainerView
        containerView.addSubview(presentedView)
    }
    
    @objc func dimmingViewTapped() {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0
        }, completion: nil)
    }
    
    override func containerViewDidLayoutSubviews() {
        dimmingView.frame = containerView?.bounds ?? CGRect.zero
    }
    
    func shouldRemovePresentersView() -> Bool {
        return false
    }
}
