//
//  RecordTableViewCell.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/18/24.
//

import UIKit
import SnapKit

class RecordTableViewCell: UITableViewCell {

    lazy var gameCategoryLabel = LabelFactory().makeLabel(title: "Category", size: 20, isBold: true)
    lazy var gameScoreLabel = LabelFactory().makeLabel(title: "score", size: 20, isBold: false)
    lazy var countLabel = LabelFactory().makeLabel(title: "GameCount", size: 20, isBold: false)
    
    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
        gameCategoryLabel,
        gameScoreLabel,
        countLabel
        ])
        stackView.axis = .horizontal
        stackView.spacing = 30
        return stackView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout () {
        self.addSubview(hStackView)
        
        hStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        gameCategoryLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
            $0.width.equalTo(250)
        }
        
        gameScoreLabel.snp.makeConstraints {
            $0.leading.equalTo(gameScoreLabel.snp.trailing).offset(30)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        countLabel.snp.makeConstraints {
            $0.leading.equalTo(gameScoreLabel.snp.trailing).offset(30)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
    }
    
}
