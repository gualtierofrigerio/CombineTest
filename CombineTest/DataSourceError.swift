//
//  DataSourceError.swift
//  CombineTest
//
//  Created by Gualtiero Frigerio on 08/11/21.
//  Copyright © 2021 Gualtiero Frigerio. All rights reserved.
//

import Foundation

enum DataSourceError: Error {
    case genericError(String)
    case conversionError
    case urlError
}
