//
//  AddMedicineReminderView.swift
//  MedMinder
//
//  Created by Davide Aliti on 27/06/22.
//

import SwiftUI

struct AddMedicineReminderView: View {
    // MARK: - Properties
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var viewContext

    @State private var medicineName: String = ""
    @State private var medicineFrequency: String = "Daily"
    @State private var errorShowing: Bool = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
    
    let frequencies = ["Daily", "Weekly", "Other"]
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 20) {
                    TextField("Medicine Name", text: $medicineName)
                        .padding()
                        .background(Color(.tertiarySystemFill))
                        .cornerRadius(9)
                        .font(.system(size: 24, weight: .bold, design: .default))
                    Picker("Medicine Frequency", selection: $medicineFrequency) {
                        ForEach(frequencies, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    Button {
                        if self.medicineName != "" {
                            let medicineReminder = MedicineReminder(context: viewContext)
                            medicineReminder.id = UUID()
                            medicineReminder.medicineName = self.medicineName
                            medicineReminder.medicineFrequency = self.medicineFrequency
                            do {
                                try viewContext.save()
                            } catch {
                                print("Error while saving: \(error)")
                            }
                            self.presentationMode.wrappedValue.dismiss()
                        } else {
                            self.errorShowing = true
                            self.errorTitle = "Invalid medicine name"
                            self.errorMessage = "Make sure to enter something for the new medicine reminder"
                            return
                        }
                    } label: {
                        Text("Save")
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(.blue)
                            .cornerRadius(9)
                            .foregroundColor(.white)
                    }
                } //: VStack
                .padding(.horizontal)
                .padding(.vertical, 30)
                Spacer()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                self.presentationMode.wrappedValue.dismiss()
                            } label: {
                                Image(systemName: "xmark")
                            }

                        }
                    }
            } //: VStack
            .navigationTitle("New Medicine Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $errorShowing) {
                Alert(title: Text(self.errorTitle), message: Text(self.errorMessage), dismissButton: .default(Text("OK")))
            }
            
        } // NavigationView
    }
}

// MARK: - Preview
struct AddMedicineReminderView_Previews: PreviewProvider {
    static var previews: some View {
        AddMedicineReminderView()
    }
}
