//
//  BoxOfficeListCell.swift
//  BoxOffice
//
//  Created by Dasan & Whales on 2023/08/05.
//

import UIKit

final class BoxOfficeListCell: UICollectionViewListCell {
    static let identifier = "boxOfficeCell"
    
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
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        
        return stackView
    }()
    
    private var rankStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        
        return imageView
    }()
    
    private var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        
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

extension BoxOfficeListCell {
    private func configureUI() {
        rankStackView.addArrangedSubview(rankLabel)
        rankStackView.addArrangedSubview(rankIntensityLabel)
        titleStackView.addArrangedSubview(movieNameLabel)
        titleStackView.addArrangedSubview(audienceLabel)
        titleStackView.addArrangedSubview(audienceAccumulateLabel)
        titleStackView.addArrangedSubview(openingDateLabel)
        stackView.addArrangedSubview(rankStackView)
        stackView.addArrangedSubview(movieImageView)
        stackView.addArrangedSubview(titleStackView)
        
        contentView.addSubview(stackView)
        self.accessories = [.disclosureIndicator()]
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
                constant: Constraints.stackViewFromContentViewTrailing
            ),
            stackView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constraints.stackViewFromContentViewTop
            ),
            stackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: Constraints.stackViewFromContentViewBottom
            ),
            rankStackView.widthAnchor.constraint(
                equalTo: contentView.widthAnchor,
                multiplier: Constraints.rankStackViewFromContentViewWidth
            ),
            movieImageView.widthAnchor.constraint(
                equalTo: contentView.widthAnchor,
                multiplier: 0.23
            ),
            titleStackView.topAnchor.constraint(
                equalTo: stackView.topAnchor,
                constant: Constraints.titleViewFromContentViewTop
            ),
            titleStackView.bottomAnchor.constraint(
                equalTo: stackView.bottomAnchor,
                constant: Constraints.titleViewFromContentViewBottom
            )
        ])
    }
}
