import SwiftUI

struct SteampunkClockBorder: View {
    static let borderWidthRatio: CGFloat = 1/80


    var body: some View {
        ZStack {
            windUpKey
            border
        }.aspectRatio(contentMode: .fit)
    }

    var border: some View {
        GeometryReader { geometry in
            Circle().fill(Color.background)
            Circle().stroke(lineWidth: geometry.diameter * Self.borderWidthRatio)
        }
    }

    var windUpKey: some View {
        GeometryReader { geometry in
            WindUpKey()
                .scale(1/5)
                .stroke(lineWidth: geometry.diameter * Self.borderWidthRatio)
                .rotation(.radians(.pi * 7/4))
                .position(.pointInCircle(from: .radians(.pi * 7/4), diameter: geometry.diameter, margin: -geometry.diameter * 1/12))
                .animation(nil)
                .modifier(FlipOnAppear())
        }
    }
}

// TODO: extract this modifier to its own file
struct FlipOnAppear: ViewModifier {
    @Environment(\.clockIsAnimationEnabled) var isAnimationEnabled
    @State var animate = false

    func body(content: Content) -> some View {
        content
            .rotation3DEffect(animate && isAnimationEnabled ? .fullRound : .zero, axis: (x: 1, y: 1, z: 0))
            .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true))
            .onAppear { self.animate = true }
    }
}

// TODO: extract this modifier to its own file
struct RotateOnAppear: ViewModifier {
    @Environment(\.clockIsAnimationEnabled) var isAnimationEnabled
    @State var animate = false
    var clockwise = true

    func body(content: Content) -> some View {
        content
            .rotationEffect(rotationAngle)
            .animation(Animation.easeInOut(duration: 4).repeatForever(autoreverses: true))
            .onAppear { self.animate = true }
    }

    var rotationAngle: Angle {
        guard isAnimationEnabled else { return .zero }
        if clockwise {
            return animate ? .fullRound : .zero
        } else {
            return animate ? -.fullRound : .zero
        }
    }
}

struct SteampunkClockBorder_Previews: PreviewProvider {
    static var previews: some View {
        SteampunkClockBorder().padding()
    }
}