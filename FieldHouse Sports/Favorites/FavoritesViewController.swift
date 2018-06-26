//
//  ViewController.swift
//  FieldHouse Sports
//
//  Created by Mike Reinhard on 3/10/18.
//  Copyright © 2018 Mike Reinhard. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	var favoriteCollectionView: UICollectionView!
	var favoritesDataSource: FavoritesDataSource!
	
	let noFavs = PaddedUILabel()
	
	override func viewDidLoad() {
		self.title = "Favorites"
		
//		print("favorite view: \(displayScores)")
		
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.white]
		
		// navigationController?.navigationBar.barStyle = .blackTranslucent;

		favoritesDataSource = FavoritesDataSource()

		
//		self.view.addSubview(teamRecord)
		
		// add collection view
		let frame = self.view.frame
		let layout = UICollectionViewFlowLayout()
		favoriteCollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)

		self.view.addSubview(favoriteCollectionView)
		self.view.addSubview(noFavs)
		
		updateEmptyLabel()

		favoriteCollectionView.translatesAutoresizingMaskIntoConstraints = false
		favoriteCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
		favoriteCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
		favoriteCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
		favoriteCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
		
		favoriteCollectionView.register(MatchViewCell.self, forCellWithReuseIdentifier: "match")
		favoriteCollectionView.dataSource = favoritesDataSource
		favoriteCollectionView.delegate = self
		favoriteCollectionView.alwaysBounceVertical = true
		
		// setup the grid
		layout.scrollDirection = .vertical
//		layout.sectionHeadersPinToVisibleBounds = true
		layout.headerReferenceSize = CGSize(width: favoriteCollectionView.frame.width, height: Grid.rowHeight)
		layout.sectionInset = UIEdgeInsets.init(top: 0, left: Padding.collections, bottom: Padding.collections, right: Padding.collections)
		layout.itemSize = CGSize(width: (favoriteCollectionView.frame.width - (Padding.collections * 2)), height: Grid.cellHeight)
		layout.minimumInteritemSpacing = Padding.collections // horizontal margin
		layout.minimumLineSpacing = Padding.collections // vertical margin
		
		// pull to refresh
		let refreshUI = UIRefreshControl()
		refreshUI.addTarget(self, action: #selector( self.refreshData ), for: UIControl.Event.valueChanged)
		favoriteCollectionView.refreshControl = refreshUI

		// background color
		favoriteCollectionView.backgroundColor = Colors.white
		
		// no favorites to show
		noFavs.translatesAutoresizingMaskIntoConstraints = false;
		noFavs.textAlignment = .left
		noFavs.textInsets = UIEdgeInsets(top: 4.0, left: 12.0, bottom: 4.0, right: 12.0)
		noFavs.font = UIFont.systemFont(ofSize: 18, weight: .bold)
		noFavs.layer.masksToBounds = true
		noFavs.layer.backgroundColor = Colors.lightgrey.cgColor
		noFavs.layer.cornerRadius = 14
		noFavs.textColor = Colors.white
		noFavs.text = "no favorited matches"
		noFavs.alpha = 0
		noFavs.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
		noFavs.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
		
		// data observer
//		NotificationCenter.default.addObserver(self, selector: #selector(self.receivedNewData(notification:)), name: Notification.Name("NewfavoriteData"), object: nil)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

	}
	
	func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		
	}
	
	func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath) as! MatchViewCell
		let match = favoritesDataSource.matches[indexPath.row]
		cell.selectedItem( match )
		favoritesDataSource.matches.remove(at: indexPath.row)
		favoriteCollectionView.deleteItems(at: [indexPath])
		updateEmptyLabel()
	}
	
	func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath) as! MatchViewCell
		cell.deselectedItem()
	}
	
	@objc func refreshData() {
		favoritesDataSource.refreshData()
		
		favoriteCollectionView.refreshControl?.endRefreshing()
		
		updateEmptyLabel()

		if favoritesDataSource.matches.count > 0  {
			self.favoriteCollectionView.performBatchUpdates({
				let range = Range(uncheckedBounds: (0, 1))
				let indexSet = IndexSet(integersIn: range)
				self.favoriteCollectionView.reloadSections(indexSet)
			}, completion: nil)
		}
		
//
//		if favoriteCollectionView.indexPathsForVisibleItems.count == 0
//			&& favoritesDataSource.matches.count > 0 {
//			var newCells: [IndexPath] = []
//			for i in 0..<self.favoritesDataSource.matches.count {
//				newCells.append(IndexPath(item: i, section: 0))
//			}
//			favoriteCollectionView.insertItems(at: newCells)
//		}else{
//			favoriteCollectionView.reloadData()
//		}
	}
	
	func updateEmptyLabel() {
		UIView.animate(withDuration: 0.4, animations: {
			if self.favoritesDataSource.matches.count > 0 {
				self.noFavs.alpha = 0
			}else{
				self.noFavs.alpha = 1
			}
		}, completion: nil)
	}
}


