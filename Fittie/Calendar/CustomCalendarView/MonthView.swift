import SwiftUI

struct Month: Identifiable {
    let id = UUID()
    let name: String
    let days: [Date]
}

struct MonthView: View {
    let month: Month
    let dayTapped: (Date) -> Void
    let dayColor: (Date) -> Color?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(month.name)
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom, 5)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 16) {
                ForEach(month.days, id: \.self) { day in
                    Text("\(Calendar.current.component(.day, from: day))")
                        .frame(width: 40, height: 40)
                        .background(
                            Circle()
                                .fill(dayColor(day) ?? Color.gray.opacity(0.8)))
                        .onTapGesture {
                            dayTapped(day)
                        }
                }
            }
            .padding()
            .background(Constants.backgroundMaterial)
            .cornerRadius(Constants.cornerRadius, corners: .allCorners)
            .padding(.bottom, 20)
        }
    }
}
