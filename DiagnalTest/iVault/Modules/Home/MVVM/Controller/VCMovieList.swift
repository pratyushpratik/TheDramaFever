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
    
    //mutable storage slot for back button title
    var backButtonTitle: String?
        
    //mutable storage slot for incrementing page number and pagination
    var page = 1
    var isLoadingList = false
    
    //mutable storage slot for datasource of CollectionView
    private lazy var moviesDataSource = movieListConfigureDataSource()
    
    //mutable storage slot for storing data from server
    private lazy var arrMovieList = [ResponseModelContent]()
    private lazy var filterArrMovieList = [ResponseModelContent]()

    //Enumeration for section of CollectionView
    private enum MovieListViewSection {
        case all
    }
    
    //Typealias for returntype of UICollectionViewDiffableDataSource
    private typealias MovieListDataSourceReturnType = UICollectionViewDiffableDataSource<MovieListViewSection, ResponseModelContent>
    
    //immutable storage slot for CollectionView CellReusableIdentifier
    private let cvcMovieListReusableIdentifier = CollectionViewCellReusableIdentifier.cvcMovieList.rawValue
    
    //mutable storage slot for right bar button item in navigation bar
    var rightButtonItem: UIBarButtonItem?
    
    //immutable storage of searchbar created to show in navigation bar
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        searchBar.sizeToFit()
        searchBar.tintColor = .white
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        return searchBar
    }()
    
    //mutable lazy storage of searchbar created to show in navigation bar
    //it is created mutable lazy storage slot to get the value of backButtonTitle at runtime
    lazy var backBarButtonItem: UIBarButtonItem = {
        let backButtonItem: UIButton = UIButton()
        backButtonItem.setImage(UIImage(named: "back")?.resizeImage(targetSize: CGSize.init(width: 16, height: 16)), for: .normal)
        backButtonItem.imageView?.contentMode = .center
        backButtonItem.setTitle("  \(backButtonTitle ?? "")", for: .normal)
        backButtonItem.titleLabel?.font = UIFont(name: "TitilliumWeb-Light", size: 18.0)
        backButtonItem.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backButtonItem.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        return UIBarButtonItem(customView: backButtonItem)
    }()
    
    //view lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
        vmMovieList.fireAPIGETMovieList(for: page)
        UINavigationBar.appearance().backgroundColor = .green
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
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
        collectionView.alwaysBounceVertical = true
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.register(UINib(nibName: cvcMovieListReusableIdentifier, bundle: nil), forCellWithReuseIdentifier: cvcMovieListReusableIdentifier)
    }
    
    func setupNavigationBar() {
        //self.navigationController?.navigationBar.shadowImage = UIImage(named: "nav_bar")?.resizeImage(targetSize: CGSize.init(width: UIScreen.main.bounds.width, height: 40))
        rightButtonItem = UIBarButtonItem.setupBarButton(self, action: #selector(rightButtonAction), imageName: "search", tintColor: .white)
        navigationItem.rightBarButtonItem = rightButtonItem
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    @objc func rightButtonAction() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }
            self.filterArrMovieList = self.arrMovieList
            DispatchQueue.main.async {
                self.searchBar.delegate = self
                self.navigationItem.titleView = self.searchBar
                self.navigationItem.rightBarButtonItem = nil
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIView(frame: CGRect(x: 0, y: 0, width: 4, height: 4)))
            }
        }
    }
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //method binding created to bind the viewmodel bindable storage slot with block
    //the block will automatically be called everytime when value will be set in the viewmodel bindable storage slot
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
            cell.layoutIfNeeded()
            return cell
        }
        return dataSource
    }
    
    //Creating a snapshot and populating the data to similarHashtagsCollectionView
    private func moviesUpdateSnapshot(animatingChange: Bool = false) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            var snapshot = NSDiffableDataSourceSnapshot<MovieListViewSection, ResponseModelContent>()
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
        //scroll animation called for large title label
        if let cell = cell as? CVCMovieList {
            cell.lblAnimation()
        }
        
        //pagination called
        //4 checks are called:
        //1st check is for count of page as page limit is 1...3
        //2nd check is to check if the indexPath.item has reached till arrMovieList.count - 6 to reload the next data
        //3rd check is that isLoadingList should is false which is working as a lock inorder to access this critical section one at a time
        //4th check is that pagination is going to work only in case if searching in not action
        if page <= 3,
           indexPath.item == arrMovieList.count - 6,
           self.isLoadingList == false,
           self.navigationItem.rightBarButtonItem != nil {
            isLoadingList = true
            page += 1
            vmMovieList.fireAPIGETMovieList(for: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let safeFrame = view.safeAreaLayoutGuide.layoutFrame
        let size = CGSize(width: safeFrame.width, height: safeFrame.height)
        let width = (size.width - 56) / 3
        let height = ceil(width * 16/9)
        return CGSize(width: width, height: height)    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 36
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.invalidateLayout()
        }
    }
}

/**
 MARK: UISearchBarDelegate Implementation
 - Delegate of SearchBar.
 */
extension VCMovieList: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }
            self.arrMovieList = self.filterArrMovieList
            DispatchQueue.main.async {
                searchBar.text = ""
                self.moviesUpdateSnapshot()
                self.navigationItem.rightBarButtonItem = self.rightButtonItem
                self.navigationItem.leftBarButtonItem = self.backBarButtonItem
                self.navigationItem.titleView = nil
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText:String){
        vmMovieList.filterContentForSearchText(searchText: searchText, arr: filterArrMovieList) { filteredArray in
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                guard let self = self else { return }
                if self.arrMovieList != filteredArray {
                    self.arrMovieList = filteredArray
                    DispatchQueue.main.async {
                        self.moviesUpdateSnapshot()
                    }
                }
            }
        }
    }
}
