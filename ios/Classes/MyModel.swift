import Foundation
import FamilyControls
import ManagedSettings

@available(iOS 15.0, *)
private let _MyModel = MyModel()

@available(iOS 15.0, *)
class MyModel: ObservableObject {
    let store = ManagedSettingsStore()

    @Published var selectionToDiscourage: FamilyActivitySelection
    @Published var selectionToEncourage: FamilyActivitySelection
    @Published var isBlocking: Bool = false // Track blocking state

    init() {
        selectionToDiscourage = FamilyActivitySelection()
        selectionToEncourage = FamilyActivitySelection()
    }

    class var shared: MyModel {
        return _MyModel
    }

    /// Original method for backward compatibility
    func setShieldRestrictions() {
        print("setShieldRestrictions - applying restrictions immediately")
        let applications = MyModel.shared.selectionToDiscourage

        if applications.applicationTokens.isEmpty {
            print("empty applicationTokens")
        }
        if applications.categoryTokens.isEmpty {
            print("empty categoryTokens")
        }

        store.shield.applications = applications.applicationTokens.isEmpty ? nil : applications.applicationTokens
        store.shield.applicationCategories = applications.categoryTokens.isEmpty
            ? nil
            : ShieldSettings.ActivityCategoryPolicy.specific(applications.categoryTokens)
        
        isBlocking = true
    }
    
    /// New method: Save app selection without applying restrictions
    func saveAppSelection() {
        print("saveAppSelection - apps saved for later blocking")
        // Selection is automatically saved in selectionToDiscourage
        // No restrictions applied here
    }
    
    /// New method: Enable blocking for previously selected apps
    func enableShieldRestrictions() {
        print("enableShieldRestrictions - activating blocks")
        let applications = MyModel.shared.selectionToDiscourage
        
        store.shield.applications = applications.applicationTokens.isEmpty ? nil : applications.applicationTokens
        store.shield.applicationCategories = applications.categoryTokens.isEmpty
            ? nil
            : ShieldSettings.ActivityCategoryPolicy.specific(applications.categoryTokens)
        
        isBlocking = true
    }
    
    /// New method: Disable all app restrictions
    func disableShieldRestrictions() {
        print("disableShieldRestrictions - removing all blocks")
        
        // Remove all restrictions
        store.shield.applications = nil
        store.shield.applicationCategories = nil
        
        isBlocking = false
    }
}