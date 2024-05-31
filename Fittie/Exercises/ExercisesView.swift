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
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) {
                ForEach(viewModel.filteredExerciseCategories.keys.sorted(), id:\.self) { category in
                    section(category, viewModel.filteredExerciseCategories[category] ?? [])
                }
            }
            .padding(.horizontal,16)
        }
//        List {
//            ForEach(viewModel.filteredExerciseCategories.keys.sorted(), id:\.self) { category in
//                Section {
//                    section(viewModel.filteredExerciseCategories[category] ?? [])
//                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
//                        .listRowSeparator(.hidden)
//                } header: {
//                    Text(category)
//                        .foregroundStyle(.pink)
//                }
//            }
//            .listRowBackground(
//                Color.clear
//                    .background(Material.ultraThickMaterial)
//            )
//            .listSectionSpacing(12)
//        }
//        .scrollContentBackground(.hidden)
//        .scrollIndicators(.hidden)
//        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer, prompt: "Search exercises")
    }
    
    func section(_ category : String, _ exerciseNames : [String]) -> some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                sectionList(exerciseNames)
                    .background(
                        Color.clear
                            .background(Constants.backgroundMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                    )
            }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowSeparator(.hidden)
        } header: {
            sectionCategoryTitle(category)
        }
    }
    
    func sectionList(_ exerciseNames : [String]) -> some View {
        VStack {
            ForEach(exerciseNames, id: \.self) { exerciseName in
                HStack {
                    Text(exerciseName)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.accent)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
        }
    }
    
    func sectionCategoryTitle(_ category : String) -> some View {
        Text(category)
            .font(.headline)
            .foregroundStyle(.pink)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(BackgroundView().cornerRadius(Constants.cornerRadius, corners: [.bottomLeft, .bottomRight]))
    }
}

#Preview {
    NavigationStack {
        ExercisesView()
    }
}
