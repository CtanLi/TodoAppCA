//
//  APIManager.swift
//  TodoApp
//
//  Created by CtanLI on 2020-09-02.
//  Copyright © 2020 Todo. All rights reserved.
//

import Foundation

class Api {
	func getPost(completion: @escaping ([TodoModel]) -> Void) {
		if let url = URL(string: "https://jsonplaceholder.typicode.com/todos") {
			URLSession.shared.dataTask(with: url) { (data, _, _) in
				if let data = data {
					let post = try! JSONDecoder().decode([TodoModel].self, from: data)
					print(post)
					DispatchQueue.main.async {
						completion(post)
					}
				}
			}
			.resume()
		}
	}

	func getNews(completion: @escaping ([TodoModel]) -> Void) {
		if let url = URL(string: "https://jsonplaceholder.typicode.com/news") {
			URLSession.shared.dataTask(with: url) { (data, _, _) in
				if let data = data {
					let post = try! JSONDecoder().decode([TodoModel].self, from: data)
					print(post)
					DispatchQueue.main.async {
						completion(post)
					}
				}
			}
			.resume()
		}
	}
}
