//
//  File.swift
//  FieldHouse Sports
//
//  Created by Mike Reinhard on 3/13/18.
//  Copyright © 2018 Mike Reinhard. All rights reserved.
//

import Foundation
import UIKit

final class Utilities {
	static let inputFormatter = DateFormatter()
	static let outputFormatter = DateFormatter()
	
	
	static func transform( date: String ) -> String {
		outputFormatter.locale = Locale.current
		
		inputFormatter.dateFormat = "yyyy-MM-dd"
		outputFormatter.dateFormat = "MMMM d, yyyy" // March 15, 2017
		
		if let newDate = inputFormatter.date(from: date) {
			let formatedDate = outputFormatter.string(from: newDate)
			return formatedDate
		}else{
			print("bad date given \(date)")
		}
		
		return "bad date"
	}
	
	// Match times
	static func transform( matchDate: String ) -> String {
		outputFormatter.locale = Locale.current
		
		inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		if is24Hour() {
			outputFormatter.dateFormat = "H:mm\nMMMM d" // March 15 17:30
		}else{
			outputFormatter.dateFormat = "h:mm a\nMMMM d" // March 15 5:30 AM
		}
		
		if let newDate = inputFormatter.date(from: matchDate) {
			let formatedDate = outputFormatter.string(from: newDate)
			return formatedDate
		}else{
			print("bad date given \(matchDate)")
		}
		
		return "bad date"
	}
	
	// Match times
	static func transform( notifyDate: String ) -> String {
		outputFormatter.locale = Locale.current
		
		inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		if is24Hour() {
			outputFormatter.dateFormat = "H:mm MMMM d" // March 15 at 17:30
		}else{
			outputFormatter.dateFormat = "h:mm MMMM d" // March 15 at 5:30 AM
		}
		
		if let newDate = inputFormatter.date(from: notifyDate) {
			let formatedDate = outputFormatter.string(from: newDate)
			return formatedDate
		}else{
			print("bad date given \(notifyDate)")
		}
		
		return "bad date"
	}
	
	private static func is24Hour() -> Bool {
		let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)!
		
		return dateFormat.index( of:"a") == nil
	}
	
	private static func daySuffix(from date: Date) -> String {
		let calendar = Calendar.current
		let dayOfMonth = calendar.component(.day, from: date)
		switch dayOfMonth {
			case 1, 21, 31: return "st"
			case 2, 22: return "nd"
			case 3, 23: return "rd"
			default: return "th"
		}
	}
	
	
	// Match utility functions
	static func calculateGameState( _ match: MatchAttrs ) -> String {
		if let homeScore = match.home_team_score, let awayScore = match.away_team_score {
			if homeScore > awayScore {
				return "defeated"
			} else if awayScore > homeScore {
				return "lost to"
			} else {
				return "tied with"
			}
		}else{
			return "VS"
		}
	}
	
	static func calculateConnectorColor(for match: MatchAttrs, respectiveTo teamID: String ) -> UIColor {
		var reversed = false
		if match.away_team_id == teamID {
			reversed = true
		}
		
		if let homeScore = match.home_team_score, let awayScore = match.away_team_score {
			if homeScore > awayScore {
				return reversed ? Colors.red : Colors.green
			} else if awayScore > homeScore {
				return reversed ? Colors.green : Colors.red
			} else {
				return Colors.grey
			}
		}else{
			return Colors.midgrey
		}
	}
	
	static func isFutureMatch(_ match: MatchAttrs ) -> Bool {
		return match.home_team_score == nil
	}
	
	// unused
	static func chechIfDaylight(_ time: String ) -> Bool {
		inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		outputFormatter.dateFormat = "H"
		
		if let hour = inputFormatter.date(from: time) {
			let formatedDate = outputFormatter.string(from: hour)
			let daytime = Int(formatedDate)! < 20
			print( formatedDate, daytime )
			return daytime
		}
		
		return false;
	}
	
}


class PaddedUILabel : UILabel {
	var textInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
		didSet { invalidateIntrinsicContentSize() }
	}
	
	override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
		let insetRect = bounds.inset(by: textInsets)
		let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
		let invertedInsets = UIEdgeInsets(top: -textInsets.top,
																			left: -textInsets.left,
																			bottom: -textInsets.bottom,
																			right: -textInsets.right)
		return textRect.inset(by: invertedInsets)
	}
	
	override func drawText(in rect: CGRect) {
		super.drawText(in: rect.inset(by: textInsets))
	}
}


// Single side borders
extension CALayer {
	func addPartialRowBorder(color: UIColor, thickness: CGFloat, xOffset: CGFloat) {
		let border = CALayer()
		border.frame = CGRect(x: xOffset, y: frame.height - thickness, width: frame.width, height: thickness)
		border.backgroundColor = color.cgColor;
		addSublayer(border)
	}
	
	func addLeftBorder(color: UIColor, thickness: CGFloat) {
		let border = CALayer()
		border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width / 2, height: thickness)
		border.backgroundColor = color.cgColor;
		addSublayer(border)
	}
	
	func addRightBorder(color: UIColor, thickness: CGFloat) {
		let border = CALayer()
		border.frame = CGRect(x: frame.width / 2, y: frame.height - thickness, width: frame.width / 2, height: thickness)
		border.backgroundColor = color.cgColor;
		addSublayer(border)
	}
}
