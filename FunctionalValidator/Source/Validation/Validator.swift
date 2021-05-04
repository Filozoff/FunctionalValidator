//
//  Validator.swift
//  FunctionalValidator
//
//  Created by Filo on 22/02/2021.
//

import Foundation

struct Validator<Base, Error>: ValidationOperation where Error: Swift.Error {

	typealias Input = Base

	init() { }

//	func optionalMap<T>(_ transformation: (Candidate) -> T?, error: Error) -> Validator<Base, T, Error> {
//
//	}

	func isSatisfied(by value: Input) -> ValidationResult<Error> { .valid }

	func receive(value: Base) {

	}
}

protocol ValidationOperation {

	associatedtype Base
	associatedtype Error: Swift.Error
	associatedtype Input

	func isSatisfied(by value: Input) -> ValidationResult<Error>
	func receive(value: Base)
}

extension ValidationOperation {

	func match(rule: ValidationRule<Input>, error: Error) -> Rule<Self, Input, Base, Error> {
		Rule(upstream: self, rule: rule, relatedError: error)
	}
}

struct Rule<Upstream, Input, Base, Error>: ValidationOperation
where Upstream: ValidationOperation,
	  Upstream.Base == Base,
	  Upstream.Input == Input,
	  Upstream.Error == Error
{

	let rule: ValidationRule<Input>
	let relatedError: Error
	let upstream: Upstream

	init(upstream: Upstream, rule: ValidationRule<Input>, relatedError: Error) {
		self.upstream = upstream
		self.rule = rule
		self.relatedError = relatedError
	}

	func isSatisfied(by value: Input) -> ValidationResult<Error> {
		let isValid =  rule.operation(value)
		let result = upstream.isSatisfied(by: value)

		guard !isValid else { return result }
		switch result {
		case .invalid(let errors):
			var errors = errors
			errors.append(relatedError)
			return .invalid(errors)

		case .valid:
			return .invalid([relatedError])
		}
	}

	func receive(value: Base) {
		upstream.receive(value: value)
	}
}

struct Map<Upstream, Input, Output, Base, Error>: ValidationOperation
where Upstream: ValidationOperation,
	  Upstream.Base == Base,
	  Upstream.Input == Output,
	  Upstream.Error == Error
{

	typealias Transformation = (Input) -> Output?

	let relatedError: Error
	let transformation: Transformation
	let upstream: Upstream

	init(upstream: Upstream, transformation: @escaping Transformation, relatedError: Error) {
		self.upstream = upstream
		self.transformation = transformation
		self.relatedError = relatedError
	}

	func isSatisfied(by value: Input) -> ValidationResult<Error> {
		guard let output = transformation(value) else { return .invalid([relatedError])}
		return upstream.isSatisfied(by: output)
	}

	func receive(value: Base) {
		upstream.receive(value: value)
	}
}

struct ValidationRule<Input> {

	typealias Operation = (_ value: Input) -> Bool

	let operation: Operation

	init(operation: @escaping Operation) {
		self.operation = operation
	}
}

extension ValidationRule where Input: Equatable {

	static func isEqual(to value: Input) -> ValidationRule { .init { $0 == value } }
}

extension ValidationRule where Input: Comparable {

	static func isGreater(than value: Input) -> ValidationRule { .init { $0 > value } }
}

enum DummyError: Error {
	case empty
}

func test() {
	let number: Int = 5
	let validator = Validator<Int, DummyError>()
		.match(rule: .isEqual(to: 5), error: .empty)
		.match(rule: .isGreater(than: 3), error: .empty)
}
