//
//  SessionsDataSourceAndDelegate.swift
//  FieldHouse Sports
//
//  Created by Mike Reinhard on 3/10/18.
//  Copyright © 2018 Mike Reinhard. All rights reserved.
//

import UIKit

class LeaguesDataSource: NSObject, UICollectionViewDataSource {
	
	var leagues: [League]
	let sessionID: String
	
	init( _ sessionID: String ) {
		self.sessionID = sessionID
		leagues = []
		super.init()
		
		refreshData()
	}
	
	// Data methods
	// Data methods
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "leaguesReusableHeader", for: indexPath) as! LeaguesCollectionReusableView
		
		//		headerView.backgroundColor = UIColor(white: 1.0, alpha: 0.9)
		
		let leaguesHeader = PaddedUILabel()
		leaguesHeader.translatesAutoresizingMaskIntoConstraints = false
		leaguesHeader.textInsets = UIEdgeInsets(top: Padding.collections, left: Padding.collections, bottom: 0, right: Padding.collections)
		leaguesHeader.textAlignment = .left
		leaguesHeader.font = UIFont.systemFont(ofSize: 32, weight: .black)
		leaguesHeader.textColor = Colors.grey
		leaguesHeader.text = "LEAGUES"
		
		headerView.addSubview(leaguesHeader)
		
		return headerView
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return leagues.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "league", for: indexPath) as! LeagueViewCell
		cell.name.text = leagues[indexPath.row].attributes.name
		return cell
	}
	

	func refreshData() {
		if let cachedLeagues = Model.getLeagues( sessionID ) {
			leagues = cachedLeagues
		}else{
			forceRefreshData()
		}
	}
	
	func forceRefreshData() {
		API.instance.getLeagues( sessionID, reference: self)
	}
	
	
}
