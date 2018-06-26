//
//  API.swift
//  FieldHouse Sports
//
//  Created by Mike Reinhard on 3/12/18.
//  Copyright © 2018 Mike Reinhard. All rights reserved.
//

import Foundation

final class API {
	// Singleton instance
	static let instance = API()
	
	let baseURL = URL(string: "https://api.fieldhousesports.com/")!
	let session = URLSession.shared
	
	let decoder = JSONDecoder()
	
	var apiDef = FH_API(id: 0, name: "", current: 0, supported: [0])
	
	
	//: GET /
	func getAPIDefinition() {
		
		session.dataTask(with: baseURL) { data, response, error in
			if let error = error {
				print(error)
			}else if let data = data,
							 let response = response as? HTTPURLResponse,
									 response.statusCode == 200 {
				do {
					let description = try self.decoder.decode(FH_API.self, from: data)
					self.handle( description )
				}catch let decodeError as NSError {
					print(decodeError)
				}
			}else{
				print("Bad request: \(String(describing: error))")
			}
		}.resume()
	}
	
	func handle( _ apiDef: FH_API) {
		self.apiDef = apiDef
	}
	
	
	//: GET /sessions
	func getSessions( reference: SessionsDataSource ) {
		let url = URL(string: "sessions", relativeTo: baseURL)!
		
		session.dataTask(with: url) { data, response, error in
			print("GET /sessions")
			if let error = error {
				print(error)
			}else if let data = data,
				let response = response as? HTTPURLResponse,
				response.statusCode == 200 {
				do {
//					print( String(bytes: data, encoding: .utf8)! )
					let sessions = try self.decoder.decode(Sessions_Wrapper.self, from: data)
					self.handle( sessions, reference )
				}catch let decodeError as NSError {
					print(decodeError)
				}
			}else{
				print("Bad request: \(String(describing: error))")
			}
		}.resume()
	}
	
	func handle( _ sessions: Sessions_Wrapper, _ reference: SessionsDataSource) {
		reference.sessions = sessions.data
		Model.putSessions( newSessions: sessions.data )
		NotificationCenter.default.post(name: Notification.Name("NewSessionData"), object: nil)
	}
	
	
	//: GET /sessions/{sessionId}/leagues
	func getLeagues( _ sessionID: String, reference: LeaguesDataSource ) {
		let location = "/sessions/\(sessionID)/leagues"
		let url = URL(string: location, relativeTo: baseURL)!
		
		session.dataTask(with: url) { data, response, error in
			print("GET \(location)")
			if let error = error {
				print(error)
			}else if let data = data,
				let response = response as? HTTPURLResponse,
				response.statusCode == 200 {
				do {
					let leagues = try self.decoder.decode(Leagues_Wrapper.self, from: data)
					self.handle( leagues, reference )
				}catch let decodeError as NSError {
					print(decodeError)
				}
			}else{
				print("Bad request: \(String(describing: error))")
			}
		}.resume()
	}
	
	func handle( _ leagues: Leagues_Wrapper, _ reference: LeaguesDataSource) {
		reference.leagues = leagues.data
		Model.putLeagues( String(leagues.data[0].attributes.session_id), newLeagues: leagues.data)
		NotificationCenter.default.post(name: Notification.Name("NewLeagueData"), object: nil)
	}
	
	//: GET /leagues/{leagueId}/teams
	func getTeams( _ leagueID: String, reference: TeamsDataSource ) {
		let location = "/leagues/\(leagueID)/teams"
		let url = URL(string: location, relativeTo: baseURL)!
		
		session.dataTask(with: url) { data, response, error in
			print("GET \(location)")
			if let error = error {
				print(error)
			}else if let data = data,
				let response = response as? HTTPURLResponse,
				response.statusCode == 200 {
				do {
					let teams = try self.decoder.decode(Teams_Wrapper.self, from: data)
					self.handle( teams, leagueID, reference )
				}catch let decodeError as NSError {
					print(decodeError)
				}
			}else{
				print("Bad request: \(String(describing: error))")
			}
		}.resume()
	}
	
	func handle( _ teams: Teams_Wrapper, _ leagueID: String, _ reference: TeamsDataSource) {
		reference.teams = teams.data
		Model.putTeams( leagueID, newTeams: teams.data )
		NotificationCenter.default.post(name: Notification.Name("NewTeamData"), object: nil)
	}
	//: GET /leagues/{leagueId}/teams
	func getTeams( _ leagueID: String, reference: StandingsDataSource? ) {
		let location = "/leagues/\(leagueID)/teams"
		let url = URL(string: location, relativeTo: baseURL)!
		
		session.dataTask(with: url) { data, response, error in
			print("GET \(location)")
			if let error = error {
				print(error)
			}else if let data = data,
				let response = response as? HTTPURLResponse,
				response.statusCode == 200 {
				do {
					let teams = try self.decoder.decode(Teams_Wrapper.self, from: data)
					if let ref = reference {
						self.handle( teams, leagueID, ref )
					}else{
						self.handleCache( teams, leagueID )
					}
				}catch let decodeError as NSError {
					print(decodeError)
				}
			}else{
				print("Bad request: \(String(describing: error))")
			}
			}.resume()
	}
	
