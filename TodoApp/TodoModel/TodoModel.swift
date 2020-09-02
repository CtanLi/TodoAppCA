//
//  TodoModel.swift
//  TodoApp
//
//  Created by CtanLI on 2020-09-02.
//  Copyright © 2020 Todo. All rights reserved.
//

import Foundation

struct TodoModel: Codable {
	let userId = Int()
	let id = Int()
	var title: String
	var completed: Bool
}
