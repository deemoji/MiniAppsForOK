//
//  ViewController.swift
//  MiniAppsForOK
//
//  Created by Дмитрий Мартьянов on 04.09.2024.
//

import UIKit

final class ViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, MiniApp>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, MiniApp>
    
    @IBOutlet weak var collapseButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var collapsed: Bool = true
    
    private var childControllers: [Int: UIViewController] = [:]
    
    private let viewModel = ViewModel()
    
    private var dataSource: DataSource!
    
    
    @IBAction func collapseButtonTapped(_ sender: UIBarButtonItem) {
        collapsed.toggle()
        sender.title = collapsed ? "Развернуть" : "Свернуть"
        clearChildControllersCache()
        
        collectionView.reloadData()
        collectionView.setCollectionViewLayout(createLayout(), animated: true)
        collectionView.allowsSelection = collapsed
        
    }
    private func clearChildControllersCache() {
        for controller in childControllers.values {
            controller.willMove(toParent: nil)
            controller.view.removeFromSuperview()
            controller.removeFromParent()
        }
        childControllers.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collapseButton.title = collapsed ? "Развернуть" : "Свернуть"
        setupCollectionView()
        viewModel.appsLoaded = { apps in
            self.update(apps)
        }
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: .main), forCellWithReuseIdentifier: CollectionViewCell.identifier)
        setupDataSource()
        collectionView.delegate = self
        collectionView.collectionViewLayout = createLayout()
    }
    // MARK: - Configuring Layout
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [unowned self] index, environment in
            if UIDevice.current.orientation.isLandscape && !self.collapsed {
                return self.createLandscapeSection(for: environment)
            } else {
                return self.createPortraitSection(for: environment)
            }
        }
        return layout
    }
    private func createPortraitSection(for layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(collapsed ? 0.125 : 0.5)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .none
        
        return section
    }
    private func createLandscapeSection(for layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    
    // MARK: - Configuring DataSource
    private func setupDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { [unowned self] collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
            if let controller = childControllers[indexPath.item] {
                cell.configure(with: controller.view)
                return cell
            }
            let toPresent = collapsed ? item.previewViewController : item.mainViewController
            cell.configure(with: toPresent.view)
            self.addChildViewController(toPresent, at: indexPath.item)
            return cell
        })
    }
    private func addChildViewController(_ viewController: UIViewController, at index: Int) {
        addChild(viewController)
        viewController.didMove(toParent: self)
        childControllers[index] = viewController
    }
    private func update(_ apps: [MiniApp]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(apps)
        dataSource.apply(snapshot)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collapsed, let toPresent = viewModel.app(at: indexPath.row)?.mainViewController else {return }
        present(toPresent, animated: true)
    }
}
