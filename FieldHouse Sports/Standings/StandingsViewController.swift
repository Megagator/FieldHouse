//
//  ViewController.swift
//  FieldHouse Sports
//
//  Created by Mike Reinhard on 3/10/18.
//  Copyright © 2018 Mike Reinhard. All rights reserved.
//

import UIKit

class StandingsViewController: UIViewController, UICollectionViewDelegate, UIViewControllerPreviewingDelegate, UICollectionViewDelegateFlowLayout {
	
	var standingsCollectionView: UICollectionView!
	var standingsDataSource: StandingsDataSource!
	var leagueID: String = ""
	var tracksStandings: Bool = true
	var displayScores: Bool = false

	let refreshUI = UIRefreshControl()
	var currentButton: UIBarButtonItem!

	let soccerSpinner = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
	
	override func viewDidLoad() {
		let backButton = UIBarButtonItem(
			title: "",
			style: .plain,
			target: nil,
			action: nil
		);
		
//		print("Standings: \(displayScores)")
		
		currentButton = UIBarButtonItem(image: #imageLiteral(resourceName: "calendar"), style: .done, target: self, action: #selector(scrollToUpcomingMatches))
		navigationItem.rightBarButtonItem = currentButton
		
		navigationController?.navigationBar.topItem!.backBarButtonItem = backButton
		navigationController?.navigationBar.prefersLargeTitles = false
		// navigationController?.navigationBar.barStyle = .blackTranslucent;

		
		// add collection view
		let frame = self.view.frame
		let layout = UICollectionViewFlowLayout()
		standingsCollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
		standingsCollectionView.backgroundColor = Colors.exlightgrey
		self.view.addSubview(standingsCollectionView)
		
		standingsCollectionView.translatesAutoresizingMaskIntoConstraints = false
		standingsCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
		standingsCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
		standingsCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
		standingsCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
		
		standingsCollectionView.register(StandingViewCell.self, forCellWithReuseIdentifier: "standing")
		standingsCollectionView.register(MatchViewCell.self, forCellWithReuseIdentifier: "match")
		
		standingsDataSource = StandingsDataSource( leagueID, hasStandings: tracksStandings )
		
		if standingsDataSource.futureLeagueMatches.count == 0 {
			currentButton.isEnabled = false
		}
		
		standingsCollectionView.dataSource = standingsDataSource
		standingsCollectionView.delegate = self
		standingsCollectionView.alwaysBounceVertical = true
		standingsCollectionView.register(StandingsCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "standingsReusableHeader")
		
		// setup the layoutgrid
		layout.scrollDirection = .vertical
		layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: Padding.collections, right: 0)
//	layout.sectionHeadersPinToVisibleBounds = true
		layout.minimumInteritemSpacing = 0 // horizontal margin
		layout.minimumLineSpacing = 0 // vertical margin
		
		// pull to refresh
		refreshUI.addTarget(self, action: #selector( self.refreshData ), for: UIControl.Event.valueChanged)
//		standingsCollectionView.refreshControl = refreshUI
		standingsCollectionView.insertSubview(refreshUI, at: 0)

		// data update observer
		NotificationCenter.default.addObserver(self, selector: #selector(self.receivedNewStandingData(notification:)), name: Notification.Name("NewStandingsData"), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.receivedNewStandingsTeamData(notification:)), name: Notification.Name("NewStandingsTeamData"), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.receivedNewLeagueMatchData(notification:)), name: Notification.Name("NewLeagueMatchData"), object: nil)
		
		// 3D Touch support
		if traitCollection.forceTouchCapability == .available {
			registerForPreviewing(with: self, sourceView: standingsCollectionView)
		}
		
		// prefetch match content
//		standingsDataSource.preFetchLinkedData()
		
		if standingsDataSource.teams.count == 0 && standingsDataSource.standings.count == 0 {
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
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

//	// deslect a cell when returning to this view
//	override func viewDidAppear(_ animated: Bool) {
//		super.viewWillAppear(animated)
////		navigationController?.navigationBar.prefersLargeTitles = true
//	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		switch section {
		case 0:
			if standingsDataSource.teams.count == 0 {
				return CGSize.zero
			}
			return CGSize(width: collectionView.frame.width, height: Grid.rowHeight)
		case 1:
			if standingsDataSource.standings.count == 0 {
				return CGSize.zero
			}
			return CGSize(width: collectionView.frame.width, height: Grid.rowHeight)
		case 2:
			if standingsDataSource.leagueMatches.count == 0 {
				return CGSize.zero
			}
			return CGSize(width: collectionView.frame.width, height: Grid.rowHeight + 20)
		case 3:
			if standingsDataSource.futureLeagueMatches.count == 0 {
				return CGSize.zero
			}
			return CGSize(width: collectionView.frame.width, height: Grid.rowHeight)
		default:
			return CGSize(width: collectionView.frame.width, height: Grid.rowHeight)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		if indexPath.section == 0 || indexPath.section == 1 {
			return CGSize(width: collectionView.frame.width, height: Grid.rowHeight)
		}
		
		return CGSize(width: (collectionView.frame.width - (Padding.collections * 2)), height: Grid.cellHeight)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		if section == 0 || section == 1 {
			return 0.0
		}
		
		return Padding.collections
	}
	
	
	// Item interactions
	func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
		if indexPath.section > 1 {
			return false
		}
		return true
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if indexPath.section == 0 || indexPath.section == 1 {
			let matchView = getMatchView(at: indexPath)
			navigationController?.pushViewController(matchView, animated: true)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		
	}
	
	func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
		if indexPath.section == 0 || indexPath.section == 1 {
			if let cell = collectionView.cellForItem(at: indexPath) as? StandingViewCell {
				cell.selectedRow()
			}
		}else{
			if let cell = collectionView.cellForItem(at: indexPath) as? MatchViewCell {
				let match: Match
				if indexPath.section == 2 {
					match = standingsDataSource.leagueMatches[indexPath.row]
				}else{
					match = standingsDataSource.futureLeagueMatches[indexPath.row]
				}
				cell.selectedItem( match )
			}
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
		if indexPath.section == 0 || indexPath.section == 1 {
			if let cell = collectionView.cellForItem(at: indexPath) as? StandingViewCell {
				cell.deselectedRow()
			}
		}else{
			if let cell = collectionView.cellForItem(at: indexPath) as? MatchViewCell {
				cell.deselectedItem()
			}
		}
	}

	// Helpers
	@objc func receivedNewStandingData(notification: Notification) {
//		standingsDataSource.preFetchLinkedData()
		DispatchQueue.main.async {
			self.refreshUI.endRefreshing()
			
			UIView.animate(withDuration: 0.4, animations: {
				self.soccerSpinner.alpha = 0
			}, completion: { success in
				self.soccerSpinner.removeFromSuperview()
				self.reloadCollection()
			})
			
		}
	}
	@objc func receivedNewLeagueMatchData(notification: Notification) {
		DispatchQueue.main.async {
			self.refreshUI.endRefreshing()
			
			UIView.animate(withDuration: 0.4, animations: {
				self.soccerSpinner.alpha = 0
			}, completion: { success in
				self.soccerSpinner.removeFromSuperview()
				self.reloadCollection()
				self.currentButton.isEnabled = self.standingsDataSource.futureLeagueMatches.count != 0
			})
			
		}
	}
	@objc func receivedNewStandingsTeamData(notification: Notification) {
		standingsDataSource.preFetchLinkedData()
		DispatchQueue.main.async {
			self.refreshUI.endRefreshing()
			
			UIView.animate(withDuration: 0.4, animations: {
				self.soccerSpinner.alpha = 0
			}, completion: { success in
				self.soccerSpinner.removeFromSuperview()
				self.reloadCollection()
			})
			
		}
	}
	
	func reloadCollection() {
		self.standingsCollectionView.performBatchUpdates({
			let range = Range(uncheckedBounds: (0, self.standingsCollectionView.numberOfSections))
			let indexSet = IndexSet(integersIn: range)
			self.standingsCollectionView.reloadSections(indexSet)
		}, completion: nil)
	}
	
	
	@objc func refreshData() {
		standingsDataSource.forceRefreshData()
	}
	
	@objc func scrollToUpcomingMatches() {
		if let attributes = standingsCollectionView.collectionViewLayout.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 3)) {
//			print(attributes.frame.origin.y, attributes.frame.size.height)
//			print(matchCollectionView.contentSize.height, matchCollectionView.bounds.size.height, matchCollectionView.contentInset)
			let scrollingPosition = min( attributes.frame.origin.y - attributes.frame.size.height - 20, standingsCollectionView.contentSize.height - standingsCollectionView.bounds.size.height + standingsCollectionView.adjustedContentInset.top)
			standingsCollectionView.setContentOffset(CGPoint(x: 0, y: scrollingPosition), animated: true)
		}
	}
	
	
	func getMatchView( at indexPath: IndexPath) -> MatchesViewController {
		let matchView = MatchesViewController()
		if indexPath.section == 0 {
			matchView.title = standingsDataSource.teams[indexPath.row].attributes.name
			matchView.teamID = standingsDataSource.teams[indexPath.row].id
			matchView.teamRecord = ""
			matchView.displayScores = displayScores
		}else{
			matchView.title = standingsDataSource.standings[indexPath.row].team_name
			matchView.teamID = String(standingsDataSource.standings[indexPath.row].team_id)
			matchView.teamRecord = standingsDataSource.getTeamRecord( standingsDataSource.standings[indexPath.row] )
			matchView.displayScores = displayScores
		}
		
		return matchView
	}
	
	// 3D Touch support
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
		guard let indexPath = standingsCollectionView.indexPathForItem(at: location)
			else { return nil }

		if indexPath.section > 1 {
			return nil
		}
		
		guard let cell = standingsCollectionView.cellForItem(at: indexPath)
			else { return nil }
		
		
		let matchView = getMatchView(at: indexPath)
		matchView.preferredContentSize = CGSize(width: 0.0, height: 500)
		
		previewingContext.sourceRect = cell.frame
		
		return matchView
	}
	
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
		navigationController?.pushViewController(viewControllerToCommit, animated: true)
	}

}


