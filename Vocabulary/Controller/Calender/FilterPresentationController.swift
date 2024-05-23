//
//  CalenderPresentationController.swift
//  Vocabulary
//
//  Created by 김시종 on 5/14/24.
//

import UIKit


//MARK: - 커스텀 뷰 세팅
class FilterPresentationController: UIPresentationController {
    
    private let dimmingView = UIView()
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return CGRect.zero }
        return CGRect(x: 0, y: containerView.bounds.height / 2, width: containerView.bounds.width, height: containerView.bounds.height / 2)
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView, let presentedView = presentedView else { return }
        
        dimmingView.frame = containerView.bounds
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
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
        presentingViewController.dismiss(animated: true) { [weak self] in
            if let calenderVC = self?.presentingViewController as? CalenderViewController {
                calenderVC.didDismissFilterDetailModal()
            }
        }
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
