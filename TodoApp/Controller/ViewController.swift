//
//  ViewController.swift
//  TodoApp
//
//  Created by CtanLI on 2020-09-02.
//  Copyright © 2020 Todo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

	var data = [TodoModel]()
	var nextItem = [TodoModel]()
	var currentData = [TodoModel]()
	var filteredData = [TodoModel]()

	var selectedIndex = -1
	var nextData = Int()
	var previousData = Int()
	var pagesClicked = Bool()

	@IBOutlet weak var todoTableView: UITableView!
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var allTodosIcon: UILabel!
	@IBOutlet weak var completeIcon: UILabel!
	@IBOutlet weak var inCompelteIcon: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()
		todoTableView.keyboardDismissMode = .onDrag
		searchBar.delegate = self
		getTodoData()
	}

	func getTodoData() {
		Api().getPost { (posts) in
			self.data.append(contentsOf: posts)
			self.currentData = self.next()
			self.filteredData.append(contentsOf: self.currentData)
			self.todoTableView.reloadData()
		}
	}

	@IBAction func allTodos(_ sender: UIButton) {
		allTodosIcon.text = "◉"
		completeIcon.text = "◎"
		inCompelteIcon.text = "◎"

		filteredData.removeAll()
		filteredData.append(contentsOf: self.currentData)
		todoTableView.reloadData()
	}

	@IBAction func complete(_ sender: UIButton) {
		completeIcon.text = "◉"
		allTodosIcon.text = "◎"
		inCompelteIcon.text = "◎"
		filteredData.removeAll()
		for todo in currentData {
			if todo.completed == true {
				filteredData.append(todo)
			}
		}
		todoTableView.reloadData()
	}

	@IBAction func inComplete(_ sender: UIButton) {
		inCompelteIcon.text = "◉"
		allTodosIcon.text = "◎"
		completeIcon.text = "◎"
		filteredData.removeAll()
		for todo in currentData {
			if todo.completed != true {
				filteredData.append(todo)
			}
		}
		todoTableView.reloadData()
	}

	@IBAction func previousPage(_ sender: UIButton) {
		//updating array for previous 5 set of data to be displayed
		filteredData.removeAll()
		currentData = prev()
		filteredData.append(contentsOf: self.currentData)
		todoTableView.reloadData()
		pagesClicked = true
	}
	
	@IBAction func nextPage(_ sender: UIButton) {
		//updating array for next 5 set of data to be displayed
		filteredData.removeAll()
		currentData = next()
		filteredData.append(contentsOf: self.currentData)
		todoTableView.reloadData()
		pagesClicked = true
	}
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

	//MARK: UITableViewDataSource
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return filteredData.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "TodoViewCell", for: indexPath) as! TodoViewCell
		cell.data = filteredData[indexPath.row]
		if self.selectedIndex == indexPath.row {
			cell.title.lineBreakMode = .byWordWrapping
			cell.title.numberOfLines = 0
			DispatchQueue.main.async {
				cell.arrowIndicator.transform = CGAffineTransform(rotationAngle: -.pi/2)
			}
		} else {
			cell.title.lineBreakMode = .byTruncatingTail
			cell.title.numberOfLines = 1
			DispatchQueue.main.async {
				cell.arrowIndicator.transform = CGAffineTransform(rotationAngle: 0)
			}
		}
		return cell
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if selectedIndex == indexPath.row {
			let cell = tableView.cellForRow(at: indexPath) as? TodoViewCell
			if let value = cell?.data?.title {
				let height: CGFloat = self.calculateHeight(inString: value)
				return height + 60
			}
		}
		return 60
	}

	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if pagesClicked == true {
			cell.alpha = 0
			UIView.animate(
				withDuration: 0.5,
				delay: 0.05 * Double(indexPath.row),
				animations: {
					cell.alpha = 1
			})
		}
	}

	//MARK: UITableViewDelegate
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let _ = tableView.cellForRow(at: indexPath) as? TodoViewCell
		pagesClicked = false
		var indexPathArray: [IndexPath] = []
		if selectedIndex != -1 {
			indexPathArray.append(IndexPath(row: selectedIndex, section: 0))
		}
		if (selectedIndex == indexPath.row) {
			selectedIndex = -1
		} else {
			selectedIndex = indexPath.row
			indexPathArray.append(indexPath)
		}

		tableView.performBatchUpdates({() -> Void in
			if indexPathArray.count > 0 {
				tableView.reloadRows(at: indexPathArray, with: .none)
			}
		}, completion: {(_ finished: Bool) -> Void in })
	}

	//calculating text for dynamic cell height
	func calculateHeight(inString: String) -> CGFloat {
		let messageString = inString
		let attributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key(rawValue:
			NSAttributedString.Key.font.rawValue) : UIFont.systemFont(ofSize:
				15.0)]
		let attributedString : NSAttributedString = NSAttributedString(string: messageString, attributes: attributes)
		let rect : CGRect = attributedString.boundingRect(with: CGSize(width: 222.0, height: CGFloat.greatestFiniteMagnitude),
														  options: .usesLineFragmentOrigin, context: nil)
		let requredSize:CGRect = rect
		return requredSize.height
	}
}

extension ViewController {
	//data page setup for next and previous page
	func next() -> [TodoModel] {
		nextData = nextData.advanced(by: 5)
		nextData = nextData > data.endIndex ? data.startIndex : nextData
		nextItem = Array(data.prefix(nextData))
		return Array(nextItem.suffix(5))
	}

	func prev() -> [TodoModel] {
		previousData = previousData.advanced(by: 5)
		previousData = previousData < nextItem.startIndex ? nextItem.endIndex : previousData
		let previousItem = Array(nextItem.dropLast(previousData))
		return Array(previousItem.suffix(5))
	}
}

extension ViewController {

	//MARK: UISearchBarDelegate
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchText == String() {
			self.filteredData = currentData
		} else {
			filteredData = currentData.filter({( todo : TodoModel) -> Bool in
				guard let searchValue = searchBar.text else { return Bool() }
				return todo.title.contains(searchValue)
			})
		}
		self.todoTableView.reloadData()
	}

	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		self.searchBar.showsCancelButton = true
	}

	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.showsCancelButton = false
		searchBar.text = ""
		searchBar.resignFirstResponder()
		self.filteredData = currentData
		todoTableView.reloadData()
	}

	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
}
