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
        table.register(RecordTableViewCell.self, forCellReuseIdentifier: Constants.recordCell)
        table.rowHeight = 60
        table.tableHeaderView = headerView
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
    
    lazy var headerView: UIView = {
        let view = UIView()
        view.addSubview(hStackView)
        return view
    }()
    
    lazy var categoryLabel = LabelFactory().makeLabel(title: "단어장", size: 20, isBold: true)
    lazy var wordLabel = LabelFactory().makeLabel(title: "단어", size: 20, isBold: false)
    lazy var defLabel = LabelFactory().makeLabel(title: "의미", size: 20, isBold: false)
    
    lazy var hStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            categoryLabel,
            wordLabel,
            defLabel
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
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
        
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 40)
        
        hStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
}
