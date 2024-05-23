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
    
    var bookCaseName: String?
    var bookCaseData: BookCase?
    
    var bookCaseLabel = LabelFactory().makeLabel(title: "" , size: 20, textAlignment: .center, isBold: true)
    var backButton = UIButton()
    var addVocaButton = UIButton()
    var searchBar = UISearchBar()
    var countLabel = LabelFactory().makeLabel(title: "", size: 15, textAlignment: .left, isBold: false)
    var wordList: [WordEntity] = []
    var filteredWordList: [WordEntity] = []
    var isFiltering: Bool = false
    var vocaCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    //단어장 페이지로 돌아가기
    @objc func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 단어 추가 버튼 눌렸을 때 단어입력페이지로 이동
    
    @objc func presentInsertVocaPage() {
        let scrollView = UIScrollView()
        let insertVocaView = InsertVocaViewController(scrollView: scrollView)
        insertVocaView.bookCaseData = self.bookCaseData
        insertVocaView.selectedBookCaseName = self.bookCaseName // 단어장 데이터 전달
        insertVocaView.modalPresentationStyle = .fullScreen
        self.present(insertVocaView, animated: true, completion: nil)
    }

   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
              
        backButton.tintColor = .black
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        self.searchBar.delegate = self
        filteredWordList = wordList
        
        addVocaButton.tintColor = .black
        addVocaButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        addVocaButton.addTarget(self, action: #selector(presentInsertVocaPage), for: .touchUpInside)

       
        setupBookCaseLabel()
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
        guard let bookCaseName = bookCaseName else {
            wordList = []
            filteredWordList = wordList
            vocaCollectionView.reloadData()
            updateCountLabel()
            return
        }
        
        wordList = CoreDataManager.shared.getSpecificData(query: bookCaseName) {error in 
          let alert = AlertController().makeNormalAlert(title: "오류", message: "단어장을 가져오지 못했습니다. 다시 시도해주세요.")
            self.present(alert, animated: true, completion: nil)
            print("Failed to fetch words: \(error)")
        }
        filteredWordList = wordList
        vocaCollectionView.reloadData()
        updateCountLabel()
    }
    
    func setupBookCaseLabel() {
        bookCaseLabel.text = bookCaseName
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
    
    func configureCollectionView() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        vocaCollectionView.addGestureRecognizer(swipeGesture)
    }
   
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        guard gesture.state == .ended else {
            return
        }
        
        let point = gesture.location(in: vocaCollectionView)
        if let indexPath = vocaCollectionView.indexPathForItem(at: point) {
            let wordToDelete = isFiltering ? filteredWordList[indexPath.row] : wordList[indexPath.row]
            
            if isFiltering {
                filteredWordList.remove(at: indexPath.row)
            }
                wordList.remove(at: indexPath.row)
            
            CoreDataManager.shared.deleteWord(word: wordToDelete) { [weak self] error in
                guard let self = self else { return }
                let alert = AlertController().makeNormalAlert(title: "삭제 불가", message: "단어가 삭제되지 않았습니다. 다시 시도해주세요.")
                self.present(alert, animated: true)
            }
            
            vocaCollectionView.deleteItems(at: [indexPath])
            updateCountLabel()
        }
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
        vocaCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredWordList = wordList
        vocaCollectionView.reloadData()
        searchBar.resignFirstResponder()
    }
}


extension AddVocaViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isFiltering ? filteredWordList.count : wordList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VocaCollectionViewCell.identifier, for: indexPath) as? VocaCollectionViewCell else { fatalError("컬렉션 뷰 오류")}
        

        let item = isFiltering ? filteredWordList[indexPath.row] : wordList[indexPath.row]
        
        cell.configure(with: item)
        
        cell.deleteAction = { [weak self] in
            guard let self = self else { return }
            if self.isFiltering {
                self.filteredWordList.remove(at: indexPath.row)
            } else {
                self.wordList.remove(at: indexPath.row)
            }
            CoreDataManager.shared.deleteWord(word: item, errorHandler: { _ in
                let alert = AlertController().makeNormalAlert(title: "삭제 실패", message: "단어가 삭제되지 않았습니다. 다시 시도해주세요.")
                self.present(alert, animated: true, completion: nil)
            })
            collectionView.deleteItems(at: [indexPath])
            self.updateCountLabel()
        }
        
        cell.memorizeAction = { [weak self] isSelected in
            guard self != nil else { return }
            item.memory = isSelected
            CoreDataManager.shared.updateWordMemoryStatus(word: item, memory: isSelected)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           let detailVC = VocaDetailViewController()
           let item = isFiltering ? filteredWordList[indexPath.row] : wordList[indexPath.row]
        
        detailVC.selectedBookCaseName = item.bookCaseName
        detailVC.bookCaseData = item
        detailVC.modalPresentationStyle = .fullScreen
           
        self.present(detailVC, animated: true, completion: nil)
       }
}

