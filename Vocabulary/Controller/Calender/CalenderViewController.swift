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
        view.calendar = .current
        view.locale = .current
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
    
    func setupUI() {
        view.addSubview(dateView)
        view.addSubview(buttonStackView)
        view.addSubview(viewLine)
        view.addSubview(dayCollectionView)
        
        
        dayCollectionView.delegate = self
        dayCollectionView.dataSource = self
        dayCollectionView.collectionViewLayout = createCollectionViewFlowLayout(for: dayCollectionView)
        dayCollectionView.register(CalenderCollectionViewCell.self, forCellWithReuseIdentifier: CalenderCollectionViewCell.identifier)
        
        dateView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(330)
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
    }
    
    @objc func upButtonTapped() {
        UIView.animate(withDuration: 0.3) {
            if self.upButton.isSelected {
                self.dateView.constraints.forEach {
                    if $0.firstAttribute == .height {
                        $0.constant = 330
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
        let filterModalVC = CalenderDetailModelViewController()
        filterModalVC.modalPresentationStyle = .custom
        filterModalVC.transitioningDelegate = self
        present(filterModalVC, animated: true, completion: nil)
    }
    
    func createCollectionViewFlowLayout(for collectionView: UICollectionView) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: 330, height: 120)
        return layout
    }
}


extension CalenderViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalenderCollectionViewCell.identifier, for: indexPath) as? CalenderCollectionViewCell else { fatalError("컬렉션 뷰 오류") }
        
        cell.backgroundColor = .blue
        
        return cell
    }
}

extension CalenderViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
}


