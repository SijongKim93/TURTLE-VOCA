//
//  CalenderViewController.swift
//  Vocabulary
//
//  Created by 김시종 on 5/13/24.
//

import UIKit
import SnapKit

class CalenderViewController: UIViewController {
    
    var selectedDate: DateComponents? = nil
    
    let dateView: UICalendarView = {
       var view = UICalendarView()
        view.wantsDateDecorations = true
        return view
    }()
    
    let viewLine: UIView = {
        var view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()

    let dayTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = .white
    }
    
    func setupUI() {
        view.addSubview(dateView)
        view.addSubview(viewLine)
        view.addSubview(dayTableView)
        
        dayTableView.delegate = self
        dayTableView.dataSource = self
        dayTableView.register(CalenderTableViewCell.self, forCellReuseIdentifier: CalenderTableViewCell.identifier)
        
        dateView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        viewLine.snp.makeConstraints {
            $0.top.equalTo(dateView.snp.bottom).offset(50)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(1)
        }
        
        dayTableView.snp.makeConstraints {
            $0.top.equalTo(viewLine.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}


extension CalenderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CalenderTableViewCell.identifier, for: indexPath) as? CalenderTableViewCell else { fatalError("테이블 뷰 에러") }
        
        
        return cell
    }
    
    
}
