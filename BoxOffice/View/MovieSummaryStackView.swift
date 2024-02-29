//
//  MovieSummaryStackView.swift
//  BoxOffice
//
//  Created by Dasan on 2024/02/27.
//

import UIKit

final class MovieSummaryStackView: UIStackView {
    private var movieInformation: MovieInformation?
    
    private let basicInformationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .darkGray
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = .zero
        
        return label
    }()
    
    private let showInformationLabel: UILabel = {
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
        self.axis = .vertical
        self.alignment = .leading
        self.distribution = .fill
        self.spacing = 8
        self.translatesAutoresizingMaskIntoConstraints = false
        
        configureLabel()
        
        self.addArrangedSubview(basicInformationLabel)
        self.addArrangedSubview(showInformationLabel)
    }
    
    private func configureLabel() {
        guard let productionYear = movieInformation?.productionYear,
              let nationsName = movieInformation?.nations.map({ $0.nationName }).joined(separator: ", "),
              let genresName = movieInformation?.genres.map({ $0.genreName }).joined(separator: ", "),
              let watchGradesName = movieInformation?.audits.map({ $0.watchGradeName }).joined(separator: ", "),
              let showTime = movieInformation?.showTime
        else { return }
        
        basicInformationLabel.text = "\(productionYear) • \(nationsName) • \(genresName)"
        showInformationLabel.text = "\(watchGradesName) • \(showTime)분"
    }
}
