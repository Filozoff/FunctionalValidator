//
//  FunctionalValidatorTests.swift
//  FunctionalValidatorTests
//
//  Created by Filo on 22/02/2021.
//

import XCTest
@testable import FunctionalValidator

class FunctionalValidatorTests: XCTestCase {

	// MARK: - default

	func test_whenValidateCalled_thenReturnsValidResult() throws {

		// when
		let result = Validator<String, Error>().validate(value: "")

		// then
		XCTAssertTrue(result.isValid)
	}

	// MARK: - map

	func test_givenMapAndInvalidValue_whenValidateCalled_thenReturnsInvalidResult() {

		// given
		let value = "hobbs&shaw"
		let validator = Validator<String, StubError>()
			.map({ Double($0) }, error: .one)

		// when
		let result = validator.validate(value: value)

		// then
		XCTAssertFalse(result.isValid)
		XCTAssertValidationInvalid(result, .one)
	}

	func test_givenMapAndValidValue_whenValidateCalled_thenReturnsValidResult() throws {

		// given
		let value = "5"
		let validator = Validator<String, StubError>()
			.map({ Double($0) }, error: .one)

		// when
		let result = validator.validate(value: value)

		// then
		XCTAssertTrue(result.isValid)
		XCTAssertValidationValid(result)
	}

	// MARK: - match

    func test_givenMatchAndInvalidValue_whenValidateCalled_thenReturnsInvalidResult() throws {

		// given
		let value = "15"
		let validator = Validator<String, StubError>()
			.match(rule: .isEqual(to: "5"), error: .common)

		// when
		let result = validator.validate(value: value)

		// then
		XCTAssertFalse(result.isValid)
		XCTAssertValidationInvalid(result, .common)
    }

	func test_givenMatchAndValidValue_whenValidateCalled_thenReturnsValidResult() throws {

		// given
		let value = "5"
		let validator = Validator<String, StubError>()
			.match(rule: .isEqual(to: value), error: .common)

		// when
		let result = validator.validate(value: value)

		// then
		XCTAssertTrue(result.isValid)
		XCTAssertValidationValid(result)
	}

	// MARK: - chain

	func test_givenValidationChainAndInvalidValue_whenValidateCalled_thenValidationResultInvalidWithErrorInOrder() {

		// given
		let value = "5"
		let validator = Validator<String, StubError>()
			.match(rule: .isEqual(to: "1"), error: .one)
			.match(rule: .isEqual(to: "2"), error: .two)
			.match(rule: .isEqual(to: "3"), error: .three)

		// when
		let result = validator.validate(value: value)

		// then
		XCTAssertFalse(result.isValid)
		XCTAssertValidationInvalid(result, .one)
	}
}

private enum StubError: Swift.Error {
	case common
	case one
	case two
	case three
	case four
}
