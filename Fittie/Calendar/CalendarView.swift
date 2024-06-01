import SwiftUI
import UIKit
import Foundation

struct CalendarView: View {
    
    var body: some View {
        VerticalCalendarViewRepresentable()
    }
}

#Preview {
    CalendarView()
}

class VerticalCalendarLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        scrollDirection = .vertical
        minimumLineSpacing = 1
        minimumInteritemSpacing = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VerticalCalendarView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var collectionView: UICollectionView!
    private var months: [Month] = CalendarData.months()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let layout = VerticalCalendarLayout()
        
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DayCell.self, forCellWithReuseIdentifier: "DayCell")
        collectionView.register(MonthHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MonthHeader")
        
        addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return months.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return months[section].days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as! DayCell
        let day = months[indexPath.section].days[indexPath.row]
        cell.configure(with: day)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 7
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MonthHeader", for: indexPath) as! MonthHeader
        let month = months[indexPath.section]
        header.configure(with: month.name)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}

class DayCell: UICollectionViewCell {
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        label.textAlignment = .center
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with date: Date) {
        let day = Calendar.current.component(.day, from: date)
        label.text = "\(day)"
        label.backgroundColor = date == .now ? .red : .clear
    }
}

class MonthHeader: UICollectionReusableView {
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        label.textAlignment = .center
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(with text: String) {
        label.text = text
    }
}

struct VerticalCalendarViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> VerticalCalendarView {
        return VerticalCalendarView()
    }
    
    func updateUIView(_ uiView: VerticalCalendarView, context: Context) {
        // Update the view if needed
    }
}

struct Month: Identifiable {
    let id = UUID()
    let name: String
    let days: [Date]
}

struct CalendarData {
    static let calendar = Calendar.current
    static let year = calendar.component(.year, from: Date())
    
    static func months() -> [Month] {
        var months = [Month]()
        for monthIndex in 1...12 {
            let monthName = calendar.monthSymbols[monthIndex - 1]
            var days = [Date]()
            let dateComponents = DateComponents(year: year, month: monthIndex)
            if let date = calendar.date(from: dateComponents),
               let range = calendar.range(of: .day, in: .month, for: date) {
                days = range.compactMap { day -> Date? in
                    var components = dateComponents
                    components.day = day
                    return calendar.date(from: components)
                }
            }
            months.append(Month(name: monthName, days: days))
        }
        return months
    }
}
