//
//  SessionsDataSourceAndDelegate.swift
//  FieldHouse Sports
//
//  Created by Mike Reinhard on 3/10/18.
//  Copyright © 2018 Mike Reinhard. All rights reserved.
//

import UIKit

class SessionsDataSource: NSObject, UICollectionViewDataSource {
	
	var sessions: [Session]
	
	override init() {
		sessions = []
		super.init()
		
		refreshData()
	}
	
	// Data methods
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return sessions.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "session", for: indexPath) as! SessionViewCell
		cell.title.text = sessions[indexPath.row].attributes.name
		return cell
	}

	func refreshData() {
		if let cachedSessions = Model.getSessions() {
			sessions = cachedSessions
		}else{
			forceRefreshData()
		}
	}
	
	func forceRefreshData() {
		API.instance.getSessions( reference: self )
	}
	
}
