import SwiftUI

struct NameInputView: View {    
    @Binding var filterText : String
    @Binding var exerciseName : String
    @Binding var filteredLoggedExercises : [Exercise]
    let numberOfExercisesInCategory : Int
    
    @FocusState private var isFocused : Bool
    @State private var showAddExerciseNameSheet : Bool = false
    
    var body: some View {
        content
    }
}

private extension NameInputView {
    var content : some View {
        VStack {
            if numberOfExercisesInCategory != 0 {
                filterSection
            } else {
                addNewNameText
            }
        }
    }
}

private extension NameInputView {
    var addNewNameText : some View {
        AddItemTextView(title: "log_exercise_name_add_new_exercise_name", font: .title)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .onTapGesture {
                self.showAddExerciseNameSheet = true
            }
    }
}

// MARK: Filter Section
private extension NameInputView {
    var filterSection : some View {
        VStack(spacing: 0) {
            filterTextField
            
            previouslyLoggedExerciseNamesView
                .frame(maxHeight: .infinity, alignment: .top)
        }
    }
    
    var filterTextField : some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            
            TextField("", text: $filterText, prompt: Text("log_exercise_name_textfield_filter_prompt"))
                .focused($isFocused)
            
            if !filterText.isEmpty {
                Button {
                    withAnimation(.snappy(duration: 0.3)) {
                        self.filterText = ""
                    }
                } label: {
                    Image(systemName: "xmark.circle")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(10)
        .background(Color.card)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        .overlay {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke(isFocused ? .accent : .clear)
        }
        .padding(2)
    }
    
    @ViewBuilder var previouslyLoggedExerciseNamesView : some View {
        VStack(spacing: 0) {
            previouslyLoggedExerciseNamesViewTitle            
            previouslyLoggedExerciseNamesListView
        }
        .padding(.top, 8)
    }
    
    var previouslyLoggedExerciseNamesViewTitle : some View {
        HStack {
            HStack(spacing: 0) {
                Text("log_exercise_saved_exercises_title")
                Text(" (\(numberOfExercisesInCategory))")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(systemName: "chevron.down")
        }
        .font(.headline)
        .foregroundStyle(Color.secondaryAccent)
        .padding(.vertical)
        .contentShape(Rectangle())
    }
    
    var previouslyLoggedExerciseNamesListView : some View {
        ScrollView {
            VStack {
                ForEach(filteredLoggedExercises) { loggedExercise in
                    HStack {
                        Text(loggedExercise.exerciseName.capitalized)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        if exerciseName.lowercased() == loggedExercise.exerciseName.lowercased() {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.accent)
                        }
                    }
                    .padding()
                    .background(Color.card)
                    .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                    .overlay {
                        RoundedRectangle(cornerRadius: Constants.cornerRadius)
                            .stroke((exerciseName.lowercased() == loggedExercise.exerciseName.lowercased()) ? .accent : .clear)
                    }
                    .padding(.horizontal, 2)
                    .onTapGesture {
                        withAnimation(.snappy(duration: 0.3)) {
                            if exerciseName == loggedExercise.exerciseName.capitalized {
                                self.exerciseName = ""
                            } else {
                                self.exerciseName = loggedExercise.exerciseName.capitalized
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    Color.background
        .sheet(isPresented: .constant(true), content: {
            ZStack {
                BackgroundView()
                NameInputPreview()
                .padding()
            }
            .presentationCornerRadius(Constants.cornerRadius)
        })
}

fileprivate struct NameInputPreview : View {
    @State private var name : String = ""
    @State private var filterText : String = ""
    
    var body: some View {
        NameInputView(filterText: $filterText,
                      exerciseName: $name,
                      filteredLoggedExercises: .constant([Exercise(exerciseCategoryRawValue: "Chest", exerciseName: "Bench press")]),
                      numberOfExercisesInCategory: 2)
    }
}
