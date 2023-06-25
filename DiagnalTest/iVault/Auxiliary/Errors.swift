//
//  Errors.swift
//  DiagnalTest
//
//  Created by Pratyush Pratik Sinha on 23/06/23.
//

import Foundation

internal enum CustomErrors: Error {
    
    case unknownError
    case parsingError
    
    var description: String {
        switch self {
        case .unknownError:
            return "Unknown Error"
        case .parsingError:
            return "Parsing Error"
        }
    }
}
