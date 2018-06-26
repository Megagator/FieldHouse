//
//  ViewController.swift
//  FieldHouse Sports
//
//  Created by Mike Reinhard on 3/10/18.
//  Copyright © 2018 Mike Reinhard. All rights reserved.
//

import UIKit

class SessionsViewController: UIViewController, UICollectionViewDelegate {
	var sessionCollectionView: UICollectionView!
	let sessionsDataSource = SessionsDataSource()
	let itemSpacing: CGFloat = 2 // points
	
	let logo = UIImageView()
	let soccerSpinner = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))


	override func viewDidLoad() {
//		self.title = "FieldHouse Sports"
				
		navigationController?.navigationBar.prefersLargeTitles = true
		// navigationController?.navigationBar.barStyle = .blackTranslucent;

		
		logo.image = #imageLiteral(resourceName: "logo")
		logo.contentMode = .top
		logo.center = CGPoint(x: view.frame.midX, y: view.frame.midY);
		logo.alpha = 0
		
		navigationItem.titleView = logo
		
		// add collection view
		let frame = self.view.frame
		let layout = UICollectionViewFlowLayout()
		sessionCollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
		sessionCollectionView.backgroundColor = Colors.white
		self.view.addSubview(sessionCollectionView)
		
		sessionCollectionView.translatesAutoresizingMaskIntoConstraints = false
		sessionCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
		sessionCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
		sessionCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
		sessionCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
		
		sessionCollectionView.register(SessionViewCell.self, forCellWithReuseIdentifier: "session")
		sessionCollectionView.dataSource = sessionsDataSource
		sessionCollectionView.delegate = self
		sessionCollectionView.alwaysBounceVertical = true
		
		// setup the grid
		let size = UIScreen.main.bounds.size
		layout.scrollDirection = .vertical
		layout.sectionInset = UIEdgeInsets.init(top: Padding.collections * 3, left: Padding.collections, bottom: Padding.collections, right: Padding.collections)
		layout.itemSize = CGSize(width: (size.width - (Padding.collections * 2)), height: Grid.cellHeight + 40)
		layout.minimumInteritemSpacing = Padding.collections // between items in same row
		layout.minimumLineSpacing = Padding.collections
		
		// pull to refresh
		let refreshUI = UIRefreshControl()
		refreshUI.addTarget(self, action: #selector( self.refreshData ), for: UIControl.Event.valueChanged)
		sessionCollectionView.refreshControl = refreshUI
		
		// data observer
		NotificationCenter.default.addObserver(self, selector: #selector(self.receivedNewData(notification:)), name: Notification.Name("NewSessionData"), object: nil)
		
		if sessionsDataSource.sessions.count == 0 {
			soccerSpinner.image = #imageLiteral(resourceName: "soccer")
			soccerSpinner.contentMode = .scaleAspectFit
			soccerSpinner.center = CGPoint(x: view.frame.midX, y: view.frame.midY)
			view.addSubview(soccerSpinner)
			
			let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
			rotation.toValue = NSNumber(value: Double.pi * 2)
			rotation.duration = 1
			rotation.isCumulative = true
			rotation.repeatCount = Float.greatestFiniteMagnitude
			soccerSpinner.layer.add(rotation, forKey: "rotationAnimation")
		}
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// deslect a cell when returning to this view
	override func viewDidAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.prefersLargeTitles = true
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let leaguesView = LeaguesViewController()
		leaguesView.title = sessionsDataSource.sessions[indexPath.row].attributes.name
		leaguesView.sessionID = sessionsDataSource.sessions[indexPath.row].id
		navigationController?.pushViewController(leaguesView, animated: true)
	}
	
	func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		
	}
	
	func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath) as! SessionViewCell
		cell.selectedItem()
	}
	
	func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath) as! SessionViewCell
		cell.deselectedItem()
	}
	

	@objc func receivedNewData(notification: Notification){
		DispatchQueue.main.async {
			self.sessionCollectionView.refreshControl?.endRefreshing()
			
			UIView.animate(withDuration: 0.3, animations: {
				self.soccerSpinner.transform = CGAffineTransform(scaleX: 0, y: 0);
			}, completion: { success in
				self.soccerSpinner.removeFromSuperview()
			})
			
			if self.sessionCollectionView.indexPathsForVisibleItems == [] {
				var newCells: [IndexPath] = []
				for i in 0..<self.sessionsDataSource.sessions.count {
					newCells.append(IndexPath(item: i, section: 0))
				}
				self.sessionCollectionView.insertItems(at: newCells)
			}else{
				self.sessionCollectionView.reloadData()
			}
		}
	}
	
	@objc func refreshData() {
		sessionsDataSource.forceRefreshData()
	}
}


