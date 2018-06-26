//
//  SessionViewCell.swift
//  FieldHouse Sports
//
//  Created by Mike Reinhard on 3/10/18.
//  Copyright © 2018 Mike Reinhard. All rights reserved.
//

import UIKit
import UserNotifications

class MatchViewCell: UICollectionViewCell {
	var background = UIImageView()
	var homeTeam = UILabel()
	var homeTeamScore = UILabel()
	var awayTeam = UILabel()
	var awayTeamScore = UILabel()
	var connector = PaddedUILabel()
	
	var date = UILabel()
	var venue = UILabel()
	var futureMatch = false
	
	let star = UIImageView()

	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	func commonInit() {
		contentView.layer.shadowColor = Colors.lightgrey.cgColor
		contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
		contentView.layer.shadowOpacity = 0.95
		contentView.layer.shadowRadius = 10.0

		let interiorView = UIView(frame: contentView.frame)
		interiorView.layer.cornerRadius = Radius.cells
		interiorView.layer.masksToBounds = true
//		interiorView.backgroundColor = Colors.midGreen
		
		background.frame = interiorView.bounds
		background.contentMode = .scaleAspectFill
		interiorView.addSubview(background)
		
		contentView.addSubview(interiorView)
		

		star.image = #imageLiteral(resourceName: "star_empty")
		star.contentMode = .center
		star.translatesAutoresizingMaskIntoConstraints = false
		interiorView.addSubview( star )
	
		
		homeTeam.translatesAutoresizingMaskIntoConstraints = false
		homeTeam.textAlignment = .left
		homeTeam.font = UIFont.systemFont(ofSize: 24, weight: .black)
		homeTeam.textColor = Colors.white
		homeTeam.numberOfLines = 3
		homeTeam.text = "Home"
		
		awayTeam.translatesAutoresizingMaskIntoConstraints = false
		awayTeam.textAlignment = .left
		awayTeam.font = UIFont.systemFont(ofSize: 24, weight: .black)
		awayTeam.textColor = Colors.white
		awayTeam.numberOfLines = 3
		awayTeam.text = "Away"
		
		connector.translatesAutoresizingMaskIntoConstraints = false
		connector.textInsets = UIEdgeInsets(top: 1.0, left: 6.0, bottom: 2.0, right: 6.0)
		connector.textAlignment = .left
		connector.font = UIFont.systemFont(ofSize: 14, weight: .bold)
		connector.layer.masksToBounds = true
		connector.layer.backgroundColor = Colors.lightgrey.cgColor
		connector.layer.cornerRadius = 6
		connector.textColor = Colors.white
		connector.text = "VS"
		
		homeTeamScore.translatesAutoresizingMaskIntoConstraints = false
		homeTeamScore.textAlignment = .right
		homeTeamScore.font = UIFont.systemFont(ofSize: 24, weight: .black)
		homeTeamScore.textColor = Colors.white
		homeTeamScore.numberOfLines = 1
		
		awayTeamScore.translatesAutoresizingMaskIntoConstraints = false
		awayTeamScore.textAlignment = .right
		awayTeamScore.font = UIFont.systemFont(ofSize: 24, weight: .black)
		awayTeamScore.textColor = Colors.white
		awayTeamScore.numberOfLines = 1
		
		interiorView.addSubview(homeTeamScore)
		interiorView.addSubview(awayTeamScore)
		
		
		date.translatesAutoresizingMaskIntoConstraints = false
		date.numberOfLines = 2
		date.textAlignment = .left
		date.font = UIFont.systemFont(ofSize: 16, weight: .bold)
		date.textColor = Colors.grey
		
		venue.translatesAutoresizingMaskIntoConstraints = false
		venue.textAlignment = .right
		venue.font = UIFont.systemFont(ofSize: 16, weight: .bold)
		venue.textColor = Colors.black

		let matchupStackView = UIStackView(arrangedSubviews: [homeTeam, connector, awayTeam])
		matchupStackView.translatesAutoresizingMaskIntoConstraints = false
		matchupStackView.axis = .vertical
		matchupStackView.distribution = .equalCentering
		matchupStackView.alignment = .leading
		matchupStackView.spacing = 5
//		matchupStackView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 100), for: .horizontal)

		let infoStackView = UIStackView(arrangedSubviews: [date, venue])
		infoStackView.translatesAutoresizingMaskIntoConstraints = false
		infoStackView.axis = .horizontal
		infoStackView.distribution = .fill
		infoStackView.alignment = .fill
		infoStackView.spacing = 5
//		infoStackView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 900), for: .horizontal)
		
		let infoWrapperView = UIView()
		infoWrapperView.translatesAutoresizingMaskIntoConstraints = false
		//		infoWrapperView.backgroundColor = Colors.white
		
		let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
		visualEffectView.frame = infoWrapperView.bounds
		visualEffectView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
		
		infoWrapperView.addSubview(visualEffectView)
		infoWrapperView.addSubview(infoStackView)
		
		interiorView.addSubview(matchupStackView)
		interiorView.addSubview(infoWrapperView)
		
		NSLayoutConstraint.activate([
			star.trailingAnchor.constraint(equalTo: interiorView.trailingAnchor, constant: -Padding.cells),
			star.topAnchor.constraint(equalTo: interiorView.topAnchor, constant: Padding.cells),
			
//			matchupStackView.widthAnchor.constraint(equalTo: interiorView.widthAnchor, constant: -(Padding.cells * 2)),
			matchupStackView.leadingAnchor.constraint(equalTo: interiorView.leadingAnchor, constant: Padding.cells),
			matchupStackView.trailingAnchor.constraint(equalTo: star.leadingAnchor, constant: -Padding.cells),
			matchupStackView.topAnchor.constraint(equalTo: interiorView.topAnchor, constant: Padding.cells ),
			matchupStackView.bottomAnchor.constraint(equalTo: infoWrapperView.topAnchor, constant: -Padding.cells),
			
			homeTeamScore.trailingAnchor.constraint(equalTo: interiorView.trailingAnchor, constant: -Padding.cells),
			homeTeamScore.topAnchor.constraint(equalTo: interiorView.topAnchor, constant: Padding.cells ),
			
			awayTeamScore.trailingAnchor.constraint(equalTo: interiorView.trailingAnchor, constant: -Padding.cells),
			awayTeamScore.bottomAnchor.constraint(equalTo: infoWrapperView.topAnchor, constant: -Padding.cells ),
			
			infoWrapperView.widthAnchor.constraint(equalTo: interiorView.widthAnchor),
			infoWrapperView.heightAnchor.constraint(equalTo: date.heightAnchor, constant: Padding.cells),
			infoWrapperView.leadingAnchor.constraint(equalTo: interiorView.leadingAnchor),
			infoWrapperView.bottomAnchor.constraint(equalTo: interiorView.bottomAnchor),

			infoStackView.widthAnchor.constraint(equalTo: infoWrapperView.widthAnchor, constant: -(Padding.cells*2)),
			infoStackView.leadingAnchor.constraint(equalTo: infoWrapperView.leadingAnchor, constant: Padding.cells),
			infoStackView.topAnchor.constraint(equalTo: infoWrapperView.topAnchor, constant: (Padding.cells/2) ),
		])
		
	}
	
