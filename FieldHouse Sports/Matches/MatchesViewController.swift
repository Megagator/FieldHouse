//
//  ViewController.swift
//  FieldHouse Sports
//
//  Created by Mike Reinhard on 3/10/18.
//  Copyright © 2018 Mike Reinhard. All rights reserved.
//

import UIKit
import UserNotifications


class MatchesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	var matchCollectionView: UICollectionView!
	var matchesDataSource: MatchesDataSource!
	var teamID: String = ""
	var teamRecord: String = ""
	var currentButton: UIBarButtonItem!
	var displayScores: Bool = false
	
	let soccerSpinner = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
	
	override func viewDidLoad() {
		let backButton = UIBarButtonItem(
			title: "",
			style: .plain,
			target: nil,
			action: nil
		);
		
//		print("Match view: \(displayScores)")
		
		currentButton = UIBarButtonItem(image: #imageLiteral(resourceName: "calendar"), style: .done, target: self, action: #selector(scrollToUpcomingMatches))
		navigationItem.rightBarButtonItem = currentButton
		
		navigationController?.navigationBar.topItem!.backBarButtonItem = backButton
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.white]
		
		// navigationController?.navigationBar.barStyle = .blackTranslucent;

		matchesDataSource = MatchesDataSource( id: teamID, record: teamRecord, displayScores: displayScores )
		
		if matchesDataSource.futureMatches.count == 0 {
			currentButton.isEnabled = false
		}
		
//		self.view.addSubview(teamRecord)
		
		// add collection view
		let frame = self.view.frame
		let layout = UICollectionViewFlowLayout()
		matchCollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)

		self.view.addSubview(matchCollectionView)

		matchCollectionView.translatesAutoresizingMaskIntoConstraints = false
		matchCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
		matchCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
		matchCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
		matchCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
		
		matchCollectionView.register(MatchViewCell.self, forCellWithReuseIdentifier: "match")
		matchCollectionView.register(MatchesHeaderReusableview.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "matchesReusableHeader")
		matchCollectionView.dataSource = matchesDataSource
		matchCollectionView.delegate = self
		matchCollectionView.alwaysBounceVertical = true
		
		// setup the grid
		layout.scrollDirection = .vertical
//		layout.sectionHeadersPinToVisibleBounds = true
		layout.headerReferenceSize = CGSize(width: matchCollectionView.frame.width, height: Grid.rowHeight)
		layout.sectionInset = UIEdgeInsets.init(top: 0, left: Padding.collections, bottom: Padding.collections, right: Padding.collections)
		layout.itemSize = CGSize(width: (matchCollectionView.frame.width - (Padding.collections * 2)), height: Grid.cellHeight)
		layout.minimumInteritemSpacing = Padding.collections // horizontal margin
		layout.minimumLineSpacing = Padding.collections // vertical margin
		
		// pull to refresh
		let refreshUI = UIRefreshControl()
		refreshUI.addTarget(self, action: #selector( self.refreshData ), for: UIControl.Event.valueChanged)
		matchCollectionView.refreshControl = refreshUI

		// background color
		matchCollectionView.backgroundColor = Colors.white
		
		// data observer
		NotificationCenter.default.addObserver(self, selector: #selector(self.receivedNewData(notification:)), name: Notification.Name("NewMatchData"), object: nil)
		
		if matchesDataSource.futureMatches.count == 0 && matchesDataSource.completedMatches.count == 0 {
			soccerSpinner.image = #imageLiteral(resourceName: "soccer")
			soccerSpinner.contentMode = .scaleAspectFit
			soccerSpinner.center = CGPoint(x: view.frame.midX, y: view.frame.midY)
			view.addSubview(soccerSpinner)
			
			let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
			rotation.toValue = NSNumber(value: Double.pi * 2)
			rotation.duration = 1
			rotation.isCumulative = true
			rotation.repeatCount = Float.greatestFiniteMagnitude
			soccerSpinner.layer.add(rotation, forKey: "rotationAnimation")
		}
		
		
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { (success, error) in
			if success {
				print("Permission Granted")
			} else {
				print("There was a problem!")
			}
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	
	override func viewDidAppear(_ animated: Bool) {
		let backButton = UIBarButtonItem(
			title: "",
			style: .plain,
			target: nil,
			action: nil
		);
		
		navigationController?.navigationBar.topItem!.backBarButtonItem = backButton
		navigationController?.navigationBar.prefersLargeTitles = true
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		if section == 0 {
			if matchesDataSource.completedMatches.count == 0 {
				return CGSize.zero
			}
		}else{
			if matchesDataSource.futureMatches.count == 0 {
				return CGSize.zero
			}
		}
		
		return CGSize(width: collectionView.frame.width, height: Grid.rowHeight)
	}
	
//	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//		var rec = CGSize(width: (UIScreen.main.bounds.size.width - (Padding.collections * 2)), height: 0.0)
//
//		if let cell = collectionView.cellForItem(at: indexPath) as? MatchViewCell {
//			rec.height += Padding.cells									// top padding
//			rec.height += cell.homeTeam.bounds.height
//			rec.height += cell.connector.bounds.height
//			rec.height += cell.awayTeam.bounds.height
//			rec.height += Padding.cells * 2							// middle padding
//			rec.height += cell.date.bounds.height
//			rec.height += Padding.cells 								// bottom padding
//		}else{
//			rec.height = 60;
//		}
//		return rec
//	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

	}
	
	func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		
	}
	
	func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath) as! MatchViewCell
		let match: Match
		if indexPath.section == 0 {
			match = matchesDataSource.completedMatches[indexPath.row]
		}else{
			match = matchesDataSource.futureMatches[indexPath.row]
		}
		
		cell.selectedItem( match )
	}
	
	func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath) as! MatchViewCell
		cell.deselectedItem()
	}
	
	@objc func scrollToUpcomingMatches() {
		if let attributes = matchCollectionView.collectionViewLayout.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 1)) {
//			print(attributes.frame.origin.y, attributes.frame.size.height)
//			print(matchCollectionView.contentSize.height, matchCollectionView.bounds.size.height, matchCollectionView.contentInset)
			let scrollingPosition = min( attributes.frame.origin.y - attributes.frame.size.height - 20, matchCollectionView.contentSize.height - matchCollectionView.bounds.size.height + matchCollectionView.adjustedContentInset.top)
			matchCollectionView.setContentOffset( CGPoint(x: 0, y: scrollingPosition), animated: true)
		}
	}
	

	@objc func receivedNewData(notification: Notification) {
		DispatchQueue.main.async {
//			let invalid = UICollectionViewLayoutInvalidationContext(
//			invalid.invalidateSupplementaryElements(ofKind: <#T##String#>, at: [IndexPath(row: 0, section: 0)])

			self.matchCollectionView.refreshControl?.endRefreshing()
			
			UIView.animate(withDuration: 0.4, animations: {
				self.soccerSpinner.alpha = 0
			}, completion: { success in
				self.soccerSpinner.removeFromSuperview()
				self.reloadCollection()
				self.currentButton.isEnabled = self.matchesDataSource.futureMatches.count != 0
			})

		}
	}
	
	func reloadCollection() {
		self.matchCollectionView.performBatchUpdates({
			let range = Range(uncheckedBounds: (0, self.matchCollectionView.numberOfSections))
			let indexSet = IndexSet(integersIn: range)
			self.matchCollectionView.reloadSections(indexSet)
		}, completion: nil)
	}
	
	@objc func refreshData() {
		matchesDataSource.forceRefreshData()
	}
}


