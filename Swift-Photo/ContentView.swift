//
//  ContentView.swift
//  Swift-Photo
//
//  Created by k2hoon on 2023/07/08.
//

import SwiftUI
import Photos
import PhotosUI

struct ContentView: View {
    @StateObject var viewModel = ProfileViewModel()
    @State private var present = false
    @State private var errorPresent = false
    @State private var confirmPresent = false
    @State private var errorDescription = ""
    
    private var isPreventAlert: Bool { Bundle.main.object(forInfoDictionaryKey: "PHPhotoLibraryPreventAutomaticLimitedAccessAlert") as? Bool ?? false }
    private let permission = Permission()
    
    var phpickerButton: some View {
        Button(action: { self.getRequestStatus() }) {
            Text("PHPicker")
        }
        .alert(
            "Photo Alert",
            isPresented: $errorPresent,
            actions: {
                Button("Settings", action: { self.openSettings() })
                Button("Cancel", role: .cancel, action: {})
            },
            message: {
                Text(self.errorDescription)
            }
        )
        .if(isPreventAlert) { view in
            // When prevent limited photos access alert is 'YES'
            view.confirmationDialog(
                "Photo Dialog",
                isPresented: $confirmPresent,
                actions: {
                    Button("Select more photos", action: {
                        // TODO: present view or action.
                    })
                    Button("Allow access to all photos", action: { self.openSettings() })
                    Button("Cancel", role: .cancel, action: {})
                },
                message: {
                    Text("Select more photos or go to Settings to allow access to all photos.")
                }
            )
        }
        .sheet(isPresented: $present) {
            PHLimitAccessView()
        }
    }
    
    var photoPickerButton: some View {
        PhotosPicker(
            selection: $viewModel.imageSelection,
            matching: .images,
            photoLibrary: .shared()
        ) {
            Text("PhotosPicker")
        }
        .buttonStyle(.borderless)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                CircularProfileImage(viewModel: self.viewModel)
                
                self.phpickerButton
                
                self.photoPickerButton
                
                Spacer()
            }
            .navigationTitle("Profile")
        }
    }
    
    private func getRequestStatus() {
        self.permission.requestPhotoStatus { status in
            switch status {
            case .authorized:
                self.present.toggle()
            case .limited:
                self.isPreventAlert ? self.confirmPresent.toggle() : self.present.toggle()
            default:
                self.requestPermission()
            }
        }
    }
    
    private func requestPermission() {
        self.permission.requestPhoto { error in
            if let error = error {
                self.errorDescription = error.localizedDescription
                self.errorPresent.toggle()
            } else {
                self.present.toggle()
            }
        }
    }
    
    private func openSettings() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
