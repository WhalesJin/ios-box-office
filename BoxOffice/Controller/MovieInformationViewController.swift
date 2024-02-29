//
//  MovieInformationViewController.swift
//  BoxOffice
//
//  Created by Dasan & Whales on 2023/08/14.
//

import UIKit
import OSLog

final class MovieInformationViewController: UIViewController {
    private let boxOfficeManager = BoxOfficeManager()
    private let imageManager = ImageManager()
    private var movieInformation: MovieInformation?
    private var posterImage: UIImage?
    private var plot: String?
    
    private let activityIndicatorView = UIActivityIndicatorView()
    
    init(movieInformation: MovieInformation, posterImage: UIImage, plot: String) {
        super.init(nibName: nil, bundle: nil)
        self.movieInformation = movieInformation
        self.posterImage = posterImage
        self.plot = plot
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureActivityIndicatorView()
        configureNavigationItem()
        configureUI()
    }
}

extension MovieInformationViewController {
    private func configureNavigationItem() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = movieInformation?.movieName
    }
    
    private func configureUI() {
        guard let movieInformation = movieInformation,
              let posterImage = posterImage,
              let plot = plot
        else { return }
        
        let movieScrollView = MovieScrollView(frame: .zero, movieInformation: movieInformation, image: posterImage, plot: plot)
        
        activityIndicatorView.removeFromSuperview()
        view.addSubview(movieScrollView)
        
        NSLayoutConstraint.activate([
            movieScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            movieScrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            movieScrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            movieScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension MovieInformationViewController {
    private func configureActivityIndicatorView() {
        view.addSubview(activityIndicatorView)
        
        activityIndicatorView.style = .large
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func startActivityIndicator() {
        self.activityIndicatorView.startAnimating()
    }
    
    private func stopActivityIndicator() {
        self.activityIndicatorView.stopAnimating()
    }
}
