import SwiftUI

struct AllSetView: View {
    private let checkmarkTitles : [LocalizedStringKey] = ["onboarding_all_set_checkmark_1",
                                                          "onboarding_all_set_checkmark_2",
                                                          "onboarding_all_set_checkmark_3"]
    
    var body: some View {
        VStack(spacing: 0) {
            header
            checkmarks
                .frame(maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.vertical, 32)
        .padding(.horizontal, 24)
    }
}

private extension AllSetView {
    var header : some View {
        VStack(spacing: 24) {
            Image(systemName: "hand.thumbsup.circle")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 200)
                .foregroundStyle(Color.accentColor, Color.card)
                .symbolRenderingMode(.palette)
            
            Text("onboarding_all_set_title")
                .font(.title)
                .fontWeight(.bold)
        }
    }
    
    var checkmarks : some View {
        VStack(alignment: .leading, spacing: 24) {
            ForEach(checkmarkTitles.indices, id: \.self) { index in
                checkmark(checkmarkTitles[index])
            }
        }
    }
    
    func checkmark(_ title : LocalizedStringKey) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(Color.accentColor)
            Text(title)
                .font(.body)
                .fontWeight(.light)
                .lineSpacing(Constants.lineSpacing)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    AllSetView()
        .background(Color.card)
}
