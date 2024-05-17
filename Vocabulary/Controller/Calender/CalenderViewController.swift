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
        view.tintColor = UIColor(red: 48/255, green: 140/255, blue: 74/255, alpha: 1.0)
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchWordListAndUpdateCollectionView()
        dayCollectionView.reloadData()
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
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(320)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(dateView.snp.bottom).offset(30)
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
                        $0.constant = 320
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
        filterModalVC.modalPresentationStyle = .custom
        filterModalVC.transitioningDelegate = self
        present(filterModalVC, animated: true, completion: nil)
    }
    
    @objc func menuButtonTapped() {
        let menuModelVC = MenuDetailModalViewController()
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
        layout.itemSize = CGSize(width: view.frame.size.width - 20, height: 120)
        return layout
    }
    
    func fetchWordListAndUpdateCollectionView() {
        filteredWords = coreDataManager.getWordListFromCoreData()
        dayCollectionView.reloadData()
    }
}

extension CalenderViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredWords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalenderCollectionViewCell.identifier, for: indexPath) as? CalenderCollectionViewCell else { fatalError("컬렉션 뷰 오류") }
        
        let word = filteredWords[indexPath.row]
        cell.englishLabel.text = word.word
        cell.meaningLabel.text = word.definition
        
        return cell
    }
}

extension CalenderViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        selection.setSelected(dateComponents, animated: true)
        selectedDate = dateComponents
        
        if let selectedDate = selectedDate {
            let date = Calendar.current.date(from: selectedDate)!
        }
        
        dayCollectionView.reloadData()
    }
    
    func calendarView(_ calendarView: UICalendarView, didSelect dateComponents: DateComponents?) {
        selectedDate = dateComponents
        dayCollectionView.reloadData()
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
