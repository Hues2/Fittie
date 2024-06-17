import SwiftUI
import SwiftData

struct ExercisesView: View {
    @State private var searchText = ""
    @Query(sort: \ExerciseModel.exerciseCategoryRawValue, animation: .smooth) private var allExerciseModels: [ExerciseModel]
    @State private var filteredExercises : [String: [ExerciseModel]] = [:]
    @State private var showNoFilteredExercisesView : Bool = false
    
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
            let isMatch = searchText.isEmpty ||
            exercise.exerciseName.lowercased().contains(searchText.lowercased()) ||
            exercise.exerciseCategoryRawValue.lowercased().contains(searchText.lowercased())
            
            let isUnique = seenNames.insert(exercise.exerciseName.lowercased()).inserted
            return isMatch && isUnique
        }
        withAnimation(.snappy) {
            self.filteredExercises = Dictionary(grouping: filteredExercises, by: { $0.exerciseCategoryRawValue })
            self.showNoFilteredExercisesView = self.filteredExercises.isEmpty
        }
    }
}

// MARK: Content
private extension ExercisesView {
    var content : some View {
        VStack {
            if allExerciseModels.isEmpty {
                // User hasn't logged any exercises yet
                noExerciseModelsView
            } else if showNoFilteredExercisesView {
                // User has filtered the list of all exercise models, but there are no matches
                noFilteredExercisesView
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) {
                        ForEach(filteredExercises.keys.sorted(), id: \.self) { category in
                            section(category, filteredExercises[category]?.map({ $0.exerciseName.lowercased() }) ?? [])
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 8)
                }
            }
        }
        .if(!allExerciseModels.isEmpty, transform: { view in
            view
                .searchable(text: $searchText,
                            placement: .navigationBarDrawer(displayMode: .automatic),
                            prompt: "exercises_view_searchable_prompt")
        })
    }
}

// MARK: Section
private extension ExercisesView {
    func section(_ category : String, _ exerciseNames : [String]) -> some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                sectionList(exerciseNames)
                    .background(
                        Color.card
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
            .fontWeight(.light)
            .foregroundStyle(Color.secondaryAccent)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(BackgroundView().cornerRadius(Constants.cornerRadius, corners: [.bottomLeft, .bottomRight]))
    }
}

// MARK: No exercise models view
private extension ExercisesView {
    var noExerciseModelsView : some View {
        CustomContentUnavailableView(title: "exercises_view_no_models_title",
                                     description: "exercises_view_no_models_description",
                                     buttonTitle: "exercises_view_no_models_button_title") {
            // Route user to the workouts tab
        }
                                     .padding()
    }
}


// MARK: No filtered exercises view
private extension ExercisesView {
    var noFilteredExercisesView : some View {
        CustomContentUnavailableView(icon: "magnifyingglass.circle",
                                     title: "exercises_view_no_matching_exercises_title",
                                     description: "exercises_view_no_matching_exercises_description",
                                     buttonTitle: "exercises_view_no_matching_exercises_button_title") {
            // Clear search
            withAnimation(.snappy) {
                self.searchText = ""
            }
        }
                                     .padding()
    }
}

#Preview {
    NavigationStack {
        ExercisesView()
    }
}
