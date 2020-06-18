import UIKit

public class S2BCalendarView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var calendarView: UIView!
    //From Part
    @IBOutlet weak var fromTitleLabel: UILabel!
    @IBOutlet weak var fromImageView: UIImageView!
    @IBOutlet weak var fromDateLabel: UILabel!
    //To Part
    @IBOutlet weak var toTitleLabel: UILabel!
    @IBOutlet weak var toImageView: UIImageView!
    @IBOutlet weak var toDateLabel: UILabel!

    private var calender = Calendar(identifier: .gregorian)
    private let itemsPerRow = 7
    private let spacing: CGFloat = 0.0
    private let lineSpacingForSection: CGFloat = 0.0

    public var timeZone: TimeZone = TimeZone.current

    public var startDate: Date = Calendar.current.startOfDay(for: Date()) {
        didSet {
            startDate = calender.startOfDay(for: startDate)
            self.titleLabel.text = self.getMonthLabel(date: startDate)
            self.collectionView.reloadData()
        }
    }

    public var toDate: Date? {
        get {
            return convertStringToDate(dateStr: self.toDateLabel.text)
        }
        set(value) {
            self.toDateLabel.text = self.convertDateToString(date: value)
        }
    }

    public var fromDate: Date? {
        get {
            return convertStringToDate(dateStr: self.fromDateLabel.text)
        }
        set(value) {
            self.fromDateLabel.text = self.convertDateToString(date: value)
        }
    }

    public var fromTitle: String? {
        get {
            return self.fromTitleLabel.text
        }
        set(value) {
            self.fromTitleLabel.text = value
        }
    }

    public var toTitle: String? {
        get {
            return self.toTitleLabel.text
        }
        set(value) {
            self.toTitleLabel.text = value
        }
    }

    public var fromIcon: UIImage? {
        didSet {
            self.fromImageView.image = fromIcon?.withRenderingMode(.alwaysTemplate)
            self.fromImageView.tintColor = S2BColor.brand.scBlue
        }
    }

    public var toIcon: UIImage? {
        didSet {
            self.toImageView.image = toIcon?.withRenderingMode(.alwaysTemplate)
            self.toImageView.tintColor = S2BColor.brand.scBlue
        }
    }

    public var leftImageButton: UIImage? {
        didSet {
            let image = leftImageButton?.withRenderingMode(.alwaysTemplate)
            self.leftButton.setImage(image, for: .normal)
            self.leftButton.tintColor = S2BColor.palette.darkBlue
        }
    }

    public var rightImageButton: UIImage? {
        didSet {
            let image = rightImageButton?.withRenderingMode(.alwaysTemplate)
            self.rightButton.setImage(image, for: .normal)
            self.rightButton.tintColor = S2BColor.palette.darkBlue
        }
    }

    public convenience init() {
        self.init(frame: .zero)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .clear
        _ = fromNib(nibName: String(describing: S2BCalendarView.self))
        self.calendarView.applyShadow(shadowColor: S2BShadow.low.shadowColor,
                                      shadowRadius: S2BShadow.low.shadowRadius,
                                      opacity: S2BShadow.low.shadowOpacity,
                                      offset: S2BShadow.low.shadowOffset)
        self.calendarView.cornerRadius(radius: S2BSize.radius.medium,
                                       maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner,
                                                       .layerMinXMaxYCorner, .layerMaxXMaxYCorner],
                                       color: S2BColor.palette.grey.withAlphaComponent(0.3),
                                       width: S2BSize.lineThickness.light)

        self.fromTitleLabel.textColor = S2BColor.palette.darkBlueGrey
        self.fromTitleLabel.font = S2BFont.Caption
        self.toTitleLabel.textColor = S2BColor.palette.darkBlueGrey
        self.toTitleLabel.font = S2BFont.Caption

        self.toDateLabel.font = S2BFont.H4
        self.toDateLabel.textColor = S2BColor.palette.deepBlue
        self.fromDateLabel.font = S2BFont.H4
        self.fromDateLabel.textColor = S2BColor.palette.deepBlue

        self.leftImageButton = UIImage(bgIcon: .arrowLeft)
        self.rightImageButton = UIImage(bgIcon: .arrowRight)

        self.titleLabel.textColor = S2BColor.palette.darkBlue
        self.titleLabel.font = S2BFont.H4
        self.titleLabel.text = self.getMonthLabel(date: startDate)
        fromDate = nil
        toDate = nil
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(S2BCalendarCollectionViewCell.self,
                                forCellWithReuseIdentifier: String(describing: S2BCalendarCollectionViewCell.self))
    }

    @IBAction func eventClickPreviousTime(_ sender: Any) {
        guard let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: startDate) else {
            return
        }
        self.startDate = previousMonth
    }
    @IBAction func eventClickNextTime(_ sender: Any) {
        guard let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: startDate) else {
            return
        }
        self.startDate = nextMonth
    }
}

