//
//  API Structures.swift
//  FieldHouse Sports
//
//  Created by Mike Reinhard on 3/14/18.
//  Copyright © 2018 Mike Reinhard. All rights reserved.
//

import Foundation

// API Definition
struct FH_API: Codable {
	let id: Int
	let name: String
	let current: Int
	let supported: [Int]
}

// Sessions
struct Sessions_File: Codable {
	let createdTime: Date
	let dataType: String
	let payload: Sessions_Wrapper
}

struct Sessions_Wrapper: Codable {
	let data: [Session]
	//	let errors: [APIError]
}

struct Session: Codable {
	let type: String
	let id: String
	let attributes: SessionAttrs
	let links: Links?
}

struct SessionAttrs: Codable {
	let name: String
	let start: String
	let end: String
	let current: Bool
	let active: Bool
}



// Leagues
struct Leagues_File: Codable {
	let createdTime: Date
	let dataType: String
	let payload: Leagues_Wrapper
}

struct Leagues_Wrapper: Codable {
	let data: [League]
	//	let errors: [APIError]
}

struct League: Codable {
	let type: String
	let id: String
	let attributes: LeagueAttrs
	let links: Links?
}

struct LeagueAttrs: Codable {
	let name: String
	let start: String
	let end: String
	let sport: String
	let age_group: String
	let gender:	String
	let tracks_standings: Bool
	let has_playoffs: Bool
	let display_scores: Bool
	let session_id: String
	let active: Bool
}


// Standings
struct Standings_File: Codable {
	let createdTime: Date
	let dataType: String
	let payload: Standings_Wrapper
}

struct Standings_Wrapper: Codable {
	let data: Standing_Group
	//    let errors: [APIError]
}

struct Standing_Group: Codable {
	let type: String
	let id: String
	let attributes: Standings
	let links: Links?
}

struct Standings: Codable {
	let standings: [Standing]
}

struct Standing: Codable {
	let standing: Int
	let team_id: Int
	let team_name: String
	let team_short_name: String
	let wins: Int
	let losses: Int
	let ties: Int
	let pts_for: Int
	let pts_against: Int
	let total_points: Int
	let point_differential: Int
	let games: Int
}


// Teams
struct Teams_File: Codable {
	let createdTime: Date
	let dataType: String
	let payload: Teams_Wrapper
}

struct Teams_Wrapper: Codable {
	let data: [Team]
	//    let errors: [APIError]
}

struct Team: Codable {
	let type: String
	let id: String
	let attributes: TeamAttrs
	let links: Links?
}

struct TeamAttrs: Codable {
	let name: String
	let short_name: String
	let division_id: Int?
	let bye_team: Bool
	let display_scores: Bool
}



// Matches
struct Matches_File: Codable {
	let createdTime: Date
	let dataType: String
	var payload: Matches_Wrapper
}

struct Matches_Wrapper: Codable {
	var data: [Match]
	//    let errors: [APIError]
}

struct Match: Codable, Equatable {
	static func == (lhs: Match, rhs: Match) -> Bool {
		return lhs.id == rhs.id
	}
	
	let type: String
	let id: String
	let attributes: MatchAttrs
	let links: Links?
}

struct MatchAttrs: Codable {
	let home_team_id: String
	let home_team_name: String
	let home_team_short_name: String
	let home_team_score: Int?
	
	let away_team_id: String
	let away_team_name: String
	let away_team_short_name: String
	let away_team_score: Int?
	
	let start_time: String
	let venue: String
	
	// ad-hoc
	let isStarred: Bool?
}




// Shared
struct Links: Codable {
	let ownLink: String
	
	private enum CodingKeys: String, CodingKey {
		case ownLink = "self"
	}
}

//struct APIError: Codable {
//	let id: String
//	let title: String
//	let detail: String
//}


