import UIKit

class CustomTabBar: UITabBar {
    
    private var additionalTopInset: CGFloat = 20.0
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 80 + additionalTopInset  // Установите желаемую высоту TabBar
        return sizeThatFits
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Установка отступов для элементов таб-бара
        for subview in subviews where subview is UIControl {
            subview.frame.origin.y = additionalTopInset
        }
    }
}
