//
//  ContentView.swift
//  MedMinder
//
//  Created by Davide Aliti on 20/06/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // MARK: - Properties
    @State private var showingAddMedicineReminderView: Bool = false
    @State private var animatingAddButton: Bool = false

    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \MedicineReminder.medicineName, ascending: true)],
        animation: .default)
    private var medicineReminders: FetchedResults<MedicineReminder>
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(medicineReminders) { medicineReminder in
                        NavigationLink {
                            Text(medicineReminder.medicineName ?? "Unknown medicine name")
                        } label: {
                            HStack {
                                Text(medicineReminder.medicineName ?? "Unknown medicine name")
                                Spacer()
                                Text(medicineReminder.medicineFrequency ?? "Unknown medicine frequency")
                            }
                        }
                    }
                    .onDelete(perform: deleteMedicineReminders)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: addMedicineReminder) {
                            Label("Add Medicine Reminder", systemImage: "plus")
                        }
                    }
                }
                .navigationTitle("MedMinder")
                .navigationBarTitleDisplayMode(.inline)
                if medicineReminders.count == 0 {
                    EmptyMedicineReminderListView()
                }
            } //: ZStack
            .sheet(isPresented: $showingAddMedicineReminderView) {
                AddMedicineReminderView().environment(\.managedObjectContext, self.viewContext)
            }
            .overlay(
                ZStack {
                    Group {
                        Circle()
                            .fill(.blue)
                            .opacity(self.animatingAddButton ? 0.2 : 0)
                            .scaleEffect(self.animatingAddButton ? 1 : 0)
                            .frame(width: 68, height: 68, alignment: .center)
                        Circle()
                            .fill(.blue)
                            .opacity(self.animatingAddButton ? 0.15 : 0)
                            .scaleEffect(self.animatingAddButton ? 1 : 0)
                            .frame(width: 88, height: 88, alignment: .center)
                    }
                    .animation(.easeOut(duration: 2).repeatForever(autoreverses: true), value: self.animatingAddButton)
                    Button(action: {
                        self.showingAddMedicineReminderView.toggle()
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .background(Circle().fill(Color(uiColor: .white)))
                            .frame(width: 48, height: 48, alignment: .center)
                    }) //: Button
                    .onAppear {
                        DispatchQueue.main.async {
                            self.animatingAddButton.toggle()
                        }
                    }
                } //: ZStack
                    .padding(.bottom, 15)
                    .padding(.trailing, 15)
                , alignment: .bottomTrailing
            )
        }
    }
    
    // MARK: - Methods
    private func addMedicineReminder() {
        self.showingAddMedicineReminderView.toggle()
    }
    
    private func deleteMedicineReminders(offsets: IndexSet) {
        withAnimation {
            offsets.map { medicineReminders[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
