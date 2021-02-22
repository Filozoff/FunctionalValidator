//
//  ViewController.swift
//  FunctionalValidator
//
//  Created by Filo on 22/02/2021.
//

import UIKit

class ViewController: UIViewController {

	let textField = UITextField()

	override func loadView() {
		view = UIView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .systemBackground
		textField.placeholder = "Type number 0-1000"
		textField.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(textField)

		NSLayoutConstraint.activate([
			textField.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
			textField.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
			textField.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
	}
}
