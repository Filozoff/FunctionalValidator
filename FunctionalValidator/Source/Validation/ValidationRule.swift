//
//  ValidationRule.swift
//  FunctionalValidator
//
//  Created by Filo on 04/05/2021.
//

import Foundation

struct ValidationRule<Input> {

	typealias Predicate = (_ value: Input) -> Bool

	let predicate: Predicate

	init(predicate: @escaping Predicate) {
		self.predicate = predicate
	}
}

extension ValidationRule where Input: Equatable {

	static func isEqual(to value: Input) -> ValidationRule { .init { $0 == value } }
}

extension ValidationRule where Input: Comparable {

	static func isGreater(than value: Input) -> ValidationRule { .init { $0 > value } }
}
