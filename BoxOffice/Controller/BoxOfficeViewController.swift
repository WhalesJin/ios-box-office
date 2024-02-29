//
//  BoxOfficeViewController.swift
//  BoxOffice
//
//  Created by kjs on 13/01/23.
//  Last modified by Dasan & Whales.

import UIKit
import OSLog

private enum Section: Hashable {
    case main
}

private enum CollectionViewStyle {
    case list
    case grid
}

final class BoxOfficeViewController: UIViewController {
    private let boxOfficeManager = BoxOfficeManager()
    private let yesterday = TargetDate(dayFromNow: -1)
    private var items = [BoxOfficeItem]()
    
    private var collectionView: UICollectionView! = nil
    private var dataSource: UICollectionViewDiffableDataSource<Section, BoxOfficeItem>! = nil
    private let activityIndicatorView = UIActivityIndicatorView()
    private var collectionViewStyle: CollectionViewStyle = .list
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy(style: collectionViewStyle)
        configureActivityIndicatorView()
        startActivityIndicator()
        loadData()
        configureDataSource(style: collectionViewStyle)
        configureNavigationItem(title: yesterday.formattedWithHyphen())
        
        collectionView.delegate = self
    }
    
    private func loadData() {
        boxOfficeManager.fetchBoxOfficeItems(targetDate: yesterday) { result in
            switch result {
            case .success(let items):
                DispatchQueue.main.async {
                    self.items = items
                    self.applySnapshot()
                    self.stopActivityIndicator()
                }
            case .failure(let error):
                os_log("%{public}@", type: .default, error.localizedDescription)
            }
        }
    }
}

extension BoxOfficeViewController {
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, BoxOfficeItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    private func configureHierarchy(style: CollectionViewStyle) {
        if style == .list {
            collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createListLayout())
        } else {
            collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createGridLayout())
        }
        
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(collectionView)
        configureRefreshControl()
    }
    
    private func createListLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    private func createGridLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let wideMode = layoutEnvironment.container.effectiveContentSize.width > 800
            let columns = wideMode ? 4 : 2
            let fractionWidth: CGFloat = 1.0/CGFloat(columns)
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fractionWidth),
                                                  heightDimension: .fractionalHeight(1))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .fractionalWidth(fractionWidth*2.2))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitem: item,
                                                           count: columns)
            
            return NSCollectionLayoutSection(group: group)
        }
    }
    
    private func configureDataSource(style: CollectionViewStyle) {
        if style == .list {
            let cellRegistration = UICollectionView.CellRegistration<BoxOfficeListCell, BoxOfficeItem> { (cell, indexPath, item) in
                let rankIntensityText = self.configureRankIntensity(with: item.boxOfficeData)
                cell.updateLabel(with: item, rankIntensityText)
            }
            
            dataSource = UICollectionViewDiffableDataSource<Section, BoxOfficeItem>(collectionView: collectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath, identifier: BoxOfficeItem) -> UICollectionViewListCell? in
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
            }
        } else {
            let cellRegistration = UICollectionView.CellRegistration<BoxOfficeGridCell, BoxOfficeItem> { (cell, indexPath, item) in
                let rankIntensityText = self.configureRankIntensity(with: item.boxOfficeData)
                cell.updateLabel(with: item, rankIntensityText)
            }
            
            dataSource = UICollectionViewDiffableDataSource<Section, BoxOfficeItem>(collectionView: collectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath, identifier: BoxOfficeItem) -> UICollectionViewCell? in
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
            }
        }
        
        applySnapshot()
    }
    
    private func configureRankIntensity(with boxOfficeData: BoxOfficeData) -> NSMutableAttributedString {
        var text: String
        var attributedString: NSMutableAttributedString
        let rankOldOrNew = boxOfficeData.rankOldOrNew
        
        guard let rankIntensity = Int(boxOfficeData.rankIntensity) else {
            return NSMutableAttributedString(string: "")
        }
        
        if rankOldOrNew.rawValue == RankOldOrNew.old.rawValue {
            if rankIntensity < 0 {
                text = "▼\(-rankIntensity)"
                attributedString = NSMutableAttributedString(string: text)
                attributedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: (text as NSString).range(of: "▼"))
                
                return attributedString
            } else if rankIntensity > 0 {
                text = "▲\(rankIntensity)"
                attributedString = NSMutableAttributedString(string: text)
                attributedString.addAttribute(.foregroundColor, value: UIColor.systemRed, range: (text as NSString).range(of: "▲"))
                
                return attributedString
            } else {
                return NSMutableAttributedString(string: "-")
            }
        } else {
            text = "신작"
            attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(.foregroundColor, value: UIColor.systemRed, range: (text as NSString).range(of: "신작"))
            
            return attributedString
        }
    }
    
    private func configureNavigationItem(title: String) {
        navigationItem.title = title
        
        setViewModeButton(currentStyle: collectionViewStyle)
    }
    
    private func setViewModeButton(currentStyle: CollectionViewStyle) {
        var imageName: String {
            switch currentStyle {
            case .list :
                return "rectangle.grid.2x2"
            case .grid :
                return "list.bullet"
            }
        }
        
        let viewModeButton = UIBarButtonItem(image: UIImage(systemName: imageName), style: .plain, target: self, action: #selector(tappedChangeViewModeButton))
        
        navigationItem.rightBarButtonItem = viewModeButton
    }
    
    @objc func tappedChangeViewModeButton() {
        changeMode()
    }
    
    private func changeMode() {
        if collectionViewStyle == .list {
            collectionViewStyle = .grid
        } else {
            collectionViewStyle = .list
        }
        
        setViewModeButton(currentStyle: collectionViewStyle)
        
        collectionView.removeFromSuperview()

        configureHierarchy(style: collectionViewStyle)
        configureDataSource(style: collectionViewStyle)

        collectionView.delegate = self
    }
}

extension BoxOfficeViewController {
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
        activityIndicatorView.startAnimating()
    }
    
    private func stopActivityIndicator() {
        activityIndicatorView.stopAnimating()
        activityIndicatorView.removeFromSuperview()
    }
    
    private func configureRefreshControl() {
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.loadData()
            self.configureNavigationItem(title: self.yesterday.formattedWithHyphen())
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
}

extension BoxOfficeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.item]
        let movieInformation = selectedItem.movieInformation
        let posterImager = selectedItem.posterImage
        let plot = selectedItem.plot
        let movieInformationViewController = MovieInformationViewController(movieInformation: movieInformation, posterImage: posterImager, plot: plot)
        
        show(movieInformationViewController, sender: self)
    }
}
