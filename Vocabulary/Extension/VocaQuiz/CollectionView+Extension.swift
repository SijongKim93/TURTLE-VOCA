//
//  CollectionView+Extension.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/13/24.
//

import UIKit
import ProgressHUD

extension GameMainPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func setUp (){
        gameMainBottomView.collectionView.delegate = self
        gameMainBottomView.collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = gameMainBottomView.collectionView.dequeueReusableCell(withReuseIdentifier: Constants.vocaQuizMainCell, for: indexPath) as? VocaQuizMainCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let item = buttonList[indexPath.row]
        
        cell.titleLabel.text = item
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0 :
            checkSetting()
            let flashVC = FlashCardViewController()
            flashVC.receivedData = receivedData
            
            self.present(flashVC, animated: true)
        case 1 :
            checkSetting()
            let quizVC = QuizViewController()
            quizVC.receivedData = receivedData
            
            self.present(quizVC, animated: true)
        case 2 :
            checkSetting()
            let hangVC = HangManGameViewController()
            hangVC.receivedData = receivedData
            
            self.present(hangVC, animated: true)
        case 3 :
            let recordVC = RecordViewController()
            recordVC.dataList = dataList
            
            self.present(recordVC, animated: true)
        case 4 :
            let vc = SelectVocaViewController()
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = self
            self.present(vc, animated: true, completion: nil)
        default :
            return
        }
    }
    
}
