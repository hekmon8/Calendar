import UIKit

class NCHCalendarCollectionViewCell: UICollectionViewCell {
    var label: UILabel!
    private var halfBackgroundView: UIView?
    private var spacing: CGFloat = 0.0
    private var selectedColor: UIColor =  #colorLiteral(red: 0.9450980392, green: 0.9647058824, blue: 0.9803921569, alpha: 1)
    private let widthLabel: CGFloat = 32.0
    override init(frame: CGRect) {
        super.init(frame: frame)
        initLabel()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initLabel()
    }

    private func initLabel() {
        label = UILabel(frame: CGRect(origin: self.frame.origin,
                                      size: CGSize(width: widthLabel, height: widthLabel)))
        label.center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        label.textAlignment = NSTextAlignment.center
        self.addSubview(label)
    }
    func setSpacing(spacing: CGFloat) {
        self.spacing = spacing
    }
    func reset() {
        label.center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        label.clipsToBounds = true
        label.layer.cornerRadius = 0.0
        label.backgroundColor = .clear
        halfBackgroundView?.removeFromSuperview()
        halfBackgroundView = nil
    }
    func displayDayOfWeek() {
        self.label.font = UIFont.boldSystemFont(ofSize: 14.0)
        self.label.textColor = #colorLiteral(red: 0.2, green: 0.3058823529, blue: 0.4117647059, alpha: 1)
    }

    func displayNormalDayOfMonth() {
        self.label.font = UIFont.systemFont(ofSize: 16.0)
        self.label.textColor = #colorLiteral(red: 0.2, green: 0.3058823529, blue: 0.4117647059, alpha: 1)
    }

    func displayHighLightDayOfMonth() {
        self.label.font = UIFont.systemFont(ofSize: 16.0)
        self.label.textColor = UIColor.white
        self.label.backgroundColor = #colorLiteral(red: 0, green: 0.4588235294, blue: 0.6901960784, alpha: 1)
        self.label.clipsToBounds = true
        self.label.layer.cornerRadius = 4.0
    }

    func highlightLeft() {
        let originX = -spacing/2.0
        let width = spacing/2.0 + self.label.frame.origin.x
        let height = self.label.frame.size.height
        let originY = self.label.frame.origin.y
        halfBackgroundView = UIView(frame: CGRect(x: originX,
                                                  y: originY,
                                                  width: width,
                                                  height: height))
        halfBackgroundView?.backgroundColor = selectedColor
        self.addSubview(halfBackgroundView!)
        sendSubviewToBack(halfBackgroundView!)
    }

    func highlightRight() {
        let originX = self.label.frame.origin.x + self.label.frame.width
        let height = self.label.frame.size.height
        let width = spacing/2.0 + self.frame.width - originX
        let originY = self.label.frame.origin.y
        halfBackgroundView = UIView(frame: CGRect(x: originX,
                                                  y: originY,
                                                  width: width,
                                                  height: height))
        halfBackgroundView?.backgroundColor = selectedColor
        self.addSubview(halfBackgroundView!)
        sendSubviewToBack(halfBackgroundView!)
    }

    func highlight() {
        let width = self.frame.size.width + spacing
        let height = self.label.frame.size.height
        halfBackgroundView = UIView(frame: CGRect(x: -spacing/2.0,
                                                  y: self.label.frame.origin.y,
                                                  width: width,
                                                  height: height))
        halfBackgroundView?.backgroundColor = selectedColor
        self.addSubview(halfBackgroundView!)
        sendSubviewToBack(halfBackgroundView!)
    }
}
