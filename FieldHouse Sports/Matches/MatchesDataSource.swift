//
//  SessionsDataSourceAndDelegate.swift
//  FieldHouse Sports
//
//  Created by Mike Reinhard on 3/10/18.
//  Copyright © 2018 Mike Reinhard. All rights reserved.
//

import UIKit

class MatchesDataSource: NSObject, UICollectionViewDataSource {
	
	var completedMatches: [Match]
	var futureMatches: [Match]
	let teamID: String
	let teamRecord: String
	let displayScores: Bool
	
	init( id teamID: String, record: String, displayScores: Bool ) {
		self.teamID = teamID
		self.teamRecord = record
		self.displayScores = displayScores
		
		completedMatches = []
		futureMatches = []
		super.init()
		
		refreshData()
	}
	
	// Data methods
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 2
	}
	
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "matchesReusableHeader", for: indexPath) as! MatchesHeaderReusableview

//		headerView.backgroundColor = UIColor(white: 1.0, alpha: 0.9)
		
		let matchesHeader = PaddedUILabel()
		matchesHeader.translatesAutoresizingMaskIntoConstraints = false
		matchesHeader.textInsets = UIEdgeInsets(top: Padding.collections, left: Padding.collections, bottom: 0, right: Padding.collections)
		matchesHeader.textAlignment = .left
		matchesHeader.font = UIFont.systemFont(ofSize: 18, weight: .black)
		matchesHeader.textColor = Colors.grey
		
		if indexPath.section == 0 {
			if teamRecord == "" {
				matchesHeader.text = calculateTeamRecord()
			}else{
				matchesHeader.text = "RECORD: \(teamRecord)"
			}
		}else{
			matchesHeader.text = "UPCOMING MATCHES";
		}
		
		headerView.addSubview(matchesHeader)
		
		return headerView
	}

	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if section == 0 {
			return completedMatches.count
		}

		return futureMatches.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "match", for: indexPath) as! MatchViewCell
		
		var match: MatchAttrs
		if indexPath.section == 0 {
			match = completedMatches[indexPath.row].attributes
		}else{
			match = futureMatches[indexPath.row].attributes
		}
			
		cell.homeTeam.text = match.home_team_name
//		print("Match data: \(displayScores)")
		if !displayScores {
			if let homeScore = match.home_team_score {
				cell.homeTeamScore.text = String(homeScore)
			}else{
				cell.homeTeamScore.text = ""
			}
		}else{
			cell.homeTeamScore.text = ""
		}
		
		cell.awayTeam.text = match.away_team_name
		if !displayScores {
			if let awayScore = match.away_team_score {
				cell.awayTeamScore.text = String(awayScore)
			}else{
				cell.awayTeamScore.text = ""
			}
		}else{
			cell.awayTeamScore.text = ""
		}
		
		cell.connector.text = Utilities.calculateGameState( match )
		cell.connector.layer.backgroundColor = Utilities.calculateConnectorColor( for: match, respectiveTo: teamID ).cgColor
		
		cell.date.text = Utilities.transform( matchDate: match.start_time )
		cell.setBackground( match.venue )
		cell.venue.text = match.venue
		cell.futureMatch = Utilities.isFutureMatch( match )
		cell.star.isHidden = !cell.futureMatch
		
		return cell
	}

	func refreshData() {
		if let cachedMatches = Model.getMatches(teamID) {
			for match in cachedMatches {
				if match.attributes.home_team_score != nil {
					completedMatches.append(match)
				}else{
					futureMatches.append(match)
				}
			}
		}else{
			forceRefreshData()
		}
	}
	
	func forceRefreshData() {
		API.instance.getMatches( teamID, reference: self )
	}
	
	
	// unused (i think)
	func calculateTeamRecord() -> String {
		if completedMatches.count > 0 {
			var wins = 0, losses = 0, ties = 0
			
			for match in completedMatches {
				if let away = match.attributes.away_team_score,
					 let home = match.attributes.home_team_score  {
					if home > away {
						wins += 1
					}else if away > home {
						losses += 1
					}else{
						ties += 1
					}
				}
			}
			return "RECORD: \(wins)-\(losses)-\(ties)"
		}else{
			return "RECORD: 0-0-0"
		}
	}
}
