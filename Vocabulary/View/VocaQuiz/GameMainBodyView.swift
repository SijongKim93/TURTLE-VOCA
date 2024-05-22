//
//  GameMainBodyView.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/20/24.
//

import UIKit
import SnapKit

class GameMainBodyView: UIView {
    
    lazy var frameView: UIView = {
        let view = UIView()
        view.addSubview(turtleImageView)
        return view
    }()
    
    lazy var turtleImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "logoresize")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout () {
        addSubview(frameView)
        
        frameView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
            $0.bottom.trailing.equalToSuperview().inset(20)
        }

        
        turtleImageView.snp.makeConstraints {
            $0.edges.equalTo(frameView.snp.edges)
        }
    }
    
}
