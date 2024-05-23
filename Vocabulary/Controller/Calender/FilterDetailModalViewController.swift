//
//  CalenderDetailModelViewController.swift
//  Vocabulary
//
//  Created by 김시종 on 5/14/24.
//

import UIKit
import SnapKit

class FilterDetailModalViewController: UIViewController {
    
    weak var delegate: FilterDetailModalDelegate?
    
    //MARK: - Component 생성
    let labels = ["최근 저장 순", "오래된 저장 순", "외운 단어 순", "못 외운 단어 순", "랜덤"]
    var selectedButtonIndex: Int?
    
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
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        tableView.delegate = self
        tableView.dataSource = self
        xButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        
        loadFilterSettings()
    }
    
    //MARK: - ViewDidDisappear
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.didDismissFilterDetailModal()
    }
    
    //MARK: - 화면 전환 시 필터 값을 통한 데이터 정렬 델리게이트
    @objc func dismissViewController() {
        self.dismiss(animated: true) { [weak self] in
            self?.delegate?.didDismissFilterDetailModal()
        }
    }
    
    //MARK: - setup
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
            $0.width.equalTo(30)
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
    
    //MARK: - 원하는 필터 정렬 값 UserDefaults 저장
    func saveFilterSettings() {
        guard let selectedButtonIndex = selectedButtonIndex else { return }
        UserDefaults.standard.set(selectedButtonIndex, forKey: "SelectedFilterIndex")
        UserDefaults.standard.synchronize()
        print("Saved selected filter index: \(selectedButtonIndex)")
    }
    
    //MARK: - 필터 정렬 값 UserDefaults 저장
    func loadFilterSettings() {
        let savedIndex = UserDefaults.standard.integer(forKey: "SelectedFilterIndex")
        if savedIndex < labels.count {
            selectedButtonIndex = savedIndex
        } else {
            selectedButtonIndex = 0
        }
        print("Loaded selected filter index: \(savedIndex)")
        tableView.reloadData()
    }
    
}

//MARK: - TableView Delegate , dataSource 세팅
extension FilterDetailModalViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        labels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.identifier, for: indexPath) as? FilterTableViewCell else { fatalError("테이블 뷰 에러") }
        
        cell.label.text = labels[indexPath.row]
        cell.selectionStyle = .none
        
        cell.button.isSelected = (indexPath.row == selectedButtonIndex)
        
        cell.buttonAction = { [weak self] in
            guard let self = self else { return }
            self.updateSelectedButton(at: indexPath.row)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView.cellForRow(at: indexPath) is FilterTableViewCell else { fatalError("테이블 뷰 셀 선택 에러") }
        updateSelectedButton(at: indexPath.row)
        
    }
    
    //MARK: - 필터 값은 하나만 저장되어야 하므로 이전 값 삭제 새로운 값 저장 메서드
    func updateSelectedButton(at index: Int) {
        if let selectedButtonIndex = selectedButtonIndex {
            let previousIndexPath = IndexPath(row: selectedButtonIndex, section: 0)
            if let previousCell = tableView.cellForRow(at: previousIndexPath) as? FilterTableViewCell {
                previousCell.button.isSelected = false
            }
        }
        
        selectedButtonIndex = index
        let currentIndexPath = IndexPath(row: index, section: 0)
        if let currentCell = tableView.cellForRow(at: currentIndexPath) as? FilterTableViewCell {
            currentCell.button.isSelected = true
        }
        saveFilterSettings()
    }
}
