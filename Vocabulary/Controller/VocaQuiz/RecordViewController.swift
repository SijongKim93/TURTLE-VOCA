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
    
    var dataList = [ReminderModel]()
    
    var tableDiffableDatasoure: UITableViewDiffableDataSource<DiffableSectionModel, ReminderModel>?
    var quizSnapshot: NSDiffableDataSourceSnapshot<DiffableSectionModel, ReminderModel>?
    var hangmanSnapshot: NSDiffableDataSourceSnapshot<DiffableSectionModel, ReminderModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        removeDuplicate()
        layout()
        addSegAction()
        configureDiffableDataSource()
        configureQuizSnapshot()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    func removeDuplicate () {
        dataList = Array(Set(dataList)).sorted(by: { $0.word < $1.word })
    }
    
    func addSegAction () {
        recordBodyView.segControl.addAction(UIAction(handler: { [unowned self] _ in
            let index = recordBodyView.segControl.selectedSegmentIndex
            switch index {
            case 0:
                configureQuizSnapshot()
            case 1:
                configureHangmanSnapshot()
            default:
                return
            }
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

extension RecordViewController {
    func configureDiffableDataSource () {
        tableDiffableDatasoure = UITableViewDiffableDataSource(tableView: recordBodyView.tableView, cellProvider: { tableView, indexPath, model in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.recordCell, for: indexPath) as! RecordTableViewCell
        
            cell.categoryLabel.text = model.category
            cell.wordLabel.text = model.word
            cell.defLabel.text = model.meaning
            
            cell.selectionStyle = .none
            
            return cell
        })
    }
    
    func configureQuizSnapshot() {
        quizSnapshot = NSDiffableDataSourceSnapshot<DiffableSectionModel, ReminderModel>()
        quizSnapshot?.deleteAllItems()
        quizSnapshot?.appendSections([.quiz])
        quizSnapshot?.appendItems(dataList.filter{ $0.index == 0}.map { $0 } )

        tableDiffableDatasoure?.apply(quizSnapshot!,animatingDifferences: true)
    }
    
    func configureHangmanSnapshot() {
        hangmanSnapshot = NSDiffableDataSourceSnapshot<DiffableSectionModel, ReminderModel>()
        hangmanSnapshot?.deleteAllItems()
        hangmanSnapshot?.appendSections([.hangman])
        hangmanSnapshot?.appendItems(dataList.filter{ $0.index == 1}.map { $0 })

        tableDiffableDatasoure?.apply(hangmanSnapshot!,animatingDifferences: true)
    }
}
