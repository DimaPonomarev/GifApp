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
    func updateView()
    func showErrorAlert(error: NetworkError)
}

final class MainScreenViewController: UIViewController {
    
    //MARK: - MVP Properties
    
    var presenter: MainScreenPresentationProtocol?
    
    //MARK: - UI properties
    
    private let customSearchController = CustomSearchController()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    // MARK: - Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupVIPERModel()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        setupVIPERModel()
    }
    
    //MARK: - View lifecycle
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setupConfigure()
    }
    
    deinit {
        print("deinit")
    }
}

//MARK: - private method

private extension MainScreenViewController {
    
    // MARK: - setupVIPERModel
    
    func setupVIPERModel() {
        let assembly = MainScreenAssembly()
        assembly.configurate(self)
    }
    
    // MARK: - setupConfigure
    
    func setupConfigure() {
        addViews()
        makeConstraints()
        setupCollectionView()
        setupSearchBar()
    }
    
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
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    //MARK: - setupSearchBar
    
    func setupSearchBar() {
        navigationItem.searchController = customSearchController
        customSearchController.closure = { [weak self] text in
            guard let self else { return }
            self.presenter?.requestFor(inputedText: self.customSearchController.searchBar.text)
        }
    }
}

//MARK: - MainScreenDisplayLogic

extension MainScreenViewController: MainScreenDisplayLogic {
    
    func updateView() {
        collectionView.reloadData()
    }
    
    func showErrorAlert(error: NetworkError) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            switch error {
            case .canceledResponse: break
            default: self.presenter?.router?.errorAlert(error: error)
            }
        }
    }
}

//MARK: - UICollectionViewDataSource

extension MainScreenViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.getCountModel() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell,
              let model = presenter?.getModel(index: indexPath.row) else { return UICollectionViewCell() }
        cell.configureView(model)
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension MainScreenViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = presenter?.getModel(index: indexPath.row) else { return }
        self.presenter?.router?.showShareAlertWith(model)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.height {
            presenter?.loadAdditionalData()
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension MainScreenViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.frame.width
        let itemWidth = collectionViewWidth / 2
        return CGSize(width: itemWidth, height: itemWidth)
    }
}
