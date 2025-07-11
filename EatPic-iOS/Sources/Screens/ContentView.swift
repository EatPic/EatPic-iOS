import SwiftUI

public struct ContentView: View {
    public init() {}

    public var body: some View {
        VStack {
            Text("Hello World!")
                .foregroundStyle(Color.gray060)
                .font(.enBold(size: 24))
            
            Text("화이팅!")
                .foregroundStyle(Color.green060)
                .font(.koRegular(size: 24))
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
