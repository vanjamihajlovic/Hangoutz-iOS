//
//  photoPickerViewModel.swift
//  HangoutziOS
//
//  Created by Aleksa on 11/28/24.
//

import SwiftUI
import PhotosUI

@MainActor
final class PhotoPickerViewModel: ObservableObject {
    
    @AppStorage("currentUserEmail") var currentUserEmail: String?
    @Published private(set) var selectedImage: UIImage? = nil
    @State private var isUploading = false
    @State private var uploadStatus: String = ""
    var userService : UserService = UserService()
    
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(from: imageSelection)
        }
    }
    private func setImage(from selection: PhotosPickerItem?) {
        guard let selection else { return }
        
        Task {
            do {
                let data = try await selection.loadTransferable(type: Data.self)
                
                guard let data, let uiImage = UIImage(data: data) else {
                    throw URLError(.badServerResponse)
                }
                selectedImage = uiImage
            } catch {
                print(error)
            }
        }
    }
}
