//
//  ViewController.swift
//  FieldHouse Sports
//
//  Created by Mike Reinhard on 3/10/18.
//  Copyright © 2018 Mike Reinhard. All rights reserved.
//

import UIKit

class TeamsViewController: UIViewController, UICollectionViewDelegate {
	var teamCollectionView: UICollectionView!
	var teamsDataSource: TeamsDataSource!
	var leagueID: String = ""

	let itemSpacing: CGFloat = 2 // points
	
	override func viewDidLoad() {
//		self.title = "Leagues"
		let backButton = UIBarButtonItem(
			title: "",
			style: .plain,
			target: nil,
			action: nil
		);
		
		navigationController?.navigationBar.topItem!.backBarButtonItem = backButton
		navigationController?.navigationBar.prefersLargeTitles = false
		// navigationController?.navigationBar.barStyle = .blackTranslucent;

		
		// add collection view
		let frame = self.view.frame
		let layout = UICollectionViewFlowLayout()
		teamCollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
		self.view.addSubview(teamCollectionView)
		
		teamCollectionView.translatesAutoresizingMaskIntoConstraints = false
		teamCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
		teamCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
		teamCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
		teamCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
		
		teamCollectionView.register(TeamViewCell.self, forCellWithReuseIdentifier: "team")
		
		teamsDataSource = TeamsDataSource( leagueID )
		teamCollectionView.dataSource = teamsDataSource
		teamCollectionView.delegate = self
		teamCollectionView.alwaysBounceVertical = true
		
		// setup the grid
		let size = UIScreen.main.bounds.size
		layout.scrollDirection = .vertical
		
		layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
		let width = size.width
		
		layout.itemSize = CGSize(width: width, height: 44)
		layout.minimumInteritemSpacing = itemSpacing
		layout.minimumLineSpacing = itemSpacing
		
		// pull to refresh
		let refreshUI = UIRefreshControl()
		refreshUI.addTarget(self, action: #selector( self.refreshData ), for: UIControl.Event.valueChanged)
		teamCollectionView.refreshControl = refreshUI

		// background color
		teamCollectionView.backgroundColor = Colors.blueGreen
		
		// data observer
		NotificationCenter.default.addObserver(self, selector: #selector(self.receivedNewData(notification:)), name: Notification.Name("NewTeamData"), object: nil)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// deslect a cell when returning to this view
	override func viewDidAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
//		navigationController?.navigationBar.prefersLargeTitles = true
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let matchView = MatchesViewController()
		matchView.title = teamsDataSource.teams[indexPath.row].attributes.name
		matchView.teamID = teamsDataSource.teams[indexPath.row].id
		navigationController?.pushViewController(matchView, animated: true)
	}
	
	func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		
	}
	

	@objc func receivedNewData(notification: Notification){
		DispatchQueue.main.async {
			if self.teamCollectionView.indexPathsForVisibleItems.count == 0 {
				var newCells: [IndexPath] = []
				for i in 0..<self.teamsDataSource.teams.count {
					newCells.append(IndexPath(item: i, section: 0))
				}
				self.teamCollectionView.insertItems(at: newCells)
			}else{
				self.teamCollectionView.reloadData()
			}
			self.teamCollectionView.refreshControl?.endRefreshing()
		}
	}
	
	@objc func refreshData() {
		teamsDataSource.refreshData()
	}
}


