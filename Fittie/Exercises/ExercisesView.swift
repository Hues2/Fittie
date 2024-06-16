import SwiftUI
import SwiftData

struct ExercisesView: View {
    @State private var searchText = ""
    @Query(sort: \ExerciseModel.exerciseCategoryRawValue, animation: .smooth) private var exerciseModels: [ExerciseModel]
    
    private var filteredExerciseCategories: [String: [ExerciseModel]] {
        let filteredExercises = exerciseModels.filter { exercise in
            searchText.isEmpty ||
            exercise.exerciseName.lowercased().contains(searchText.lowercased()) ||
            exercise.exerciseName.lowercased().starts(with: searchText.lowercased())
        }
        
        var groupedExercises: [String: [ExerciseModel]] = [:]
        
        for exercise in filteredExercises {
            let category = exercise.exerciseCategoryRawValue
            if groupedExercises[category] == nil {
                groupedExercises[category] = []
            }
            groupedExercises[category]?.append(exercise)
        }
        return groupedExercises
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            content
        }
        .navigationTitle("exercises_view_title")
    }
}

private extension ExercisesView {
    var content : some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) {
                ForEach(filteredExerciseCategories.keys.sorted(), id: \.self) { category in
                    let uniqueExerciseNames = Array(Set(filteredExerciseCategories[category]?.map { $0.exerciseName.lowercased() } ?? []))
                    section(category, uniqueExerciseNames)
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 8)
        }
        .searchable(text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .automatic),
                    prompt: "exercises_view_searchable_prompt")
    }
    
    func section(_ category : String, _ exerciseNames : [String]) -> some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                sectionList(exerciseNames)
                    .background(
                        Color.clear
                            .background(Color.card)
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
                    Text(exerciseName.capitalized)
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
            .foregroundStyle(Color.secondaryAccent)
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
