//  Created by Aji Prakosa on 19/5/25.

import SwiftUI
import RxRelay

extension View {
    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }
}

struct ViewDidLoadModifier: ViewModifier {
    @State private var didLoad = false
    private let action: (() -> Void)?
    
    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content.onAppear {
            if !didLoad {
                didLoad = true
                action?()
            }
        }
    }
}

extension BehaviorRelay where Element: RangeReplaceableCollection {
    func append(_ newElement: Element.Element) {
        var value = self.value
        value.append(newElement)
        self.accept(value)
    }
    
    func append(contentsOf sequence: Element) {
        var value = self.value
        value.append(contentsOf: sequence)
        self.accept(value)
    }
}
