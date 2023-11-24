import UIKit

class CircularProgressBarView: UIView {
    private var progressLayer: CAShapeLayer!
    private var trackLayer: CAShapeLayer!

    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createCircularPath()
    }

    private func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2),
                                        radius: frame.size.width / 2,
                                        startAngle: -.pi / 2,
                                        endAngle: 3 * .pi / 2,
                                        clockwise: true)

        trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(trackLayer)

        progressLayer = CAShapeLayer()
        progressLayer.path = circularPath.cgPath
        progressLayer.strokeColor = UIColor.green.cgColor
        progressLayer.lineWidth = 10
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeEnd = 0
        layer.addSublayer(progressLayer)
    }

    func setProgress(_ progress: Float) {
        progressLayer.strokeEnd = CGFloat(progress)
    }
}
