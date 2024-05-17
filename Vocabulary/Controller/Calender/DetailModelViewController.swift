//
//  CalenderDetailModelViewController.swift
//  Vocabulary
//
//  Created by 김시종 on 5/14/24.
//

import UIKit
import SnapKit

class DetailModelViewController: UIViewController {
    
    let labels = ["최근 저장 순", "나중 저장 순", "외운 단어 순", "못 외운 단어 순", "랜덤"]
    var selectedButton: UIButton?
    
    let filterMainLabel = LabelFactory().makeLabel(title: "단어 정렬 설정", size: 23, textAlignment: .left, isBold: true)
    
    let xButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    lazy var topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.addArrangedSubview(filterMainLabel)
        stackView.addArrangedSubview(xButton)
        return stackView
    }()
    
    let viewLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: FilterTableViewCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        tableView.delegate = self
        tableView.dataSource = self
        xButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
    }
    
    @objc func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupUI() {
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        
        view.addSubview(topStackView)
        view.addSubview(viewLine)
        view.addSubview(tableView)
        
        topStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        xButton.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.height.equalTo(30)
        }
        
        viewLine.snp.makeConstraints {
            $0.top.equalTo(topStackView.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(viewLine.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview().inset(10)
        }
    }
}

extension DetailModelViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        labels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.identifier, for: indexPath) as? FilterTableViewCell else { fatalError("테이블 뷰 에러") }
        
        cell.label.text = labels[indexPath.row]
        cell.selectionStyle = .none
        
        cell.buttonAction = { [weak cell] in
            cell?.toggleButtonSelection()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FilterTableViewCell else { fatalError("테이블 뷰 셀 선택 에러") }
        
        if let selectedButton = selectedButton {
            selectedButton.isSelected = false
        }
        
        selectedButton = cell.button
        
        cell.toggleButtonSelection()
    }
}
