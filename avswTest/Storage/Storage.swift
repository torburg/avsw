//
//  Storage.swift
//  avswTest
//
//  Created by Maksim Torburg on 29.03.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import Foundation

class Storage {
    static var instance = Storage()
    private(set) var elements = [Person]()

    func save(_ person: Person) throws {
        if self.doesContain(person) {
            remove(person)
        }
        add(person)
        let encoder = JSONEncoder()
        let data = try encoder.encode(elements)
        guard let fileURL = getFileURL() else {
            print("Can't create File to save")
            return
        }
        try data.write(to: fileURL)
    }

    func load() {
        guard let fileURL = getFileURL() else {
            print("Can't create File to save")
            return
        }
        if let data = FileManager.default.contents(atPath: fileURL.path) {
            if !data.isEmpty {
                do {
                    let decoder = JSONDecoder()
                    elements = try decoder.decode([Person].self, from: data)
                } catch {
                    print("Can't parse data from file: \(error)")
                }
            }
        }
    }

    func delete(_ person: Person) throws {
        remove(person)
        let encoder = JSONEncoder()
        let data = try encoder.encode(elements)
        guard let fileURL = getFileURL() else {
            print("Can't create File to save")
            return
        }
        try data.write(to: fileURL)
    }

    private func doesContain(_ person: Person) -> Bool {
        return elements.contains(where: { $0.id == person.id })
    }
    private func add(_ person: Person) {
        elements.append(person)
    }
    private func remove(_ person: Person) {
        elements = elements.filter{ $0.id != person.id }
    }

    private func getFileURL() -> URL? {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let fileUrl = path.appendingPathComponent("PersonList")
        if !FileManager.default.fileExists(atPath: fileUrl.path) {
            if !FileManager.default.createFile(atPath: fileUrl.path, contents: nil, attributes: nil) {
                return nil
            }
        }
        return fileUrl
    }
}