extension S2BCalendarView: UICollectionViewDelegate, UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let firstDateForSection = getFirstDateForSection(section: section)
        let blankItems = getWeekday(date: firstDateForSection) - 1
        let daysInMonth = getNumberOfDaysInMonth(date: firstDateForSection)
        return itemsPerRow + blankItems + daysInMonth
    }

    // swiftlint:disable superfluous_disable_command
    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            String(describing: S2BCalendarCollectionViewCell.self), for: indexPath)
            as? S2BCalendarCollectionViewCell else { return UICollectionViewCell()}

        let blankItems = getWeekday(date: getFirstDateForSection(section: indexPath.section)) - 1
        cell.setSpacing(spacing: spacing)
        cell.reset()
        if indexPath.item < itemsPerRow {
            cell.isUserInteractionEnabled = false
            let dayOfWeek = getWeekdayLabel(weekday: indexPath.item + 1)
            cell.label.text = dayOfWeek
            cell.displayDayOfWeek()
        } else if indexPath.item < itemsPerRow + blankItems {
            cell.isUserInteractionEnabled = true
            cell.label.text = ""
        } else {
            cell.isUserInteractionEnabled = true
            let dayOfMonth = indexPath.item - (itemsPerRow + blankItems) + 1
            let date = getDate(dayOfMonth: dayOfMonth, section: indexPath.section)
            cell.label.text = "\(dayOfMonth)"
            if let fromDate = self.fromDate, areSameDay(dateA: fromDate, dateB: date) {
                cell.displayHighLightDayOfMonth()
            } else if let toDate = toDate, areSameDay(dateA: toDate, dateB: date) {
                cell.displayHighLightDayOfMonth()
            } else {
                cell.displayNormalDayOfMonth()
            }
            if let fromDate = fromDate, let toDate = toDate {
                if date > fromDate && date < toDate {
                    cell.highlight()
                } else if date == toDate {
                    cell.highlightLeft()
                } else if date == fromDate {
                    cell.highlightRight()
                }
            }
        }
        return cell
    }
    public func collectionView(_ collectionView: UICollectionView,
                               didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath)
            as? S2BCalendarCollectionViewCell,
            let text = cell.label.text, !text.isEmpty else { return }
        let blankItems = getWeekday(date: getFirstDateForSection(section: indexPath.section)) - 1
        let dayOfMonth = indexPath.item - (itemsPerRow + blankItems) + 1
        let date = getDate(dayOfMonth: dayOfMonth, section: indexPath.section)
        caculateDateSelected(date: date)
    }
    private func caculateDateSelected(date: Date) {
        if self.fromDate == nil {
            self.fromDate = date
        } else if self.toDate == nil {
            let isAfter = self.isAfter(dateA: self.fromDate!, dateB: date)
            if isAfter {
                self.toDate = date
            } else {
                let tempDate = self.fromDate
                self.fromDate = date
                self.toDate = tempDate
            }
        } else {
            self.fromDate = date
            self.toDate = nil
        }
        collectionView.reloadData()
    }
}
extension S2BCalendarView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.frame.width - CGFloat(itemsPerRow - 1) * spacing ) / CGFloat(itemsPerRow)
        return CGSize(width: itemWidth, height: itemWidth)
    }
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacingForSection
    }
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
}

extension S2BCalendarView {

    private func getWeekdayLabel(weekday: Int) -> String {
        var components = DateComponents()
        components.calendar = calender
        components.weekday = weekday
        let date = calender.nextDate(after: Date(),
                                     matching: components,
                                     matchingPolicy: Calendar.MatchingPolicy.strict)
        if date == nil { return "EEE" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        let weekday = dateFormatter.string(from: date ?? calender.today())
        guard let firstCharacter =  weekday.first else { return weekday }
        return String(firstCharacter)
    }

    func getMonthLabel(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: date)
    }

    func getFirstDateForSection(section: Int) -> Date {
        return calender.date(byAdding: .month, value: section, to: getFirstDate()) ?? calender.today()
    }

    func getWeekday(date: Date) -> Int {
        return calender.dateComponents([.weekday], from: date).weekday ?? 0
    }

    func getFirstDate() -> Date {
        var components = calender.dateComponents([.month, .year], from: startDate)
        components.day = 1
        return calender.date(from: components) ?? calender.today()
    }

    func getNumberOfDaysInMonth(date: Date) -> Int {
        return calender.range(of: .day, in: .month, for: date)?.count ?? 30
    }

    func getDate(dayOfMonth: Int, section: Int) -> Date {
        var components = calender.dateComponents([.month, .year], from: getFirstDateForSection(section: section))
        components.day = dayOfMonth
        let date = calender.date(from: components) ?? calender.today()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = timeZone
        let seconddateFormatter = DateFormatter()
        seconddateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        seconddateFormatter.timeZone = timeZone
        let dateString = dateFormatter .string(from: date)
        let convertedDate = seconddateFormatter.date(from: dateString)
        return calender.startOfDay(for: convertedDate ?? calender.today())
    }
    func convertDateToString(date: Date?) -> String? {
        guard let date = date else { return "-" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: date)
    }
    func convertStringToDate(dateStr: String?) -> Date? {
        guard let dateStr = dateStr else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.timeZone = timeZone
        let convertedDate = dateFormatter.date(from: dateStr)
        return convertedDate
    }
    func isAfter(dateA: Date, dateB: Date) -> Bool {
        return calender.compare(dateA, to: dateB, toGranularity: .day) == ComparisonResult.orderedAscending
    }
    func areSameDay(dateA: Date, dateB: Date) -> Bool {
        return calender.compare(dateA, to: dateB, toGranularity: .day) == ComparisonResult.orderedSame
    }
}

extension Calendar {
    func today() -> Date {
        return Calendar.current.startOfDay(for: Date())
    }
}