	func setBackground(_ venue: String) {
		switch venue {
		case "Main":
			background.image = #imageLiteral(resourceName: "field_night")
		case "WestField":
			background.image = #imageLiteral(resourceName: "field_day")
		case "AnnexEastField":
			background.image = #imageLiteral(resourceName: "field_dusk")
		case "MultiField":
			background.image = #imageLiteral(resourceName: "field_midnight")
		case "Bow Gym":
			background.image = #imageLiteral(resourceName: "gym")
		default:
			print("MISING: \(venue)")
			background.image = #imageLiteral(resourceName: "field_midnight")
		}
	}
	
	func selectedItem(_ match: Match) {
		let generator = UIImpactFeedbackGenerator(style: .light)
		if futureMatch {
			generator.prepare()
		}
		
		UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
			self.contentView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
			self.contentView.layer.shadowRadius = 5.0
		}, completion: {(Bool) -> Void in
			if self.futureMatch {
				generator.impactOccurred()
				if self.star.image == #imageLiteral(resourceName: "star") {
					self.star.image = #imageLiteral(resourceName: "star_empty")
					Model.deleteFavoriteMatch( id: match.id)
				}else{
					self.star.image = #imageLiteral(resourceName: "star")
					Model.putFavoriteMatch(newFavorite: match)
					self.createMatchNotification( match )
				}
			}
		})
	}
	
	func setStarFilled() {
		star.image = #imageLiteral(resourceName: "star")
	}
	
	func deselectedItem() {
		UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
			self.contentView.transform = CGAffineTransform(scaleX: 1, y: 1)
			self.contentView.layer.shadowRadius = 10.0
		}, completion: nil)
	}
	
	
	func createMatchNotification(_ match: Match) {
		let notification = UNMutableNotificationContent()
		notification.title = "\(match.attributes.away_team_name) at \(match.attributes.home_team_name)"
		notification.subtitle = "\(Utilities.transform(notifyDate: match.attributes.start_time))"
		notification.body = "Location: \(match.attributes.venue)"
		
		let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
		let request = UNNotificationRequest(identifier: "notification1", content: notification, trigger: notificationTrigger)
		
		UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)

	}
}
