import SwiftUI

struct NameInputView: View {
    @Binding var exerciseName : String
    @Binding var filteredLoggedExercises : [Exercise]
    let numberOfExercisesInCategory : Int
    
    var body: some View {
        exerciseNameInput
    }
}

private extension NameInputView {
    var exerciseNameInput : some View {
        VStack(spacing: 16) {
            exerciseNameTextField
            
            previouslyLoggedExerciseNamesView
                .frame(maxHeight: .infinity, alignment: .top)
        }
    }
    
    var exerciseNameTextField : some View {
        HStack {
            TextField("", text: $exerciseName, prompt: Text("log_exercise_name_textfield_prompt"))
            
            if !exerciseName.isEmpty {
                Button {
                    withAnimation(.smooth) {
                        self.exerciseName = ""
                    }
                } label: {
                    Image(systemName: "xmark.circle")
                        .foregroundStyle(Color.secondaryAccent)
                        .font(.title3)
                }
            }
        }
        .padding()
        .background(Color.card)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
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
                    withAnimation {
                        if exerciseName == loggedExercise.exerciseName.capitalized {
                            self.exerciseName = ""
                        } else {
                            self.exerciseName = loggedExercise.exerciseName.capitalized
                        }
                    }
                }
            }
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
    var body: some View {
        NameInputView(exerciseName: $name,
                      filteredLoggedExercises: .constant([Exercise(exerciseCategoryRawValue: "Chest", exerciseName: "Bench press")]),
                      numberOfExercisesInCategory: 2)
    }
}
