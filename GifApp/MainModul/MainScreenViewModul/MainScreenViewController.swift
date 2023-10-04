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
    
    private let customSearchController = CustomSearchController(placeholderText: "Enter GIF name to search")
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupCollectionViewFlowLayout()
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
        view.backgroundColor = .white
        title = "GIF Searcher"
        addViews()
        makeConstraints()
        setupCollectionView()
        setupSearchBar()
    }
    
    //MARK: - addViews
    
    func addViews() {
        view.addSubview(customSearchController)
        view.addSubview(collectionView)
    }
    
    //MARK: - makeConstraints
    
    func makeConstraints() {
        
        customSearchController.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(customSearchController.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    //MARK: - setupCollectionView
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    func setupCollectionViewFlowLayout() {
        
        let layout = UICollectionViewFlowLayout()
        let collectionViewCellSize = collectionView.frame.width / 2
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets.zero
        layout.itemSize = CGSize(width: collectionViewCellSize, height: collectionViewCellSize)
        
        collectionView.collectionViewLayout = layout
    }
    //MARK: - setupSearchBar
    
    func setupSearchBar() {
        customSearchController.getTextClouser = { [weak self] text in
            guard let self else { return }
            self.presenter?.textSearch(inputedText: text)
        }
    }
}


//MARK: - MainScreenDisplayLogic

extension MainScreenViewController: MainScreenDisplayLogic {
    
    func updateView() {
        collectionView.reloadData()
    }
    
    func showErrorAlert(error: NetworkError) {
        let alertController = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Отмена", style: .cancel)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
}

//MARK: - UICollectionViewDataSource

extension MainScreenViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.getCountModel() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell,
              let model = presenter?.getModel(index: indexPath.row) else { return collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) }
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
