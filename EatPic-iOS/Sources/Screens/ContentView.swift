import SwiftUI

public struct ContentView: View {
    public init() {}

    public var body: some View {
        VStack {
            Text("One Meal, One Routine")
                .font(.enRegular(size: 18))

            Text("한 장의 식사, 하나의 루틴")
                .font(.koRegular(size: 18))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        devicePreviews {
            ContentView()
        }
    }
}
