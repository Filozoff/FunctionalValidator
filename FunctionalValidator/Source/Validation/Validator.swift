//
//  Validator.swift
//  FunctionalValidator
//
//  Created by Filo on 22/02/2021.
//

import Foundation

typealias ValidatorDownstream<T, E> = (T) -> ValidationResult<E> where E: Swift.Error

class Validator<Base, Error>: ValidationOperation where Error: Swift.Error {

	typealias Input = Base

	var downstream: ValidatorDownstream<Input, Error>?

	init() { }

	func validate(value: Base) -> ValidationResult<Error> {
		downstream?(value) ?? .valid
	}
}

protocol ValidationOperation: AnyObject {

	associatedtype Base
	associatedtype Error: Swift.Error
	associatedtype Input

	var downstream: ValidatorDownstream<Input, Error>? { get set }

	func validate(value: Base) -> ValidationResult<Error>
}

extension ValidationOperation {

	func map<Input>(_ transformation: @escaping Map<Self, Input, Base, Error>.Transformation, error: Error) -> Map<Self, Input, Base, Error> {
		Map(upstream: self, downstream: &downstream, transformation: transformation, relatedError: error)
	}

	func match(rule: ValidationRule<Input>, error: Error) -> Rule<Self, Input, Base, Error> {
		Rule(upstream: self, downstream: &downstream, rule: rule, relatedError: error)
	}
}

class Rule<Upstream, Input, Base, Error>: ValidationOperation
where Upstream: ValidationOperation,
	  Upstream.Base == Base,
	  Upstream.Input == Input,
	  Upstream.Error == Error
{

	var downstream: ValidatorDownstream<Input, Error>?
	let rule: ValidationRule<Input>
	let relatedError: Error

	private(set) var upstream: Upstream

	init(upstream: Upstream, downstream: inout ValidatorDownstream<Upstream.Input, Error>?, rule: ValidationRule<Input>, relatedError: Error) {
		self.upstream = upstream
		self.rule = rule
		self.relatedError = relatedError
		downstream = { [weak self] in
			rule.predicate($0) ? self?.downstream?($0) ?? .valid : .invalid(relatedError)
		}
	}

	func validate(value: Base) -> ValidationResult<Error> {
		upstream.validate(value: value)
	}
}

class Map<Upstream, Input, Base, Error>: ValidationOperation
where Upstream: ValidationOperation,
	  Upstream.Base == Base,
	  Upstream.Error == Error
{

	typealias Transformation = (Upstream.Input) -> Input?

	var downstream: ValidatorDownstream<Input, Error>?
	let relatedError: Error
	let transformation: Transformation
	let upstream: Upstream

	init(upstream: Upstream, downstream: inout ValidatorDownstream<Upstream.Input, Error>?, transformation: @escaping Transformation, relatedError: Error) {
		self.upstream = upstream
		self.transformation = transformation
		self.relatedError = relatedError
		downstream = { [weak self] in
			guard let result = transformation($0) else { return .invalid(relatedError) }
			return self?.downstream?(result) ?? .valid
		}
	}

	func validate(value: Base) -> ValidationResult<Error> {
		upstream.validate(value: value)
	}
}
