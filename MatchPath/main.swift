//
//  main.swift
//  MatchPath
//
//  Created by Alexander Ignatev on 23.01.2020.
//  Copyright © 2020 Alexandr Ignatyev. All rights reserved.
//

import Foundation

func routes(_ path: LinkedPath) {
    print(path, terminator: " -> ")

    switch path {
    case .part("api", .empty):
        print("root api path")
    case .part("api", .part("users", .part(let id, .empty))):
        print("fetch user by \(id)")
    case .part("api", .part("books", .empty)):
        print("fetch all books")
    case .part("api", .part("devices", .part(let type, .part(let id, .empty)))):
        print("fetch device \(type) by \(id)")
    default:
        print("404")
    }
}

routes("api/users/1")
routes("api/users/2")
routes("api/books")
routes("/index")
routes(["api", "books"])
routes("api/devices/intercoms/1")
routes("api" / "users" / 3)
