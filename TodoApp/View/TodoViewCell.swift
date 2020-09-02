//
//  TodoViewCell.swift
//  TodoApp
//
//  Created by CtanLI on 2020-09-02.
//  Copyright © 2020 Todo. All rights reserved.
//

import UIKit

class TodoViewCell: UITableViewCell {

	@IBOutlet weak var title: UILabel!
	@IBOutlet weak var arrowIndicator: UIImageView!
	@IBOutlet weak var checkState: UIImageView! {
		didSet {
			checkState.isHidden = true
		}
	}

	var data: TodoModel? {
		didSet {
			guard let data = data else { return }
			self.title.text = data.title
			if data.completed == true {
				checkState.isHidden = false
			} else {
				checkState.isHidden = true
			}
		}
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		// Configure the view for the selected state
	}
}
