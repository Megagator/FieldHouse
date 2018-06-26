//
//  ViewController.swift
//  FieldHouse Sports
//
//  Created by Mike Reinhard on 3/10/18.
//  Copyright © 2018 Mike Reinhard. All rights reserved.
//

import UIKit

class LeaguesViewController: UIViewController, UICollectionViewDelegate {
	var leagueCollectionView: UICollectionView!
	var leaguesDataSource: LeaguesDataSource!
	var sessionID: String = ""

	let soccerSpinner = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
	
	override func viewDidLoad() {
		let backButton = UIBarButtonItem(
			title: "",
			style: .plain,
			target: nil,
			action: nil
		);
		
		navigationController?.navigationBar.topItem!.backBarButtonItem = backButton
		navigationController?.navigationBar.prefersLargeTitles = false
//		navigationController?.navigationBar.barStyle = .blackTranslucent;

//		navigationController?.navigationBar.layer.addLeftBorder(color: Colors.classicBlue, thickness: 3)
//		navigationController?.navigationBar.layer.addRightBorder(color: Colors.classicGreen, thickness: 3)
		
		// add collection view
		let frame = self.view.frame
		let layout = UICollectionViewFlowLayout()
		leagueCollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
		leagueCollectionView.backgroundColor = Colors.exlightgrey
		self.view.addSubview(leagueCollectionView)
		
		leagueCollectionView.translatesAutoresizingMaskIntoConstraints = false
		leagueCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
		leagueCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
		leagueCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
		leagueCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
		
		leagueCollectionView.register(LeagueViewCell.self, forCellWithReuseIdentifier: "league")
		
		leaguesDataSource = LeaguesDataSource( sessionID )
		leagueCollectionView.dataSource = leaguesDataSource
		leagueCollectionView.delegate = self
		leagueCollectionView.alwaysBounceVertical = true
		leagueCollectionView.register(LeaguesCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "leaguesReusableHeader")
		
		// setup the grid
		layout.scrollDirection = .vertical
		layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
		//	layout.sectionHeadersPinToVisibleBounds = true
		layout.headerReferenceSize = CGSize(width: leagueCollectionView.frame.width, height: 60)
		layout.itemSize = CGSize(width: leagueCollectionView.frame.width, height: 54)
		layout.minimumInteritemSpacing = 0 // horizontal margin
		layout.minimumLineSpacing = 0 // vertical margin
		
		// pull to refresh
		let refreshUI = UIRefreshControl()
		refreshUI.addTarget(self, action: #selector( self.refreshData ), for: UIControl.Event.valueChanged)
		leagueCollectionView.refreshControl = refreshUI
		
		// data observer
		NotificationCenter.default.addObserver(self, selector: #selector(self.receivedNewData(notification:)), name: Notification.Name("NewLeagueData"), object: nil)
		
		if leaguesDataSource.leagues.count == 0 {
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
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
//		navigationController?.navigationBar.prefersLargeTitles = true
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//		let teamsView = TeamsViewController()
//		teamsView.title = leaguesDataSource.leagues[indexPath.row].attributes.name
//		teamsView.leagueID = leaguesDataSource.leagues[indexPath.row].id
//		navigationController?.pushViewController(teamsView, animated: true)
	
		let standingsView = StandingsViewController()
		standingsView.title = leaguesDataSource.leagues[indexPath.row].attributes.name
		standingsView.leagueID = leaguesDataSource.leagues[indexPath.row].id
		standingsView.tracksStandings = leaguesDataSource.leagues[indexPath.row].attributes.tracks_standings
		standingsView.displayScores = leaguesDataSource.leagues[indexPath.row].attributes.display_scores
		print("Leagues: \(leaguesDataSource.leagues[indexPath.row].attributes.display_scores)")
		navigationController?.pushViewController(standingsView, animated: true)
	}
	
	func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		
	}
	
	func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath) as! LeagueViewCell
		cell.selectedRow()
	}
	
	func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath) as! LeagueViewCell
		cell.deselectedRow()
	}
	

	@objc func receivedNewData(notification: Notification){
		DispatchQueue.main.async {
			UIView.animate(withDuration: 0.4, animations: {
				self.soccerSpinner.alpha = 0
				}, completion: { success in
					self.soccerSpinner.removeFromSuperview()
					self.reloadCollection()
			})
			self.leagueCollectionView.refreshControl?.endRefreshing()
			
		}
	}
	
	@objc func refreshData() {
		leaguesDataSource.forceRefreshData()
	}
	
	func reloadCollection() {
		if self.leagueCollectionView.indexPathsForVisibleItems.count == 0 {
			var newCells: [IndexPath] = []
			for i in 0..<self.leaguesDataSource.leagues.count {
				newCells.append(IndexPath(item: i, section: 0))
			}
			self.leagueCollectionView.insertItems(at: newCells)
		}else{
			self.leagueCollectionView.reloadData()
		}
	}
}


