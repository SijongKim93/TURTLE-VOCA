//
//  HangMangBodyView.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/16/24.
//

import UIKit
import SnapKit

class HangManBodyView: UIView {
    
    lazy var frameView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.layer.borderColor = ThemeColor.mainCgColor
        view.addSubview(wordFrameView)
        view.addSubview(hangManImageView)
        return view
    }()
    
    lazy var hangManImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "hanger")
        
        return view
    }()
    
    lazy var wordFrameView: UIView = {
        let view = UIView()
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
        
        wordFrameView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(30)
        }
        
        hangManImageView.snp.makeConstraints {
            $0.top.equalTo(wordFrameView.snp.bottom).offset(20)
            $0.bottom.equalToSuperview().offset(-10)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
    }
    
}
