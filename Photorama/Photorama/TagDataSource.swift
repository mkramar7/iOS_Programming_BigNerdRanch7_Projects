//
//  TagDataSource.swift
//  Photorama
//
//  Created by Marko Kramar on 09/06/2020.
//  Copyright © 2020 Marko Kramar. All rights reserved.
//

import UIKit
import CoreData

class TagDataSource: NSObject, UITableViewDataSource {
    var tags = [Tag]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let tag = tags[indexPath.row]
        cell.textLabel?.text = tag.name
        cell.accessibilityHint = "Toggles selection"
        cell.accessibilityTraits = [.button]
        return cell
    }
}
