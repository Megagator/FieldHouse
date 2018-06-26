//
//  SessionsDataSourceAndDelegate.swift
//  FieldHouse Sports
//
//  Created by Mike Reinhard on 3/10/18.
//  Copyright © 2018 Mike Reinhard. All rights reserved.
//

import UIKit

class TeamsDataSource: NSObject, UICollectionViewDataSource {
	
	var teams: [Team]
	let leagueID: String
	
	init( _ leagueID: String ) {
		self.leagueID = leagueID
		teams = []
		super.init()
		
		refreshData()
	}
	
	// Data methods
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return teams.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "team", for: indexPath) as! TeamViewCell
		cell.label.text = teams[indexPath.row].attributes.name
		return cell
	}

	func refreshData() {
		API.instance.getTeams( leagueID, reference: self )
	}
	
}
