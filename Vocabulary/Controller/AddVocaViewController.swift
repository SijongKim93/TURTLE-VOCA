//
//  ViewController.swift
//  Vocabulary
//
//  Created by 김시종 on 5/13/24.
//

import UIKit
import SnapKit
import CoreData

class AddVocaViewController: UIViewController {
   
    var bookCaseLabel = LabelFactory().makeLabel(title: "선택한 단어장 이름", size: 20, textAlignment: .center, isBold: true)
    var addVocaButton = UIButton()
    var searchBar = UISearchBar()
    var countLabel = LabelFactory().makeLabel(title: "", size: 15, textAlignment: .left, isBold: false)
    var tableView = UITableView()
    var wordList: [WordEntity] = []

    
    
    
    // 단어 추가 버튼 눌렸을 때 단어입력페이지로 이동

    @objc func presentInsertVocaPage() {
        let scrollView = UIScrollView()
        let insertVocaView = InsertVocaViewController(scrollView: scrollView)
        insertVocaView.modalPresentationStyle = .fullScreen
        self.present(insertVocaView, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        if let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            print("Documents Directory: \(documentsDirectoryURL)")
        }
        
        addVocaButton.tintColor = .black
        addVocaButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        addVocaButton.addTarget(self, action: #selector(presentInsertVocaPage), for: .touchUpInside)

        countLabel.text = "총 \(wordList.count)단어"
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(VocaTableViewCell.self, forCellReuseIdentifier: VocaTableViewCell.identifier)
        self.tableView.rowHeight = 60
        
        self.configureUI()
        self.makeConstraints()
        self.searchBar.delegate = self
        
        getData()
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    func getData() {
        wordList = CoreDataManager.shared.getWordList()
        
        self.tableView.reloadData()
    }
    
    
    func configureUI() {
        self.view.addSubview(bookCaseLabel)
        self.view.addSubview(addVocaButton)
        self.view.addSubview(searchBar)
        self.view.addSubview(countLabel)
        self.view.addSubview(tableView)

    }
    
    
    func makeConstraints() {
        
        bookCaseLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        addVocaButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(addVocaButton.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        countLabel.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(10)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(countLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension AddVocaViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        searchResults = vocaList.filter
    
    }
}

extension AddVocaViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VocaTableViewCell.identifier, for: indexPath) as? VocaTableViewCell else { fatalError("테이블 뷰 에러") }
        let item = wordList[indexPath.row]
        
        cell.wordLabel.text = item.word
        cell.pronunciationLabel.text = item.pronunciation
        cell.definitionLabel.text = item.definition
        
        cell.selectionStyle = .default
        
        cell.buttonAction = { [weak cell] in
            cell?.toggleButtonSelection()
        }
        
        return cell
    }
}

extension AddVocaViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = VocaDetailViewController()
        
        let item =  wordList[indexPath.row]
        
        detailVC.word.text = item.word
        detailVC.pronunciation.text = item.pronunciation
        detailVC.definition.text = item.definition
        detailVC.detail.text = item.detail
        detailVC.synonym.text = item.synonym
        detailVC.antonym.text = item.antonym
        
        detailVC.modalPresentationStyle = .automatic
        
        self.present(detailVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            let wordToDelete = self.wordList[indexPath.row]
            
            self.wordList.remove(at: indexPath.row)
            
            CoreDataManager.shared.deleteWord(word: wordToDelete)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
        
    }
}
