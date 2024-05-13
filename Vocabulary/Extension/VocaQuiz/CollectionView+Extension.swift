//
//  CollectionView+Extension.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/13/24.
//

import UIKit

extension VocaQuizViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func setUp (){
        quizBodyView.collectionView.delegate = self
        quizBodyView.collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = quizBodyView.collectionView.dequeueReusableCell(withReuseIdentifier: Constants.vocaQuizMainCell, for: indexPath) as? VocaQuizMainCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let item = buttonList[indexPath.row]
        
        cell.titleLabel.text = item

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0 :
            let gamePageVC = GamePageViewController ()
            
            self.present(gamePageVC, animated: true)
        case 1 :
            print("1")
        default :
            return
        }
    }

}

extension GamePageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func setUp (){
        gamePageBottomView.collectionView.delegate = self
        gamePageBottomView.collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = gamePageBottomView.collectionView.dequeueReusableCell(withReuseIdentifier: Constants.gameCell, for: indexPath) as? GamePageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let item = dummyData[indexPath.row]
        
        cell.titleLabel.text = item
        
        return cell
    }
    

}
