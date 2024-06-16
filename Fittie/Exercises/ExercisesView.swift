import SwiftUI
import SwiftData

struct ExercisesView: View {
    @State private var searchText = ""
    @Query(sort: \ExerciseModel.exerciseCategoryRawValue, animation: .smooth) private var allExerciseModels: [ExerciseModel]
    @State private var filteredExercises : [String: [ExerciseModel]] = [:]
    
    var body: some View {
        ZStack {
            BackgroundView()
            content
        }
        .navigationTitle("exercises_view_title")
        .onAppear {
            setFilteredExercises()
        }
        .onChange(of: searchText) { oldValue, newValue in
            setFilteredExercises()
        }
    }
    
    func setFilteredExercises() {
        var seenNames = Set<String>()
        
        let filteredExercises = allExerciseModels.filter { exercise in
            let isMatch = searchText.isEmpty || exercise.exerciseName.lowercased().contains(searchText.lowercased())
            let isUnique = seenNames.insert(exercise.exerciseName.lowercased()).inserted
            return isMatch && isUnique
        }
        withAnimation {
            self.filteredExercises = Dictionary(grouping: filteredExercises, by: { $0.exerciseCategoryRawValue })
        }
    }
}

private extension ExercisesView {
    var content : some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) {
                ForEach(filteredExercises.keys.sorted(), id: \.self) { category in
                    section(category, filteredExercises[category]?.map({ $0.exerciseName.lowercased() }) ?? [])
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
