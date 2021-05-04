//
//  Assertion.swift
//  FunctionalValidatorTests
//
//  Created by Filo on 08/05/2021.
//

import XCTest
@testable import FunctionalValidator

func XCTAssertValidationInvalid<E>(
	_ expression1: @autoclosure () throws -> ValidationResult<E>,
	_ expression2: @autoclosure () throws ->E,
	_ message: @autoclosure () -> String = "",
	file: StaticString = #filePath,
	line: UInt = #line
) where E: Error & Equatable {
	let message = message()
	do {
		switch try expression1() {
		case .valid: XCTFail(message, file: file, line: line)
		case .invalid(let validationError):
			XCTAssertEqual(validationError, try expression2(), message, file: file, line: line)
		}
	} catch {
		XCTFail("\(message): \(error.localizedDescription)", file: file, line: line)
	}
}

func XCTAssertValidationValid<E>(
	_ expression1: @autoclosure () throws -> ValidationResult<E>,
	_ message: @autoclosure () -> String = "",
	file: StaticString = #filePath,
	line: UInt = #line
) where E: Error & Equatable {
	let message = message()
	do {
		switch try expression1() {
		case .valid: break
		case .invalid(let error):
			XCTFail("\(message): \(error.localizedDescription)", file: file, line: line)
		}
	} catch {
		XCTFail("\(message): \(error.localizedDescription)", file: file, line: line)
	}
}
