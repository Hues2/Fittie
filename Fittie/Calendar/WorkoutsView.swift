import SwiftUI
import UIKit
import Foundation

struct WorkoutsView: View {
    
    var body: some View {
        ZStack {
            BackgroundView()
            CustomCalendarView()
                .padding(.horizontal)
        }
        .navigationTitle("workouts_view_title")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        WorkoutsView()
    }
}
