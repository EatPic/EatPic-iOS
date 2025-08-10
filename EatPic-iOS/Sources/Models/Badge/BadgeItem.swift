import SwiftUI

struct BadgeItem: Identifiable {
    let id = UUID()
    let state: BadgeState
    let name: String
    
    init(state: BadgeState, name: String) {
        self.state = state
        self.name = name
    }
}
