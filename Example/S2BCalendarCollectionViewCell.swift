import UIKit

class S2BCalendarCollectionViewCell: UICollectionViewCell {
    var label: UILabel!
    private var halfBackgroundView: UIView?
    private var spacing: CGFloat = 0.0
    private var selectedColor: UIColor = S2BColor.palette.lightGrey
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
        self.label.clipsToBounds = true
        self.label.layer.cornerRadius = 0.0
        self.label.backgroundColor = .clear
        halfBackgroundView?.removeFromSuperview()
        halfBackgroundView = nil
    }
    func displayDayOfWeek() {
        self.label.font = S2BFont.H6
        self.label.textColor = S2BColor.palette.darkBlueGrey
    }

    func displayNormalDayOfMonth() {
        self.label.font = S2BFont.H5
        self.label.textColor = S2BColor.palette.darkBlueGrey
    }

    func displayHighLightDayOfMonth() {
        self.label.font = S2BFont.H5
        self.label.textColor = S2BColor.palette.white
        self.label.backgroundColor = S2BColor.palette.darkBlue
        self.label.clipsToBounds = true
        self.label.layer.cornerRadius = S2BSize.radius.small
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
