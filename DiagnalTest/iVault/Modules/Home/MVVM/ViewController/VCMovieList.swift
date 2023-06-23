//
//  VCMovieList.swift
//  DiagnalTest
//
//  Created by Pratyush Pratik Sinha on 22/06/23.
//

/**
 MARK: Importing modules
 */
import UIKit

/**
 MARK: VCMovieList
 - Defination of class VCMovieList.
 */
class VCMovieList: UIViewController {
    
    //outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    //immutable storage slot for viewmodel
    private let vmMovieList = VMMovieList()
        
    //mutable storage slot for incrementing page number and pagination
    var page = 1
    var isLoadingList = false

    //mutable storage slot for navigationbar title
    var navigationBarTitle: String?
    
    //mutable storage slot for datasource of CollectionView
    private lazy var moviesDataSource = movieListConfigureDataSource()
    
    //mutable storage slot for storing data from server
    private lazy var arrMovieList = [ResponseModelMovieList.Page.ContentItems.Content]()
    
    //Enumeration for section of CollectionView
    private enum MovieListViewSection {
        case all
    }
    
    //Typealias for returntype of UICollectionViewDiffableDataSource
    private typealias MovieListDataSourceReturnType = UICollectionViewDiffableDataSource<MovieListViewSection, ResponseModelMovieList.Page.ContentItems.Content>
    
    //immutable storage slot for CollectionView CellReusableIdentifier
    private let cvcMovieListReusableIdentifier = CollectionViewCellReusableIdentifier.cvcMovieList.rawValue

    //view lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
        
        vmMovieList.fireAPIGETMovieList(for: page)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = navigationBarTitle
    }
}

//private extension of VCMovieList for setting up the user interface
private extension VCMovieList {
    func setupUI() {
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView.dataSource = moviesDataSource
        collectionView.delegate = self
        collectionView.register(UINib.init(nibName: cvcMovieListReusableIdentifier, bundle: nil), forCellWithReuseIdentifier: cvcMovieListReusableIdentifier)
    }
    
    func setupBinding() {
        vmMovieList.arrMovieList.bind { [weak self] (model) in
            guard let self = self else { return }
            if let model = model {
                self.arrMovieList.append(contentsOf: model)
                self.moviesUpdateSnapshot()
            }
        }
    }
}

/**
 MARK: Configuration of movieList data source
 - mapping of collectionView with CVCMovieList.
*/
extension VCMovieList {
    private func movieListConfigureDataSource() -> MovieListDataSourceReturnType {
        let dataSource = MovieListDataSourceReturnType(collectionView: collectionView) { [weak self] (collectionView, indexPath, model) -> UICollectionViewCell? in
            guard let self = self,
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cvcMovieListReusableIdentifier, for: indexPath) as? CVCMovieList else {
                return UICollectionViewCell()
            }
            cell.model = model
            return cell
        }
        return dataSource
    }
    
    //Creating a snapshot and populating the data to similarHashtagsCollectionView
    private func moviesUpdateSnapshot(animatingChange: Bool = false) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            var snapshot = NSDiffableDataSourceSnapshot<MovieListViewSection, ResponseModelMovieList.Page.ContentItems.Content>()
            snapshot.appendSections([.all])
            snapshot.appendItems(self.arrMovieList, toSection: .all)
            self.moviesDataSource.apply(snapshot, animatingDifferences: false) {
                self.isLoadingList = false
            }
        }
    }
}

/**
 MARK: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate Implementation
 - FlowLayout and Delegate of CollectionView.
 */
extension VCMovieList: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if page <= 3 && indexPath.item == arrMovieList.count - 3 && self.isLoadingList == false {
            isLoadingList = true
            page += 1
            vmMovieList.fireAPIGETMovieList(for: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 56)/3
        let height = ceil(width * 16/9)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 48
    }
}
