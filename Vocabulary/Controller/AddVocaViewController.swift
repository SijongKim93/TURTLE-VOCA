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
    
    var bookCase: BookCase?
   
    var bookCaseLabel = LabelFactory().makeLabel(title: "선택한 단어장 이름", size: 20, textAlignment: .center, isBold: true)
    


    var backButton = UIButton()
    //단어장 페이지로 돌아가기
    @objc func backButtonTapped() {
    self.dismiss(animated: true, completion: nil)
    }
    

    var addVocaButton = UIButton()
    
    var searchBar = UISearchBar()

    var countLabel = LabelFactory().makeLabel(title: "", size: 15, textAlignment: .left, isBold: false)
    var tableView = UITableView()
    var wordList: [WordEntity] = []
    var filteredWordList: [WordEntity] = []
    var isFiltering: Bool = false
    
    var vocaCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    

    // 단어 추가 버튼 눌렸을 때 단어입력페이지로 이동

    @objc func presentInsertVocaPage() {
        let scrollView = UIScrollView()
        let insertVocaView = InsertVocaViewController(scrollView: scrollView)
        insertVocaView.selectedBookCase = self.bookCase // 단어장 데이터 전달
        insertVocaView.modalPresentationStyle = .fullScreen
        self.present(insertVocaView, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        //코어데이터 작동 확인용
        
//        if let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
//            print("Documents Directory: \(documentsDirectoryURL)")
//        }
        
        backButton.tintColor = .black
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        self.searchBar.delegate = self
        filteredWordList = wordList
        searchBar.clipsToBounds
        
        addVocaButton.tintColor = .black
        addVocaButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        addVocaButton.addTarget(self, action: #selector(presentInsertVocaPage), for: .touchUpInside)

        updateCountLabel()
        
        vocaCollectionView.dataSource = self
        vocaCollectionView.delegate = self
        vocaCollectionView.register(VocaCollectionViewCell.self, forCellWithReuseIdentifier: VocaCollectionViewCell.identifier)
        vocaCollectionView.collectionViewLayout = createCollectionViewFlowLayout(for: vocaCollectionView)
        
        self.configureUI()
        self.makeConstraints()
        
        
        getData()
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    func getData() {
        wordList = CoreDataManager.shared.getWordList()
     
        vocaCollectionView.reloadData()

        filteredWordList = wordList
        updateCountLabel()
        self.tableView.reloadData()

    }
    
    func updateCountLabel() {
        countLabel.text = "총 \(wordList.count)단어"
    }
    
    func configureUI() {
        self.view.addSubview(backButton)
        self.view.addSubview(bookCaseLabel)
        self.view.addSubview(addVocaButton)
        self.view.addSubview(searchBar)
        self.view.addSubview(countLabel)
        self.view.addSubview(vocaCollectionView)
    }
    
    func makeConstraints() {

        
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(4)
            $0.leading.equalToSuperview().offset(20)
        }
        

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
        
        vocaCollectionView.snp.makeConstraints {
            $0.top.equalTo(countLabel.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func createCollectionViewFlowLayout(for collectionView: UICollectionView) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: view.frame.size.width - 20, height: 100)
        return layout
    }
}

extension AddVocaViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isFiltering = false
            filteredWordList = wordList
        } else {
            isFiltering = true
            filteredWordList = wordList.filter { wordEntity in
                let wordMatch = wordEntity.word?.localizedCaseInsensitiveContains(searchText) ?? false
                let definitionMatch = wordEntity.definition?.localizedCaseInsensitiveContains(searchText) ?? false
                return wordMatch || definitionMatch
            }
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredWordList = wordList
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
}


extension AddVocaViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wordList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VocaCollectionViewCell.identifier, for: indexPath) as? VocaCollectionViewCell else { fatalError("컬렉션 뷰 오류")}
        
        
        let item = wordList[indexPath.row]
        
        cell.wordLabel.text = item.word
        cell.pronunciationLabel.text = item.pronunciation
        cell.definitionLabel.text = item.definition
        
        return cell
    }
}


