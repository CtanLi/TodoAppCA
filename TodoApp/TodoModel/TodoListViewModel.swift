//
//  TodoListViewModel.swift
//  TodoApp
//
//  Created by CtanLI on 2020-09-06.
//  Copyright © 2020 Todo. All rights reserved.
//

import Foundation

class TodoListViewModel {

	var reloadList = {() -> () in }
	var posts: [TodoViewModel] = [] {
        ///Reload data when data set
        didSet{
            reloadList()
        }
    }

//	init() {
//		Api().getPost { (post) in
//			self.posts = post.map(TodoViewModel.init)
//		}
//	}

	func getTodo() {
		Api().getPost { (post) in
			self.posts = post.map(TodoViewModel.init)
		}
	}
}

struct TodoViewModel {
	var post: TodoModel

	init(post: TodoModel) {
		self.post = post
	}

	var userId: Int {
		return self.post.id
	}

	var id: Int {
		return self.post.id
	}

	var title: String {
		return self.post.title
	}

	var completed: Bool {
		return self.post.completed
	}
}
