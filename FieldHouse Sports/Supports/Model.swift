//
//  Model.swift
//  FieldHouse Sports
//
//  Created by Mike Reinhard on 4/19/18.
//  Copyright © 2018 Mike Reinhard. All rights reserved.
//

import Foundation

final class Model {
//	 Singleton instance
//	static let instance = Model()
	
	static func getSessions() -> [Session]? {
		let file = "sessions.json"
		
		if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			let fileURL = dir.appendingPathComponent(file)
			let currentData: Data
			
			//reading
			do {
				currentData = try Data(contentsOf: fileURL)
			} catch {
				print("missing file: \(file), creating now...")
				try! Data().write(to: fileURL)
				return nil
			}
			
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .iso8601

			let sessionJson: [String: Sessions_File]
			do {
				sessionJson = try decoder.decode([String: Sessions_File].self, from: currentData)
			} catch {
				print("error decoding \(fileURL)")
				return nil
			}
			
			let request = "/sessions"
			if let result = sessionJson[request] {
				if isFreshData( result.createdTime, stale: 86400.0 ) {
					return result.payload.data
				}
			}
		}
		
		return nil
	}
	
	static func putSessions( newSessions: [Session]) {
		let file = "sessions.json"
		
		if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			let fileURL = dir.appendingPathComponent(file)
			let currentData: Data
			
			//reading
			do {
				currentData = try Data(contentsOf: fileURL)
			} catch {
				print("error reading \(fileURL)")
				return
			}
			
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .iso8601
			
			let request = "/sessions"
			var sessionJson: [String: Sessions_File]
			// decoding
			do {
				sessionJson = try decoder.decode([String: Sessions_File].self, from: currentData)
			} catch {
				print("error decoding, empty file?")
				sessionJson = [request: Sessions_File(createdTime: Date(), dataType: "sessions", payload: Sessions_Wrapper(data: []))]
			}
			
			// update data
			sessionJson[request] = Sessions_File(createdTime: Date(), dataType: "sessions", payload: Sessions_Wrapper(data: newSessions))
			
			// encoding
			let newData: Data
			let encoder = JSONEncoder()
			encoder.dateEncodingStrategy = .iso8601
			do {
				newData = try encoder.encode(sessionJson)
			} catch {
				print("error encoding:\n \(dump(sessionJson))")
				return
			}
			
			// writing
			do {
				try newData.write(to: fileURL)
			} catch {
				print("error writing to \(fileURL)")
			}
			print("wrote new session data to file: \(file)")
		}
	}
	
	static func getLeagues(_ sessionID: String ) -> [League]? {
		let file = "leagues.json"
		
		if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			let fileURL = dir.appendingPathComponent(file)
			let currentData: Data
			
			//reading
			do {
				currentData = try Data(contentsOf: fileURL)
			} catch {
				print("missing file: \(file), creating now...")
				try! Data().write(to: fileURL)
				return nil
			}
			
			// decode
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .iso8601
			
			let leaguesJson: [String: Leagues_File]
			do {
				leaguesJson = try decoder.decode([String: Leagues_File].self, from: currentData)
			} catch {
				print("error decoding \(fileURL)")
				return nil
			}
			
			let request = "/sessions/\(sessionID)/leagues"
			if let result = leaguesJson[request] {
				if isFreshData( result.createdTime, stale: 3600.0 ) {
					return result.payload.data
				}
			}else{
				print("request (\(request)) not found in cache")
			}
		}
		
		return nil
	}
	
	
	static func putLeagues(_ sessionID: String, newLeagues: [League]) {
		let file = "leagues.json"
		
		if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			let fileURL = dir.appendingPathComponent(file)
			let currentData: Data
			
			//reading
			do {
				currentData = try Data(contentsOf: fileURL)
			} catch {
				print("error reading \(fileURL)")
				return
			}
			
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .iso8601
			
			// decoding
			var leaguesJson: [String: Leagues_File]
			let request = "/sessions/\(sessionID)/leagues"
			do {
				leaguesJson = try decoder.decode([String: Leagues_File].self, from: currentData)
			} catch {
				print("error decoding, empty file?")
				leaguesJson = [request: Leagues_File(createdTime: Date(), dataType: "leagues", payload: Leagues_Wrapper(data: []))]
			}
			
			// update data
			leaguesJson[request] = Leagues_File(createdTime: Date(), dataType: "sessions", payload: Leagues_Wrapper(data: newLeagues))
			
			// encoding
			let newData: Data
			let encoder = JSONEncoder()
			encoder.dateEncodingStrategy = .iso8601
			do {
				newData = try encoder.encode(leaguesJson)
			} catch {
				print("error encoding:\n \(dump(leaguesJson))")
				return
			}
			
			// writing
			do {
				try newData.write(to: fileURL)
			} catch {
				print("error writing to \(fileURL)")
			}
			print("wrote new league data to file: \(file)")
		}
	}
	
	static func getTeams(_ leagueID: String ) -> [Team]? {
		let file = "teams.json"
		
		if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			let fileURL = dir.appendingPathComponent(file)
			let currentData: Data
			
			//reading
			do {
				currentData = try Data(contentsOf: fileURL)
			} catch {
				print("missing file: \(file), creating now...")
				try! Data().write(to: fileURL)
				return nil
			}
			
			//decode
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .iso8601

			let teamsJson: [String: Teams_File]

			do {
				teamsJson = try decoder.decode([String: Teams_File].self, from: currentData)
			} catch {
				print("error decoding \(fileURL)")
				return nil
			}
			
			let request = "/leagues/\(leagueID)/teams"
			if let result = teamsJson[request] {
				if isFreshData( result.createdTime, stale: 3600.0 ) {
					return result.payload.data
				}
			}else{
				print("request (\(request)) not found in cache")
			}
		}
		
		return nil
	}
	
	static func putTeams(_ leagueID: String, newTeams: [Team]) {
		let file = "teams.json"
		
		if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			let fileURL = dir.appendingPathComponent(file)
			let currentData: Data
			
			//reading
			do {
				currentData = try Data(contentsOf: fileURL)
			} catch {
				print("error reading \(fileURL)")
				return
			}
			
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .iso8601
			
			// decoding
			var teamsJson: [String: Teams_File]
			let request = "/leagues/\(leagueID)/teams"
			do {
				teamsJson = try decoder.decode([String: Teams_File].self, from: currentData)
			} catch {
				print("error decoding, empty file?")
				teamsJson = [request: Teams_File(createdTime: Date(), dataType: "teams", payload: Teams_Wrapper(data: []))]
			}
			
			// update data
			teamsJson[request] = Teams_File(createdTime: Date(), dataType: "teams", payload: Teams_Wrapper(data: newTeams))
			
			// encoding
			let newData: Data
			let encoder = JSONEncoder()
			encoder.dateEncodingStrategy = .iso8601
			do {
				newData = try encoder.encode(teamsJson)
			} catch {
				print("error encoding:\n \(dump(teamsJson))")
				return
			}
			
			// writing
			do {
				try newData.write(to: fileURL)
			} catch {
				print("error writing to \(fileURL)")
			}
			print("wrote new team data to file: \(file)")
		}
	}
	
	static func getStandings(_ leagueID: String ) -> [Standing]? {
		let file = "standings.json"
		
		if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			let fileURL = dir.appendingPathComponent(file)
			let currentData: Data
			
			//reading
			do {
				currentData = try Data(contentsOf: fileURL)
			} catch {
				print("missing file: \(file), creating now...")
				try! Data().write(to: fileURL)
				return nil
			}
			
			//decode
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .iso8601
			
			let standingsJson: [String: Standings_File]
			
			do {
				standingsJson = try decoder.decode([String: Standings_File].self, from: currentData)
			} catch {
				print("error decoding \(fileURL)")
				return nil
			}
			
			let request = "/standings/\(leagueID)"
			if let result = standingsJson[request] {
				if isFreshData( result.createdTime, stale: 3600.0 ) {
					return result.payload.data.attributes.standings
				}
			}else{
				print("request (\(request)) not found in cache")
			}
		}
		
		return nil
	}
	
	static func putStandings(_ leagueID: String, newStandings: Standing_Group) {
		let file = "standings.json"
		
		if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			let fileURL = dir.appendingPathComponent(file)
			let currentData: Data
			
			//reading
			do {
				currentData = try Data(contentsOf: fileURL)
			} catch {
				print("error reading \(fileURL)")
				return
			}
			
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .iso8601
			
			// decoding
			var standingsJson: [String: Standings_File]
			let request = "/standings/\(leagueID)"
			do {
				standingsJson = try decoder.decode([String: Standings_File].self, from: currentData)
			} catch {
				print("error decoding, empty file?")
				standingsJson = [request: Standings_File(createdTime: Date(), dataType: "standings", payload: Standings_Wrapper(data:Standing_Group(type: "", id: "", attributes: Standings(standings: []), links: nil)))]
			}
			
			// update data
			standingsJson[request] = Standings_File(createdTime: Date(), dataType: "standings", payload: Standings_Wrapper(data: newStandings) )
			
			// encoding
			let newData: Data
			let encoder = JSONEncoder()
			encoder.dateEncodingStrategy = .iso8601
			do {
				newData = try encoder.encode(standingsJson)
			} catch {
				print("error encoding:\n \(dump(standingsJson))")
				return
			}
			
			// writing
			do {
				try newData.write(to: fileURL)
			} catch {
				print("error writing to \(fileURL)")
			}
			print("wrote new standings data to file: \(file)")
		}
	}
	

	static func getMatches(_ teamID: String ) -> [Match]? {
		let file = "matches.json"
		
		if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			let fileURL = dir.appendingPathComponent(file)
			let currentData: Data
			
			//reading
			do {
				currentData = try Data(contentsOf: fileURL)
			} catch {
				print("missing file: \(file), creating now...")
				try! Data().write(to: fileURL)
				return nil
			}
			
			//decode
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .iso8601
			
			let matchesJson: [String: Matches_File]
			
			do {
				matchesJson = try decoder.decode([String: Matches_File].self, from: currentData)
			} catch {
				print("error decoding \(fileURL)")
				return nil
			}
			
			let request = "/teams/\(teamID)/matches"
			if let result = matchesJson[request] {
				if isFreshData( result.createdTime, stale: 3600.0 ) {
					return result.payload.data
				}
			}else{
				print("request (\(request)) not found in cache")
			}
		}
		
		return nil
	}
	
	static func putMatches(_ teamID: String, newMatches: [Match]) {
		let file = "matches.json"
		
		if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			let fileURL = dir.appendingPathComponent(file)
			let currentData: Data
			
			//reading
			do {
				currentData = try Data(contentsOf: fileURL)
			} catch {
				print("error reading \(fileURL)")
				return
			}
			
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .iso8601
			
			// decoding
			var matchesJson: [String: Matches_File]
			let request = "/teams/\(teamID)/matches"
			do {
				matchesJson = try decoder.decode([String: Matches_File].self, from: currentData)
			} catch {
				print("error decoding, empty file?")
				matchesJson = [request: Matches_File(createdTime: Date(), dataType: "match", payload: Matches_Wrapper(data: []))]
			}
			
			// update data
			matchesJson[request] = Matches_File(createdTime: Date(), dataType: "match", payload: Matches_Wrapper(data: newMatches) )
			
			// encoding
			let newData: Data
			let encoder = JSONEncoder()
			encoder.dateEncodingStrategy = .iso8601
			do {
				newData = try encoder.encode(matchesJson)
			} catch {
				print("error encoding:\n \(dump(matchesJson))")
				return
			}
			
			// writing
			do {
				try newData.write(to: fileURL)
			} catch {
				print("error writing to \(fileURL)")
			}
			print("wrote new match data to file: \(file)")
		}
	}
	
	static func getFavoriteMatches() -> [Match]? {
		let file = "favorites.json"
		
		if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			let fileURL = dir.appendingPathComponent(file)
			let currentData: Data
			
			//reading
			do {
				currentData = try Data(contentsOf: fileURL)
			} catch {
				print("missing file: \(file), creating now...")
				try! Data().write(to: fileURL)
				return nil
			}
			
			//decode
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .iso8601
			
			let matchesJson: [String: Matches_File]
			
			do {
				matchesJson = try decoder.decode([String: Matches_File].self, from: currentData)
			} catch {
				print("error decoding \(fileURL)")
				return nil
			}
			
			let request = "favorites"
			if let result = matchesJson[request] {
				return result.payload.data
			}else{
				print("no favorites on file")
			}
		}
		
		return nil
	}
	
	static func putFavoriteMatch(newFavorite: Match) {
		let file = "favorites.json"
		
		if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			let fileURL = dir.appendingPathComponent(file)
			let currentData: Data
			
			//reading
			do {
				currentData = try Data(contentsOf: fileURL)
			} catch {
				print("error reading \(fileURL), try creating:")
				try! Data().write(to: fileURL)
				currentData = Data()
			}
			
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .iso8601
			
			// decoding
			var matchesJson: [String: Matches_File]
			let request = "favorites"
			do {
				matchesJson = try decoder.decode([String: Matches_File].self, from: currentData)
			} catch {
				print("error decoding, empty file?")
				matchesJson = [request: Matches_File(createdTime: Date(), dataType: "match", payload: Matches_Wrapper(data: []))]
			}
			
			// update data
			matchesJson[request]?.payload.data.append(newFavorite);
			
			// encoding
			let newData: Data
			let encoder = JSONEncoder()
			encoder.dateEncodingStrategy = .iso8601
			do {
				newData = try encoder.encode(matchesJson)
			} catch {
				print("error encoding:\n \(dump(matchesJson))")
				return
			}
			
			// writing
			do {
				try newData.write(to: fileURL)
			} catch {
				print("error writing to \(fileURL)")
			}
			print("wrote new match data to file: \(file)")
		}
	}
	
	static func deleteFavoriteMatch( id: String) {
		let file = "favorites.json"
		
		if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			let fileURL = dir.appendingPathComponent(file)
			let currentData: Data
			
			//reading
			do {
				currentData = try Data(contentsOf: fileURL)
			} catch {
				print("error reading \(fileURL), try creating:")
				try! Data().write(to: fileURL)
				currentData = Data()
			}
			
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .iso8601
			
			// decoding
			var matchesJson: [String: Matches_File]
			let request = "favorites"
			do {
				matchesJson = try decoder.decode([String: Matches_File].self, from: currentData)
			} catch {
				print("error decoding, empty file?")
				matchesJson = [request: Matches_File(createdTime: Date(), dataType: "match", payload: Matches_Wrapper(data: []))]
			}
			
			// update data
			for match in matchesJson[request]!.payload.data {
				if match.id == id {
					matchesJson[request]!.payload.data.index(of: match).map {
						matchesJson[request]!.payload.data.remove(at: $0)
					}
				}
			}
			
			// encoding
			let newData: Data
			let encoder = JSONEncoder()
			encoder.dateEncodingStrategy = .iso8601
			do {
				newData = try encoder.encode(matchesJson)
			} catch {
				print("error encoding:\n \(dump(matchesJson))")
				return
			}
			
			// writing
			do {
				try newData.write(to: fileURL)
			} catch {
				print("error writing to \(fileURL)")
			}
			print("wrote new match data to file: \(file)")
		}
	}
	
	
	static func getLeagueMatches(_ leagueID: String ) -> [Match]? {
		let file = "leagueMatches.json"
		
		if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			let fileURL = dir.appendingPathComponent(file)
			let currentData: Data
			
			//reading
			do {
				currentData = try Data(contentsOf: fileURL)
			} catch {
				print("missing file: \(file), creating now...")
				try! Data().write(to: fileURL)
				return nil
			}
			
			//decode
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .iso8601
			
			let leagueMatchesJson: [String: Matches_File]
			
			do {
				leagueMatchesJson = try decoder.decode([String: Matches_File].self, from: currentData)
			} catch {
				print("error decoding \(fileURL)")
				return nil
			}
			
			let request = "/leagues/\(leagueID)/matches"
			if let result = leagueMatchesJson[request] {
				if isFreshData( result.createdTime, stale: 3600.0 ) {
					return result.payload.data
				}
			}else{
				print("request (\(request)) not found in cache")
			}
		}
		
		return nil
	}
	
	static func putLeagueMatches(_ leagueID: String, newMatches: [Match]) {
		let file = "leagueMatches.json"
		
		if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			let fileURL = dir.appendingPathComponent(file)
			let currentData: Data
			
			//reading
			do {
				currentData = try Data(contentsOf: fileURL)
			} catch {
				print("error reading \(fileURL)")
				return
			}
			
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .iso8601
			
			// decoding
			var leagueMatchesJson: [String: Matches_File]
			let request = "/leagues/\(leagueID)/matches"
			do {
				leagueMatchesJson = try decoder.decode([String: Matches_File].self, from: currentData)
			} catch {
				print("error decoding, empty file?")
				leagueMatchesJson = [request: Matches_File(createdTime: Date(), dataType: "league_match", payload: Matches_Wrapper(data: []))]
			}
			
			// update data
			leagueMatchesJson[request] = Matches_File(createdTime: Date(), dataType: "league_match", payload: Matches_Wrapper(data: newMatches) )
			
			// encoding
			let newData: Data
			let encoder = JSONEncoder()
			encoder.dateEncodingStrategy = .iso8601
			do {
				newData = try encoder.encode(leagueMatchesJson)
			} catch {
				print("error encoding:\n \(dump(leagueMatchesJson))")
				return
			}
			
			// writing
			do {
				try newData.write(to: fileURL)
			} catch {
				print("error writing to \(fileURL)")
			}
			print("wrote new league match data to file: \(file)")
		}
	}
	
	
	// utillities funcs
	
	static func isFreshData(_ time: Date, stale: Double) -> Bool {
		let currentTime = Date()
		let timeDifference = currentTime.timeIntervalSinceReferenceDate - time.timeIntervalSinceReferenceDate
		
		print("last cache date: \(time)");
		print("current time diff: \(timeDifference)")
		return timeDifference < stale // discard data after stale date
	}
	
}

