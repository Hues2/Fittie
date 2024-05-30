import SwiftUI

struct ExercisesView: View {
    @StateObject private var viewModel = ExercisesViewModel()
    
    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()
            
            content
                .navigationTitle("exercises_view_title")
        }
    }
}

private extension ExercisesView {
    var content : some View {
        List {
            ForEach(viewModel.filteredExerciseCategories.keys.sorted(), id:\.self) { category in
                Section {
                    section(viewModel.filteredExerciseCategories[category] ?? [])
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                } header: {
                    Text(category)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer, prompt: "Search exercises")
    }
    
    func section(_ exerciseNames : [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(exerciseNames, id: \.self) { exerciseName in
                HStack {
                    Text(exerciseName)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "chevron.right")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Material.ultraThickMaterial)
                .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
            }
        }
    }
}

#Preview {
    NavigationStack {
        ExercisesView()
    }
}
