# SDSSwiftUILayout

Convenient Layout for SwiftUI

## AdaptiveHVStack
detect landscape/portrait ratio, then use HStack or VStack
note: decision made from give bounds to layout (not from device orientation)


### code example
ViewThatFits might be replaced with AdaptiveHVStack
- ViewThatFits try to use first one, then might use second first one does not fit.
- AdaptiveHVStack will choose HStack or VStack based on given bounds width/height ratio


```
struct ContentView: View {
    var body: some View {
        AdaptiveHVStack {
            Color.yellow.frame(width: 300, height: 300)
            Color.green.frame(width: 300, height: 300)
        }
//        ViewThatFits {
//            HStack {
//                Color.yellow.frame(width: 300, height: 300)
//                Color.green.frame(width: 300, height: 300)
//            }
//            VStack {
//                Color.yellow.frame(width: 300, height: 300)
//                Color.green.frame(width: 300, height: 300)
//            }
//        }
        .padding()
    }
}
```
