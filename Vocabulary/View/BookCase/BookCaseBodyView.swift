//
//  BookCaseBodyView.swift
//  Vocabulary
//
//  Created by 김한빛 on 5/13/24.
//

import Foundation
import UIKit
import SnapKit
import CoreData

class BookCaseBodyView: UIView {
    
    weak var delegate:BookCaseBodyViewDelegate?
    
    var itemWidth: CGFloat = 0.0
    let minimumLineSpacing: CGFloat = 16
    var previousIndex: Int = 0
    
    let motivations = [
        "“성적이나 결과는 행동이 아니라 습관입니다.” \n – 아리스토텔레스",
        "“끝날 때까지 항상 불가능해 보인다” \n – 넬슨 만델라",
        "“열심히 하면 할수록 행운도 더 많이 옵니다.” \n – 토마스 제퍼슨",
        "“산을 옮기는 사람은 작은 돌부터 옮기기 시작한다.” \n – 공자",
    ]
    
    var bookCaseData: NSManagedObject?
    
    var bookCases: [NSManagedObject] = []
    
    weak var delagateEdit: EditBookCaseBodyCellDelegate?
    
    //컬렉션 뷰
    let vocaBookCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.sectionInset = .init(top: 0, left: 36, bottom: 0, right: 36)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collectionView
    }()
    
    //응원 문구
    let motivationLabel = LabelFactory().makeLabel(title: "", color: .systemGray, size: 16, isBold: false)
    
    //셀이 없을 때
    let backgroundImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "mainturtle"))
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupConstraints()
        configureUI()
        
        // AddVoca로 이동하기 위한 TapGestureRecognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        itemWidth = calculateItemWidth()
        vocaBookCollectionView.reloadData()
    }
    
    private func setupConstraints(){
        [vocaBookCollectionView, motivationLabel, backgroundImage].forEach{
            addSubview($0)
        }
        
        vocaBookCollectionView.snp.makeConstraints{
            $0.top.equalToSuperview().inset(30)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(motivationLabel.snp.top).offset(-20)
        }
        
        motivationLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(30)
        }
        
        backgroundImage.snp.makeConstraints {
            $0.edges.equalTo(vocaBookCollectionView).inset(80)
        }
    }
    
    func configureUI(){
        bookCases = CoreDataManager.shared.fetchBookCase()
        vocaBookCollectionView.reloadData()
        
        vocaBookCollectionView.delegate = self
        vocaBookCollectionView.dataSource = self
        
        let randomIndex = Int.random(in: 0..<motivations.count)
        motivationLabel.text = motivations[randomIndex]
        
        if bookCases.isEmpty {
            backgroundImage.isHidden = false
            motivationLabel.isHidden = true
        } else {
            backgroundImage.isHidden = true
            motivationLabel.isHidden = false
        }
        vocaBookCollectionView.register(BookCaseBodyCell.self, forCellWithReuseIdentifier: BookCaseBodyCell.identifier)
    }
    
    private func calculateItemWidth() -> CGFloat {
        let collectionViewWidth = vocaBookCollectionView.frame.width
        let availableWidth = collectionViewWidth - vocaBookCollectionView.contentInset.left - vocaBookCollectionView.contentInset.right - 80
        return availableWidth
    }
    
    func selectInitialCell() {
        guard bookCases.count > 1 else { return }
        let indexPath = IndexPath(item: 1, section: 0)
        if let cell = vocaBookCollectionView.cellForItem(at: indexPath) {
            animateZoomforCellremove(zoomCell: cell)
        }
    }
    
    //페이징 기능
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellWidthIncludeSpacing = itemWidth + minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludeSpacing
        let roundedIndex: CGFloat = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludeSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
    
    //컬렉션 뷰 애니메이션 ( Carousel Effect )
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let cellWidthIncludeSpacing = itemWidth + minimumLineSpacing
        let offsetX = vocaBookCollectionView.contentOffset.x
        let index = (offsetX + vocaBookCollectionView.contentInset.left) / cellWidthIncludeSpacing
        let roundedIndex = round(index)
        let indexPath = IndexPath(item: Int(roundedIndex), section: 0)
        if let cell = vocaBookCollectionView.cellForItem(at: indexPath) {
            animateZoomforCell(zoomCell: cell)
        }
        
        if Int(roundedIndex) != previousIndex {
            let preIndexPath = IndexPath(item: previousIndex, section: 0)
            if let preCell = vocaBookCollectionView.cellForItem(at: preIndexPath) {
                animateZoomforCellremove(zoomCell: preCell)
            }
            previousIndex = indexPath.item
        }
    }
    
    //탭 제스쳐 처리 메서드
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: vocaBookCollectionView)
        if let indexPath = vocaBookCollectionView.indexPathForItem(at: location) {
            let selectedBookCase = bookCases[indexPath.item]
            delegate?.didSelectBookCase(selectedBookCase)
        }
    }
}

extension BookCaseBodyView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = vocaBookCollectionView.dequeueReusableCell(withReuseIdentifier: BookCaseBodyCell.identifier, for: indexPath) as! BookCaseBodyCell
        let bookCaseData = bookCases[indexPath.item]
        cell.configure(with: bookCaseData)
        cell.delegateDelete = self
        cell.delagateEdit = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - collectionView.contentInset.left - collectionView.contentInset.right - 80
        let aspectRatio: CGFloat = 5.0 / 3.0
        let itemWidth = availableWidth
        let itemHeight = itemWidth * aspectRatio
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

extension BookCaseBodyView: DeleteBookCaseBodyCellDelegate {
    func didTapDeleteButton(on cell: BookCaseBodyCell) {
        guard let indexPath = vocaBookCollectionView.indexPath(for: cell) else { return }
        let bookCaseToDelete = bookCases[indexPath.item]
        CoreDataManager.shared.deleteBookCase(bookCase: bookCaseToDelete)
        self.configureUI()
    }
}

extension BookCaseBodyView: EditBookCaseBodyCellDelegate {
    func didTapEditButton(on cell: BookCaseBodyCell, with bookCaseData: NSManagedObject) {
        delagateEdit?.didTapEditButton(on: cell, with: bookCaseData)
    }
}

//애니메이션 메서드
extension BookCaseBodyView {
    func animateZoomforCell(zoomCell: UICollectionViewCell) {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                zoomCell.transform = .identity
            },
            completion: nil)
    }
    
    func animateZoomforCellremove(zoomCell: UICollectionViewCell) {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                zoomCell.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
            },
            completion: nil)
    }
}

//셀 선택 시
protocol BookCaseBodyViewDelegate: AnyObject {
    func didSelectBookCase(_ bookCase: NSManagedObject)
}
