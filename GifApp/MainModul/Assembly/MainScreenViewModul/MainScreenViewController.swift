//
//  MainScreenViewController.swift
//  GifApp
//
//  Created by Дмитрий Пономарев on 02.10.2023.
//


import UIKit
import SnapKit

protocol MainScreenDisplayLogic: UIViewController {
    var presenter: MainScreenPresentationProtocol? {get set}
    func passDataFromPresenterToViewController(model: [ModelToShowOnScreen])
    func passDataFromPresenterToViewControllerWithPagging(model: [ModelToShowOnScreen])
    var isLoading: Bool { get set }
}

class MainScreenViewController: UIViewController, MainScreenDisplayLogic {
    
    //MARK: - MVP Properties
    
    var presenter: MainScreenPresentationProtocol?
    
    //MARK: - UI properties
    
    var isLoading = false
    
    let searchController = UISearchController()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    var currentData = [ModelToShowOnScreen]()
    
    // MARK: - Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        let assembly = MainScreenAssembly()
        assembly.configurate(self)
    }
    
    //MARK: - View lifecycle
    
    override func viewDidLoad(){
        super.viewDidLoad()
        addViews()
        makeConstraints()
        setupCollectionView()
        setupSearchBar()
    }
    
    //MARK: - passDataFromPresenterToViewController
    
    func passDataFromPresenterToViewController(model: [ModelToShowOnScreen]) {
        self.currentData = model
        self.collectionView.reloadData()
        
    }
    
    func passDataFromPresenterToViewControllerWithPagging(model: [ModelToShowOnScreen]) {
        
        for each in model {
            self.currentData.append(each)
            self.collectionView.reloadData()
            self.isLoading = false
        }
    }
}

//MARK: - private method

private extension MainScreenViewController {
    
    //MARK: - addViews
    
    func addViews() {
        view.addSubview(collectionView)
    }
    
    //MARK: - makeConstraints
    
    func makeConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    //MARK: - setupCollectionView
    
    func setupCollectionView() {
        collectionView.backgroundColor = .darkGray
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
    }
    
    //MARK: - setupSearchBar
    
    func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.textField?.backgroundColor = .white.withAlphaComponent(0.7)
        searchController.searchBar.textField?.keyboardType = .asciiCapable
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    func appendNewDataTo(data: [ModelToShowOnScreen]) {
        for each in data {
            currentData.append(each)
            self.collectionView.reloadData()
            self.isLoading = false
            
        }
    }
}


//MARK: - extension UICollectionViewDataSource

extension MainScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        currentData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell() }
        let model = currentData[indexPath.row]
        cell.configureView(model)
        return cell
    }
}

//MARK: - extension UICollectionViewDelegateFlowLayout

extension MainScreenViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.frame.width
        let itemWidth = collectionViewWidth / 2
        return CGSize(width: itemWidth, height: itemWidth)
    }
}

//MARK: - extension UICollectionViewDelegate

extension MainScreenViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presenter?.router?.showAlert(dataToShare: self.currentData[indexPath.row].image)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - 1000  && searchController.searchBar.text != "" && !isLoading {
            presenter?.makeRequestToInteractorToProvideWeatherData(isPagging: true, in: searchController.searchBar.text!)
            isLoading = true
        }
    }
}

//MARK: - extension UISearchBarDelegate

extension MainScreenViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = true
    }
}

//MARK: - extension UISearchResultsUpdating

extension MainScreenViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        presenter?.updateSearch(searchController: searchController)
    }
}


