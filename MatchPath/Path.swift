//
//  Path.swift
//  MatchPath
//
//  Created by Alexander Ignatev on 24.01.2020.
//  Copyright © 2020 Alexandr Ignatyev. All rights reserved.
//

import Foundation

indirect enum Path: Hashable {
    case path(Substring, Path)
    case empty
}

extension Path {
    /// Path from string.
    init(string: String) {
        self = string
            .split(separator: "/")
            .reversed()
            .reduce(Path.empty) {
                Path.path($1, $0)
            }
    }
}

// MARK: - Literal

extension Path: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Substring...) {
        self = elements.reduce(Path.empty) { Path.path($1, $0) }
    }
}

extension Path: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self.init(string: value)
    }
}

// MARK: - Description

extension Path: CustomStringConvertible {
    var description: String { joined(separator: "/") }
}

extension Path: CustomDebugStringConvertible {
    var debugDescription: String { "Path(\(description))" }
}

// MARK: - Sequence

extension Path: Sequence {
    func makeIterator() -> AnyIterator<Substring> {
        var path = self
        return AnyIterator { () -> Substring? in
            switch path {
            case .path(let element, let next):
                path = next
                return element
            case .empty:
                return nil
            }
        }
    }
}
