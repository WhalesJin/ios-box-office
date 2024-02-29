//
//  MovieInformationStackView.swift
//  BoxOffice
//
//  Created by Dasan & Whales on 2023/08/15.
//

import UIKit

final class MovieInformationStackView: UIStackView {
    private var movieInformation: MovieInformation?
    private var plot: String?
    
    private var directorStackView: MovieDetailStackView?
    private var actorStackView: MovieDetailStackView?
    
    private let plotLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .darkGray
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = .zero
        
        return label
    }()
    
    init(frame: CGRect, movieInformation: MovieInformation, plot: String) {
        super.init(frame: frame)
        self.movieInformation = movieInformation
        self.plot = plot
        
        configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MovieInformationStackView {
    private func configureUI() {
        self.axis = .vertical
        self.alignment = .center
        self.distribution = .fill
        self.spacing = 10
        self.translatesAutoresizingMaskIntoConstraints = false
        
        configureLabels()
        
        self.addArrangedSubview(plotLabel)
        
        plotLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        _ = [directorStackView, actorStackView].map {
            guard let stackView = $0 else { return }
            self.addArrangedSubview(stackView)
            stackView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        }
    }
    
    private func configureLabels() {
        guard let plot = plot,
              let directorsName = movieInformation?.directors.map({ $0.personName }).joined(separator: ", "),
              let actorsName = movieInformation?.actors.map({ $0.personName }).joined(separator: ", ")
        else { return }
        
        plotLabel.text = plot
        directorStackView = MovieDetailStackView(frame: .zero, title: "감독", content: directorsName)
        actorStackView = MovieDetailStackView(frame: .zero, title: "출연", content: actorsName)
    }
}
