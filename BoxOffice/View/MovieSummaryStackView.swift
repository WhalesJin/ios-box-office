//
//  MovieSummaryStackView.swift
//  BoxOffice
//
//  Created by Dasan on 2024/02/27.
//

import UIKit

final class MovieSummaryStackView: UIStackView {
    private var movieInformation: MovieInformation?
    
    private let summaryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .darkGray
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = .zero
        
        return label
    }()
    
    init(frame: CGRect, movieInformation: MovieInformation) {
        super.init(frame: frame)
        self.movieInformation = movieInformation
        
        configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MovieSummaryStackView {
    private func configureUI() {
        self.axis = .horizontal
        self.alignment = .leading
        self.distribution = .fill
        self.spacing = .zero
        self.translatesAutoresizingMaskIntoConstraints = false
        
        configureLabel()
        
        self.addArrangedSubview(summaryLabel)
    }
    
    private func configureLabel() {
        guard let productionYear = movieInformation?.productionYear,
              let watchGradesName = movieInformation?.audits.map({ $0.watchGradeName }).joined(separator: ", "),
              let showTime = movieInformation?.showTime else { return }
        
        summaryLabel.text = "\(productionYear) • \(watchGradesName) • \(showTime)분"
    }
}
