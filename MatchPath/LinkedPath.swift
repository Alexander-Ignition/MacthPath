//
//  LinkedPath.swift
//  MatchPath
//
//  Created by Alexander Ignatev on 24.01.2020.
//  Copyright © 2020 Alexandr Ignatyev. All rights reserved.
//

import Foundation

/// Linked URL path components.
///
///     let path1: LinkedPath = "api/version"
///     let path2: LinkedPath = ["api", "users", "2"]
///     let path3: LinkedPath = "api" / "books" / 3
indirect enum LinkedPath: Hashable {
    /// Part of URL path. Value and next part.
    case part(Substring, LinkedPath)

    /// Empty path. Equal empty string "".
    case empty
}

// MARK: - LosslessStringConvertible

extension LinkedPath: LosslessStringConvertible {
    init(_ string: String) {
        self = string
            .split(separator: "/")
            .reversed()
            .reduce(LinkedPath.empty) { LinkedPath.part($1, $0) }
    }
}

// MARK: - Literal

extension LinkedPath: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Substring...) {
        self = elements
            .reversed()
            .reduce(LinkedPath.empty) { LinkedPath.part($1, $0) }
    }
}

extension LinkedPath: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self.init(value)
    }
}

// MARK: - Description

extension LinkedPath: CustomStringConvertible {
    var description: String { joined(separator: "/") }
}

extension LinkedPath: CustomDebugStringConvertible {
    var debugDescription: String { "Path(\(description))" }
}

// MARK: - Sequence

extension LinkedPath: Sequence {
    var isEmpty: Bool { self == .empty }

    func makeIterator() -> AnyIterator<Substring> {
        var path = self
        return AnyIterator { () -> Substring? in
            switch path {
            case .part(let element, let next):
                path = next
                return element
            case .empty:
                return nil
            }
        }
    }
}

// MARK: - Codable

extension LinkedPath: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        self.init(string)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}

// MARK: - Operators

extension LinkedPath {
    static func / (lhs: LinkedPath, rhs: LinkedPath) -> LinkedPath {
        lhs.reduce(rhs) { LinkedPath.part($1, $0) }
    }

    static func / <T>(lhs: LinkedPath, rhs: T) -> LinkedPath where T: LosslessStringConvertible {
        lhs.reduce(LinkedPath(rhs.description)) { LinkedPath.part($1, $0) }
    }
}
