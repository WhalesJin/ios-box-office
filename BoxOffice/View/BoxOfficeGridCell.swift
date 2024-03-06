//
//  BoxOfficeGridCell.swift
//  BoxOffice
//
//  Created by Dasan & Whales on 2023/08/05.
//

import UIKit

final class BoxOfficeGridCell: UICollectionViewCell {
    static let identifier = "boxOfficeGridCell"
    
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        
        return imageView
    }()
    
    private let rankLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 1
        
        return label
    }()
    
    private let rankIntensityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 1
        
        return label
    }()
    
    private let movieNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textAlignment = .left
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 1
        
        return label
    }()
    
    private let audienceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .left
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 1
        
        return label
    }()
    
    private let audienceAccumulateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .left
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 1
        
        return label
    }()
    
    private let openingDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .left
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 1
        
        return label
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.spacing = 6
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        rankIntensityLabel.textColor = .black
    }
    
    func updateLabel(with boxOfficeItem: BoxOfficeItem, _ rankIntensityText: NSMutableAttributedString) {
        rankLabel.text = boxOfficeItem.boxOfficeData.rank
        rankIntensityLabel.text = boxOfficeItem.boxOfficeData.rankIntensity
        movieNameLabel.text = boxOfficeItem.boxOfficeData.movieName
        openingDateLabel.text = "개봉일: \(boxOfficeItem.boxOfficeData.openingDate)"
        
        let audienceCount = CountFormatter.decimal.string(for: Int(boxOfficeItem.boxOfficeData.audienceCount)) ?? "-"
        let audienceAccumulate = CountFormatter.decimal.string(for: Int(boxOfficeItem.boxOfficeData.audienceAccumulate)) ?? "-"
        
        audienceLabel.text = "일별 관객수: \(audienceCount) 명"
        audienceAccumulateLabel.text = "누적 관계수: \(audienceAccumulate) 명"
        rankIntensityLabel.attributedText = rankIntensityText
        movieImageView.image = boxOfficeItem.posterImage
    }
}

extension BoxOfficeGridCell {
    private func configureUI() {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.systemGray4.cgColor
        
        stackView.addArrangedSubview(movieImageView)
        stackView.addArrangedSubview(rankLabel)
        stackView.addArrangedSubview(movieNameLabel)
        stackView.addArrangedSubview(rankIntensityLabel)
        stackView.addArrangedSubview(audienceLabel)
        stackView.addArrangedSubview(audienceAccumulateLabel)
        stackView.addArrangedSubview(openingDateLabel)
        
        contentView.addSubview(stackView)
        setUpStackViewConstraints()
    }
    
    private func setUpStackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 10
            ),
            stackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -10
            ),
            stackView.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),
            stackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            ),
        ])
    }
}
