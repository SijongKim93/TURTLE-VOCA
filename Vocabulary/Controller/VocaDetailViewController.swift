//
//  VocaDetailViewController.swift
//  Vocabulary
//
//  Created by t2023-m0049 on 5/17/24.
//

import Foundation
import UIKit
import SnapKit
import CoreData

class VocaDetailViewController: UIViewController {
    
    var word = UILabel()
    var definition = UILabel()
    var pronunciation = UILabel()
    var detail = UILabel()
    var synonym = UILabel()
    var antonym = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        self.configureUI()
        self.makeConstraints()
    }
    
    
    func configureUI() {
        self.view.addSubview(word)
        self.view.addSubview(definition)
        self.view.addSubview(pronunciation)
        self.view.addSubview(detail)
        self.view.addSubview(synonym)
        self.view.addSubview(antonym)
    }
    
    func makeConstraints() {
        
        word.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.horizontalEdges.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
        }
        
        definition.snp.makeConstraints {
            $0.top.equalTo(word.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
        }
        
        pronunciation.snp.makeConstraints {
            $0.top.equalTo(definition.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
        }
        
        detail.snp.makeConstraints {
            $0.top.equalTo(pronunciation.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
        }
        
        synonym.snp.makeConstraints {
            $0.top.equalTo(detail.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
        }
        
        antonym.snp.makeConstraints {
            $0.top.equalTo(synonym.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
        }
    }
    
    
}
