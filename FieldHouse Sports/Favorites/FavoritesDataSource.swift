//
//  SessionsDataSourceAndDelegate.swift
//  FieldHouse Sports
//
//  Created by Mike Reinhard on 3/10/18.
//  Copyright © 2018 Mike Reinhard. All rights reserved.
//

import UIKit

class FavoritesDataSource: NSObject, UICollectionViewDataSource {
	
	var matches: [Match]
	
	override init() {
		matches = []
		super.init()
		
		refreshData()
	}
	
	// Data methods
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return matches.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "match", for: indexPath) as! MatchViewCell
		
		let match = matches[indexPath.row].attributes
			
		cell.futureMatch = Utilities.isFutureMatch( match )
		cell.homeTeam.text = match.home_team_name
		
		cell.connector.text = Utilities.calculateGameState( match )
		cell.connector.layer.backgroundColor = Colors.grey.cgColor
		
		cell.date.text = Utilities.transform( matchDate: match.start_time )
		cell.setBackground( match.venue )
		cell.venue.text = match.venue
		cell.star.isHidden = !cell.futureMatch
		cell.setStarFilled()
		
		return cell
	}

	func refreshData() {
		if let favMatches = Model.getFavoriteMatches() {
			matches = favMatches
		}
	}

}