	func handleCache( _ teams: Teams_Wrapper, _ leagueID: String) {
		Model.putTeams( leagueID, newTeams: teams.data )
	}
	
	func handle( _ teams: Teams_Wrapper, _ leagueID: String, _ reference: StandingsDataSource) {
		reference.teams = teams.data
		Model.putTeams( leagueID, newTeams: teams.data )
		NotificationCenter.default.post(name: Notification.Name("NewStandingsTeamData"), object: nil)
	}
	
	//: GET /standings/{leagueId}/
	func getStandings( _ leagueID: String, reference: StandingsDataSource ) {
		let location = "/standings/\(leagueID)"
		let url = URL(string: location, relativeTo: baseURL)!
		
		session.dataTask(with: url) { data, response, error in
			print("GET \(location)")
			if let error = error {
				print(error)
			}else if let data = data,
				let response = response as? HTTPURLResponse,
				response.statusCode == 200 {
				do {
					let standings = try self.decoder.decode(Standings_Wrapper.self, from: data)
					self.handle( standings, leagueID, reference )
				}catch let decodeError as NSError {
					print(decodeError)
				}
			}else{
				print("Bad request: \(String(describing: error))")
			}
		}.resume()
	}
	
	func handle( _ standings: Standings_Wrapper, _ leagueID: String, _ reference: StandingsDataSource) {
		reference.standings = standings.data.attributes.standings
		Model.putStandings(leagueID, newStandings: standings.data)
		NotificationCenter.default.post(name: Notification.Name("NewStandingsData"), object: nil)
	}

	//: GET /teams/{teamId}/matches
	func getMatches( _ teamID: String, reference: MatchesDataSource? ) {
		let location = "/teams/\(teamID)/matches"
		let url = URL(string: location, relativeTo: baseURL)!
		
		session.dataTask(with: url) { data, response, error in
			print("GET \(location)")
			if let error = error {
				print(error)
			}else if let data = data,
				let response = response as? HTTPURLResponse,
				response.statusCode == 200 {
				do {
					let matches = try self.decoder.decode(Matches_Wrapper.self, from: data)
					if let ref = reference {
						self.handle( matches, teamID, ref)
					}else{
						self.handleCache( matches, teamID )
					}
				}catch let decodeError as NSError {
					print(decodeError)
				}
			}else{
				print("Bad request: \(String(describing: error))")
			}
		}.resume()
	}
	
	func handleCache(_ matches: Matches_Wrapper, _ teamID: String) {
		Model.putMatches(teamID, newMatches: matches.data)
	}
	
	func handle( _ matches: Matches_Wrapper, _ teamID: String, _ reference: MatchesDataSource) {
		for match in matches.data {
			if match.attributes.home_team_score != nil {
				reference.completedMatches.append(match)
			}else{
				reference.futureMatches.append(match)
			}
		}
		Model.putMatches(teamID, newMatches: matches.data)
		NotificationCenter.default.post(name: Notification.Name("NewMatchData"), object: nil)
	}

	
	//: GET /leagues/{leagueId}/matches
	func getLeagueMatches( _ leagueID: String, reference: StandingsDataSource ) {
		let location = "/leagues/\(leagueID)/matches"
		let url = URL(string: location, relativeTo: baseURL)!
		
		session.dataTask(with: url) { data, response, error in
			print("GET \(location)")
			if let error = error {
				print(error)
			}else if let data = data,
				let response = response as? HTTPURLResponse,
				response.statusCode == 200 {
				do {
					let matches = try self.decoder.decode(Matches_Wrapper.self, from: data)
					self.handle( matches, leagueID, reference )
				}catch let decodeError as NSError {
					print(decodeError)
				}
			}else{
				print("Bad request: \(String(describing: error))")
			}
		}.resume()
	}
	
	func handle( _ matches: Matches_Wrapper, _ leagueID: String, _ reference: StandingsDataSource) {
		for match in matches.data {
			if match.attributes.home_team_score != nil {
				reference.leagueMatches.append(match)
			}else{
				reference.futureLeagueMatches.append(match)
			}
		}
		Model.putLeagueMatches(leagueID, newMatches: matches.data)
		NotificationCenter.default.post(name: Notification.Name("NewLeagueMatchData"), object: nil)
	}
	
}
