//
//  Item.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import Foundation
import SwiftData

@Model
public final class Item {
    public var id: UUID
    public var timestamp: Date
    public var title: String
    public var detail: String
    
    public init(id: UUID = UUID(), timestamp: Date = Date(), title: String = "New Item", detail: String = "") {
        self.id = id
        self.timestamp = timestamp
        self.title = title
        self.detail = detail
    }
}
