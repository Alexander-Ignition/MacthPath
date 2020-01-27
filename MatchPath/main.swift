//
//  main.swift
//  MatchPath
//
//  Created by Alexander Ignatev on 23.01.2020.
//  Copyright © 2020 Alexandr Ignatyev. All rights reserved.
//

import Foundation

func routes(_ path: Path) {
    switch path {
    case .path("api", .empty):
        print("root api path")
    case .path("api", .path("users", .path(let id, .empty))):
        print("fetch user by \(id)")
    case .path("api", .path("books", .empty)):
        print("fetch all books")
    case .path("api", .path("devices", .path(let type, .path(let id, .empty)))):
        print("fetch device \(type) by \(id)")
    default:
        print("404")
    }
}

routes("api/users/1")
routes("api/users/2")
routes("api/books")
routes("/index")
routes(["home", "index"])
routes("api/devices/intercoms/1")
