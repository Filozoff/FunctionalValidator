//
//  Validation.swift
//  FunctionalValidator
//
//  Created by Filo on 22/02/2021.
//

import Foundation

enum ValidationResult<Error> where Error: Swift.Error {
	case invalid(Error)
	case valid

	var isValid: Bool {
		switch self {
		case .invalid: return false
		case .valid: return true
		}
	}
}
