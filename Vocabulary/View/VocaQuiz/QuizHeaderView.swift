//
//  HeaderView.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/13/24.
//

import UIKit

class QuizHeaderView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        self.backgroundColor = .blue
    }
    
}
