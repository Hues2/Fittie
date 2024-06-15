import SwiftUI

struct Month: Identifiable {
    let id = UUID()
    let name: String
    let days: [Date]
}

struct MonthView: View {
    let month: Month
    let dayTapped: (Date) -> Void
    let dayColor: (Date) -> Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(month.name)
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom, 5)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 16) {
                ForEach(month.days, id: \.self) { day in
                    dayView(day)
                }
            }
            .padding(12)
            .background(Color.card)
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
            .padding(.bottom, 20)
        }
    }
    
    private func dayView(_ day : Date) -> some View {
        Text("\(Calendar.current.component(.day, from: day))")
            .lineLimit(1)
            .frame(minWidth: 40, minHeight: 40)
            .background {
                Circle()
                    .stroke(dayColor(day), lineWidth: 2.5)
            }
            .onTapGesture {
                dayTapped(day)
            }
    }
}

#Preview {
    NavigationStack {
        WorkoutsView()
    }
}
