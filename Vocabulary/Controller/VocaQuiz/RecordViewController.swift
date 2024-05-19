//
//  RecordViewController.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/17/24.
//

import UIKit
import SnapKit

class RecordViewController: UIViewController {
    
    lazy var recordHeaderView = RecordHeaderView()
    lazy var recordBodyView = RecordBodyView()
    
    lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            UIView(),
            recordHeaderView,
            recordBodyView,
            UIView()
        ])
        stackView.axis = .vertical
        stackView.spacing = 30
        return stackView
    }()
    
    //var tableDiffableDatasoure: UITableViewDiffableDataSource<DiffableSection, >?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        layout()
        addSegAction()
    }
    
    func addSegAction () {
        recordBodyView.segControl.addAction(UIAction(handler: { [unowned self] _ in
            let index = recordBodyView.segControl.selectedSegmentIndex
            print (index)
        }), for: .valueChanged)
    }
    
    private func layout () {
        view.addSubview(vStackView)
        
        vStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        recordHeaderView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        recordBodyView.snp.makeConstraints {
            $0.top.equalTo(recordHeaderView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-100)
        }
        
    }
}
