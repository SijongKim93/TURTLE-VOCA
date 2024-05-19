//
//  RecordBodyView.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/18/24.
//

import UIKit
import SnapKit

class RecordBodyView: UIView {
    
    lazy var segControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Quiz", "HangMan"])
        control.selectedSegmentIndex = 0
        return control
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .blue
        table.register(RecordTableViewCell.self, forCellReuseIdentifier: Constants.recordCell)
        table.rowHeight = 60
        return table
    }()
    
    lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            segControl,
            tableView
        ])
        stackView.axis = .vertical
        stackView.spacing = 30
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout () {
        self.addSubview(vStackView)
        
        vStackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
            $0.bottom.trailing.equalToSuperview().offset(-20)
        }
        
        
    }
}
