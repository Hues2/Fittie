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
                    Text("\(Calendar.current.component(.day, from: day))")
                        .frame(width: 40, height: 40)
                        .background {
                            if dayColor(day) == Color.thirdAccent {
                                Circle()
                                    .stroke(Color.thirdAccent)
                            } else {
                                Circle()
                                    .fill(dayColor(day))
                            }
                        }
                        .onTapGesture {
                            dayTapped(day)
                        }
                }
            }
            .padding()
            .background(Color.card)
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
            .padding(.bottom, 20)
        }
    }
}
