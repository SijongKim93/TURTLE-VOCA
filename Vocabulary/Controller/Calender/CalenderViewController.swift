//
//  CalenderViewController.swift
//  Vocabulary
//
//  Created by 김시종 on 5/13/24.
//

import UIKit
import SnapKit
import CoreData

class CalenderViewController: UIViewController {
    
    var selectedDate: DateComponents? = nil
    var filteredWords: [WordEntity] = []
    let coreDataManager = CoreDataManager.shared
    
    let dateView: UICalendarView = {
        var view = UICalendarView()
        view.calendar = .current
        view.locale = .current
        view.tintColor = ThemeColor.mainColor
        view.fontDesign = .rounded
        return view
    }()
    
    let viewLine: UIView = {
        var view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    let upButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    let filterButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "filter"), for: .normal)
        return button
    }()
    
    let menuButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "menu"), for: .normal)
        return button
    }()
    
    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        stackView.addArrangedSubview(upButton)
        stackView.addArrangedSubview(filterButton)
        stackView.addArrangedSubview(menuButton)
        
        return stackView
    }()
    
    let dayCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        buttonAction()
        
        view.backgroundColor = .white
        
        let currentDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        selectedDate = currentDateComponents
        let selectionBehavior = UICalendarSelectionSingleDate(delegate: self)
        selectionBehavior.selectedDate = currentDateComponents
        dateView.selectionBehavior = selectionBehavior
        
        fetchWordListAndUpdateCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectedDate == nil {
            let currentDate = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            selectedDate = currentDate
        }
        
        fetchWordListAndUpdateCollectionView()
        didDismissFilterDetailModal()
    }
    
    func setupUI() {
        view.addSubview(dateView)
        view.addSubview(buttonStackView)
        view.addSubview(viewLine)
        view.addSubview(dayCollectionView)
        
        dateView.delegate = self
        dateView.selectionBehavior = UICalendarSelectionSingleDate(delegate: self)
        
        dayCollectionView.delegate = self
        dayCollectionView.dataSource = self
        dayCollectionView.collectionViewLayout = createCollectionViewFlowLayout(for: dayCollectionView)
        dayCollectionView.register(CalenderCollectionViewCell.self, forCellWithReuseIdentifier: CalenderCollectionViewCell.identifier)
        
        dateView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(435) // 높이 고정
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(dateView.snp.bottom).offset(5)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        viewLine.snp.makeConstraints {
            $0.top.equalTo(buttonStackView.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(1)
        }
        
        dayCollectionView.snp.makeConstraints {
            $0.top.equalTo(viewLine.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func buttonAction() {
        upButton.addTarget(self, action: #selector(upButtonTapped), for: .touchUpInside)
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
    }
    
    @objc func upButtonTapped() {
        UIView.animate(withDuration: 0.3) {
            if self.upButton.isSelected {
                self.dateView.constraints.forEach {
                    if $0.firstAttribute == .height {
                        $0.constant = 435
                    }
                }
                self.upButton.setImage(UIImage(systemName: "arrow.up"), for: .normal)
            } else {
                self.dateView.constraints.forEach {
                    if $0.firstAttribute == .height {
                        $0.constant = 0
                    }
                }
                self.upButton.setImage(UIImage(systemName: "arrow.down"), for: .normal)
            }
            self.view.layoutIfNeeded()
            self.upButton.isSelected.toggle()
        }
    }
    
    @objc func filterButtonTapped() {
        let filterModalVC = FilterDetailModalViewController()
        filterModalVC.delegate = self
        filterModalVC.modalPresentationStyle = .custom
        filterModalVC.transitioningDelegate = self
        present(filterModalVC, animated: true, completion: nil)
    }
    
    @objc func menuButtonTapped() {
        let menuModelVC = MenuDetailModalViewController()
        menuModelVC.delegate = self
        menuModelVC.modalPresentationStyle = .custom
        menuModelVC.transitioningDelegate = self
        present(menuModelVC, animated: true, completion: nil)
    }
    
    func createCollectionViewFlowLayout(for collectionView: UICollectionView) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: view.frame.size.width - 20, height: 100)
        return layout
    }
    
    func fetchWordListAndUpdateCollectionView() {
        let currentDate = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let dateToFetch = selectedDate?.date ?? Calendar.current.date(from: currentDate)!
        
        filteredWords = coreDataManager.getWordListFromCoreData(for: dateToFetch)
        
        let filterIndex = fetchFilterIndex()
        
        filteredWords = sortWords(filteredWords, by: filterIndex)
        
        dayCollectionView.reloadData()
    }
    
    func filterWords(for date: Date, words: [WordEntity]) -> [WordEntity] {
        let calendar = Calendar.current
        return words.filter { word in
            if let wordDate = word.date {
                return calendar.isDate(wordDate, inSameDayAs: date)
            }
            return false
        }
    }
    
    func fetchFilterIndex() -> Int {
        if UserDefaults.standard.object(forKey: "SelectedFilterIndex") == nil {
            UserDefaults.standard.set(0, forKey: "SelectedFilterIndex")
            UserDefaults.standard.synchronize()
        }
        return UserDefaults.standard.integer(forKey: "SelectedFilterIndex")
    }
    
    func sortWords(_ words: [WordEntity], by filterIndex: Int) -> [WordEntity] {
        switch filterIndex {
        case 0:
            return words.sorted { (word1: WordEntity, word2: WordEntity) -> Bool in
                return word1.date ?? Date() > word2.date ?? Date()
            }
        case 1:
            return words.sorted { (word1: WordEntity, word2: WordEntity) -> Bool in
                return word1.date ?? Date() < word2.date ?? Date()
            }
        case 2:
            return words.sorted { (word1: WordEntity, word2: WordEntity) -> Bool in
                return word1.memory && !word2.memory
            }
        case 3:
            return words.sorted { (word1: WordEntity, word2: WordEntity) -> Bool in
                return !word1.memory && word2.memory
            }
        case 4:
            return words.shuffled()
        default:
            return words
        }
    }
}

extension CalenderViewController: MenuDetailModalDelegate {
    func markWordsAsLearned() {
        let date: Date
        if let selectedDate = selectedDate {
            date = Calendar.current.date(from: selectedDate)!
        } else {
            date = Date()
        }
        
        let wordsForDate = coreDataManager.getWordListFromCoreData(for: date)
        
        for word in wordsForDate {
            coreDataManager.updateWordMemoryStatus(word: word, memory: true)
        }
        
        fetchWordListAndUpdateCollectionView()
    }
    
    func deleteAllWords() {
        let date: Date
        if let selectedDate = selectedDate {
            date = Calendar.current.date(from: selectedDate)!
        } else {
            date = Date()
        }
        
        let wordsForDate = coreDataManager.getWordListFromCoreData(for: date)
        
        for word in wordsForDate {
            coreDataManager.deleteWord(word)
        }
        fetchWordListAndUpdateCollectionView()
    }
}

extension CalenderViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredWords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalenderCollectionViewCell.identifier, for: indexPath) as? CalenderCollectionViewCell else { fatalError("컬렉션 뷰 오류") }
        
        let word = filteredWords[indexPath.row]
        cell.configure(with: word)
        cell.learnedButton.tag = indexPath.row
        cell.learnedButton.addTarget(self, action: #selector(learnedButtonTapped(_:)), for: .touchUpInside)
        cell.learnedButton.isSelected = word.memory
        
        return cell
    }
    
    @objc func learnedButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        let word = filteredWords[index]
        let newLearnStatus = !word.memory
        coreDataManager.updateWordMemoryStatus(word: word, memory: newLearnStatus)
        
        sender.isSelected = newLearnStatus
    }
    
}

