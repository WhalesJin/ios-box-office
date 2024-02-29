//
//  MovieScrollView.swift
//  BoxOffice
//
//  Created by Dasan & Whales on 2023/08/14.
//

import UIKit

final class MovieScrollView: UIScrollView {
    private var movieInformation: MovieInformation?
    private var image: UIImage?
    private var plot: String?
    private var movieInformationStackView: MovieInformationStackView?
    private var movieSummaryStackView: MovieSummaryStackView?
    
    private let movieStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        
        return imageView
    }()
    
    init(frame: CGRect, movieInformation: MovieInformation, image: UIImage, plot: String) {
        super.init(frame: frame)
        self.movieInformation = movieInformation
        self.image = image
        self.plot = plot
        
        configureUI()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MovieScrollView {
    private func configureUI() {
        configureMovieSummaryStackView()
        configureMovieImageView()
        configureMovieInformationStackView()
        
        guard let movieSummaryStackView = movieSummaryStackView,
              let movieInformationStackView = movieInformationStackView
        else { return }
        
        self.addSubview(movieStackView)
        movieStackView.addArrangedSubview(movieSummaryStackView)
        movieStackView.addArrangedSubview(movieImageView)
        movieStackView.addArrangedSubview(movieInformationStackView)
    }
    
    private func configureMovieImageView() {
        movieImageView.image = image
    }
    
    private func configureMovieSummaryStackView() {
        guard let movieInformation = movieInformation else { return }
        movieSummaryStackView = MovieSummaryStackView(frame: .zero, movieInformation: movieInformation)
    }
    
    private func configureMovieInformationStackView() {
        guard let movieInformation = movieInformation,
              let plot = plot
        else { return }
        
        movieInformationStackView = MovieInformationStackView(frame: .zero, movieInformation: movieInformation, plot: plot)
    }
    
    private func setUpConstraints() {
        guard let movieSummaryStackView = movieSummaryStackView,
              let movieInformationStackView = movieInformationStackView
        else { return }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let imageRatio = calculateImageRatio()
        
        NSLayoutConstraint.activate([
            movieStackView.topAnchor.constraint(equalTo: self.topAnchor),
            movieStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            movieStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            movieStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            movieStackView.widthAnchor.constraint(equalTo: self.widthAnchor),
            
            movieSummaryStackView.widthAnchor.constraint(
                equalTo: movieStackView.widthAnchor,
                constant: -40
            ),
            
            movieImageView.widthAnchor.constraint(
                equalTo: movieStackView.widthAnchor,
                constant: Constraints.movieImageViewFromMovieStackViewWidth
            ),
            movieImageView.heightAnchor.constraint(
                equalTo: movieImageView.widthAnchor,
                multiplier: imageRatio
            ),
            
            movieInformationStackView.widthAnchor.constraint(
                equalTo: movieStackView.widthAnchor,
                constant: Constraints.movieInformationStackViewFromMovieStackViewWidth
            )
        ])
    }
    
    private func calculateImageRatio() -> Double {
        guard let image = image else { return 0 }
        
        return Double(image.size.height) / Double(image.size.width)
    }
}
