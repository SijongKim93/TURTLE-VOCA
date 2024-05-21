//
//  RecordTableViewCell.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/18/24.
//

import UIKit
import SnapKit

class RecordTableViewCell: UITableViewCell {

    lazy var categoryLabel = LabelFactory().makeLabel(title: "Category", size: 20, isBold: true)
    lazy var wordLabel = LabelFactory().makeLabel(title: "score", size: 20, isBold: false)
    lazy var defLabel = LabelFactory().makeLabel(title: "GameCount", size: 20, isBold: false)
    
    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
        categoryLabel,
        wordLabel,
        defLabel
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
        
        categoryLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalTo(50)
        }
        
        wordLabel.snp.makeConstraints {
            $0.leading.equalTo(categoryLabel.snp.trailing).offset(30)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalTo(150)
        }
        
        defLabel.snp.makeConstraints {
            $0.leading.equalTo(wordLabel.snp.trailing).offset(30)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
    }
    
}

