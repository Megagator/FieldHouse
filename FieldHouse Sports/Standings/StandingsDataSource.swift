//
//  SessionsDataSourceAndDelegate.swift
//  FieldHouse Sports
//
//  Created by Mike Reinhard on 3/10/18.
//  Copyright © 2018 Mike Reinhard. All rights reserved.
//

import UIKit

class StandingsDataSource: NSObject, UICollectionViewDataSource {
	var teams: [Team]
	var standings: [Standing]
	var leagueMatches: [Match]
	var futureLeagueMatches: [Match]
	let leagueID: String
	let tracksStandings: Bool
	
	
	init( _ leagueID: String, hasStandings: Bool ) {
		self.leagueID = leagueID
		self.tracksStandings = hasStandings
		self.teams = []
		self.standings = []
		self.leagueMatches = []
		self.futureLeagueMatches = []
		super.init()
		
		refreshData()
		preFetchLinkedData()
	}
	
	// Data methods
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "standingsReusableHeader", for: indexPath) as! StandingsCollectionReusableView
		
		//		headerView.backgroundColor = UIColor(white: 1.0, alpha: 0.9)
		
		let standingsHeader = PaddedUILabel()
		standingsHeader.translatesAutoresizingMaskIntoConstraints = false
		standingsHeader.textInsets = UIEdgeInsets(top: Padding.collections, left: Padding.collections, bottom: 0, right: Padding.collections)
		standingsHeader.textAlignment = .left
		standingsHeader.font = UIFont.systemFont(ofSize: 32, weight: .black)
		standingsHeader.textColor = Colors.grey
		
		switch indexPath.section {
		case 0:
			standingsHeader.text = "TEAMS"
		case 1:
			standingsHeader.text = "STANDINGS"
		case 2:
			standingsHeader.text = "MATCHES"
		case 3:
			standingsHeader.text = "UPCOMING MATCHES"
			standingsHeader.font = UIFont.systemFont(ofSize: 18, weight: .black)
		default:
			break
		}
		
		headerView.addSubview(standingsHeader)
		
		return headerView
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 4
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		switch section {
		case 0:
			return teams.count
		case 1:
			return standings.count
		case 2:
			return leagueMatches.count
		case 3:
			return futureLeagueMatches.count
		default:
			return 0
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		switch indexPath.section {
		case 0:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "standing", for: indexPath) as! StandingViewCell
			cell.standing.text = "•"
//			cell.standing.isHidden = true
			cell.teamName.text = teams[indexPath.row].attributes.name
			cell.teamRecord.text = ""
		
			return cell
		case 1:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "standing", for: indexPath) as! StandingViewCell
			cell.standing.text = String(standings[indexPath.row].standing) //+ getNumberPostfix( standings[indexPath.row].standing )
			cell.teamName.text = standings[indexPath.row].team_name
			cell.teamRecord.text = "(\( getTeamRecord(standings[indexPath.row]) ))"
			
			return cell
		case 2,3:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "match", for: indexPath) as! MatchViewCell
		
			var match: MatchAttrs
			if indexPath.section == 2 {
				match = leagueMatches[indexPath.row].attributes
			}else{
				match = futureLeagueMatches[indexPath.row].attributes
			}

			cell.homeTeam.text = match.home_team_name
//			if !displayScores {
				if let homeScore = match.home_team_score {
					cell.homeTeamScore.text = String(homeScore)
				}else{
					cell.homeTeamScore.text = ""
				}
//			}else{
//				cell.homeTeamScore.text = ""
//			}
			
			cell.awayTeam.text = match.away_team_name
//			if !displayScores {
				if let awayScore = match.away_team_score {
					cell.awayTeamScore.text = String(awayScore)
				}else{
					cell.awayTeamScore.text = ""
				}
//			}else{
//				cell.awayTeamScore.text = ""
//			}

			cell.connector.text = Utilities.calculateGameState( match )
			cell.connector.layer.backgroundColor = Colors.midgrey.cgColor
			
			cell.date.text = Utilities.transform( matchDate: match.start_time )
			cell.venue.text = match.venue
			cell.setBackground( match.venue )
			cell.futureMatch = Utilities.isFutureMatch( match )
			cell.star.isHidden = !cell.futureMatch
			
			return cell
		default:
			print("too many sections!")
			return UICollectionViewCell()
		}
	}

	func refreshData() {
		if tracksStandings {
			if let cachedStandings = Model.getStandings( leagueID ) {
				standings = cachedStandings
			}else{
				forceRefreshData()
				return
			}
		}else{
			if let cachedTeams = Model.getTeams( leagueID ) {
				teams = cachedTeams
			}else{
				forceRefreshData()
				return
			}
		}
		
		if let cachedLeagueMatches = Model.getLeagueMatches( leagueID ) {
			for match in cachedLeagueMatches {
				if match.attributes.home_team_score != nil {
					leagueMatches.append(match)
				}else{
					futureLeagueMatches.append(match)
				}
			}
		}else{
			forceRefreshData()
		}
	}


	func forceRefreshData() {
		if tracksStandings {
			API.instance.getStandings( leagueID, reference: self )
		}else{
			API.instance.getTeams( leagueID, reference: self )
		}
		API.instance.getLeagueMatches( leagueID, reference: self )
	}
	
	func preFetchLinkedData() {
		print("preemptive caching: standings(\(standings.count)), teams(\(teams.count))")
		for standing in standings {
			if Model.getMatches( String(standing.team_id) ) == nil {
				API.instance.getMatches( String(standing.team_id), reference: nil)
			}
		}
		
		for team in teams {
			if Model.getTeams( String(team.id) ) == nil {
				API.instance.getMatches( String(team.id), reference: nil)
			}
		}
	}
	
	func getTeamRecord(_ team: Standing) -> String {
		return "\(String(team.wins))-\(String(team.losses))-\(String(team.ties))"
	}
	
	func getNumberPostfix(_ number: Int ) -> String {
		switch number {
			case 11, 12, 13:
				return "th"
			default:
				switch (number % 10) {
					case 1:
						return "st"
					case 2:
						return "nd"
					case 3:
						return "rd"
					default:
						return "th"
				}
		}
	}
}