extension CalenderViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        selectedDate = dateComponents
        
        if let date = dateComponents?.date {
            filteredWords = coreDataManager.getWordListFromCoreData(for: date)
            let filterIndex = fetchFilterIndex()
            filteredWords = sortWords(filteredWords, by: filterIndex)
            dayCollectionView.reloadData()
        }
    }
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        if let date = Calendar.current.date(from: dateComponents), coreDataManager.hasData(for: date) {
            let emojiLabel = UILabel()
            emojiLabel.text = "🐢"
            emojiLabel.textAlignment = .center
            
            let containerView = UIView()
            containerView.addSubview(emojiLabel)
            emojiLabel.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.centerY.equalToSuperview()
            }
            
            return .customView { containerView }
        }
        return nil
    }
    
    func calendarView(_ calendarView: UICalendarView, didSelect dateComponents: DateComponents?) {
        selectedDate = dateComponents
        fetchWordListAndUpdateCollectionView()
    }
}

extension CalenderViewController: FilterDetailModalDelegate {
    func didDismissFilterDetailModal() {
        fetchWordListAndUpdateCollectionView()
    }
}


extension CalenderViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        if let filterModalViewController = presented as? FilterDetailModalViewController {
            return FilterPresentationController(presentedViewController: filterModalViewController, presenting: presenting)
        } else if let menuModalViewController = presented as? MenuDetailModalViewController {
            return MenuPresentationController(presentedViewController: menuModalViewController, presenting: presenting)
        } else {
            return nil
        }
    }
}

protocol FilterDetailModalDelegate: AnyObject {
    func didDismissFilterDetailModal()
}

