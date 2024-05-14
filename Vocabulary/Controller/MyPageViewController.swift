//
//  MyPageViewController.swift
//  Vocabulary
//
//  Created by 김시종 on 5/13/24.
//

import UIKit
import SnapKit

class MyPageViewController: UIViewController {
    
    let profileImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = image.frame.size.width / 2
        image.clipsToBounds = true
        return image
    }()
    
    let mailLabel = LabelFactory().makeLabel(title: "이메일", size: 20, textAlignment: .left, isBold: false)
    let subLabel = LabelFactory().makeLabel(title: "닉네임", size: 17, textAlignment: .left, isBold: false)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    func setupUI() {
        view.addSubview(profileImage)
        view.addSubview(mailLabel)
        view.addSubview(subLabel)
    }
    
}
