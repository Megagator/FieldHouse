//
//  BetterTableViewController.swift
//  FieldHouse Sports
//
//  Created by Mike Reinhard on 5/3/18.
//  Copyright © 2018 Mike Reinhard. All rights reserved.
//

import UIKit
import SafariServices

class BetterTableViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
	var betterTableCollectionView: UICollectionView!

	
	override func viewDidLoad() {
		title = "More"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.white]
		
		
		// add collection view
		let frame = self.view.frame
		let layout = UICollectionViewFlowLayout()
		betterTableCollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
		betterTableCollectionView.backgroundColor = Colors.exlightgrey
		self.view.addSubview(betterTableCollectionView)
		
		betterTableCollectionView.translatesAutoresizingMaskIntoConstraints = false
		betterTableCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
		betterTableCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
		betterTableCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
		betterTableCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
		
		betterTableCollectionView.register(LeagueViewCell.self, forCellWithReuseIdentifier: "more")
		
		betterTableCollectionView.dataSource = self
		betterTableCollectionView.delegate = self
		betterTableCollectionView.alwaysBounceVertical = true
		
		// setup the grid
		layout.scrollDirection = .vertical
//		layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
		//    layout.sectionHeadersPinToVisibleBounds = true
		layout.headerReferenceSize = CGSize(width: betterTableCollectionView.frame.width, height: 60)
		layout.itemSize = CGSize(width: betterTableCollectionView.frame.width, height: 54)
		layout.minimumInteritemSpacing = 0 // horizontal margin
		layout.minimumLineSpacing = 0 // vertical margin
		
		// pull to refresh
//        let refreshUI = UIRefreshControl()
//        refreshUI.addTarget(self, action: #selector( self.refreshData ), for: UIControlEvents.valueChanged)
//        betterTableCollectionView.refreshControl = refreshUI
		
	}
	
	override func didReceiveMemoryWarning() {
			super.didReceiveMemoryWarning()
			// Dispose of any resources that can be recreated.
	}
	
	// deslect a cell when returning to this view
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        //        navigationController?.navigationBar.prefersLargeTitles = true
//    }
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
			//        let teamsView = TeamsViewController()
			//        teamsView.title = leaguesDataSource.leagues[indexPath.row].attributes.name
			//        teamsView.leagueID = leaguesDataSource.leagues[indexPath.row].id
			//        navigationController?.pushViewController(teamsView, animated: true)
		
		
		
//        if indexPath.row == 0 {
//            newVC =
//        }else{
//
//        }
		
		let newVC = SFSafariViewController(url: URL(string: "http://fieldhousesports.com")!)
//		newVC.view.tintColor = Colors.newGreen
		newVC.preferredBarTintColor = .white
		newVC.preferredControlTintColor = Colors.newGreen
		
		present(newVC, animated: true)
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
	
	// Datasource delegate methods
    
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "more", for: indexPath) as! LeagueViewCell
			cell.name.text = "View the website"
			return cell
	}
	
}


