//
//  CollectionView+Extension.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/13/24.
//

import UIKit

extension GameMainPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func setUp (){
        gameMainBodyView.collectionView.delegate = self
        gameMainBodyView.collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = gameMainBodyView.collectionView.dequeueReusableCell(withReuseIdentifier: Constants.vocaQuizMainCell, for: indexPath) as? VocaQuizMainCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let item = buttonList[indexPath.row]
        
        cell.titleLabel.text = item

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0 :
            let flashVC = FlashCardViewController()
            
            self.present(flashVC, animated: true)
        case 1 :
            let quizVC = QuizViewController()
            
            self.present(quizVC, animated: true)
        case 2 :
            let hangVC = HangManGameViewController()
            
            self.present(hangVC, animated: true)
        case 3 :
            let recordVC = RecordViewController()
            
            self.present(recordVC, animated: true)
        default :
            return
        }
    }

}
