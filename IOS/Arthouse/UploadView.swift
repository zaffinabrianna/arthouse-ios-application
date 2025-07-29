//
//  UploadView.swift
//  Arthouse
//
//  Created by Roberto Chavez on 7/21/25.
//

import SwiftUI
import PhotosUI

struct UploadView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authVM: AuthViewModel
    
    @State private var caption = ""
    @State private var selectedMediaType = "Photo"
    @State private var isPosting = false
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    
    let mediaTypes = ["Photo", "Video", "Audio"]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.blue)
                
                Spacer()
                
                Button("Post") {
                    postContent()
                }
                .foregroundColor(.blue)
                .fontWeight(.semibold)
                .disabled(caption.isEmpty || isPosting)
                .opacity((caption.isEmpty || isPosting) ? 0.5 : 1.0)
                
                if isPosting {
                    ProgressView()
                        .scaleEffect(0.8)
                        .padding(.leading, 8)
                }
            }
            .padding()
            .background(Color(red: 173/255, green: 198/255, blue: 255/255))
            
            // Media Type Tabs
            HStack(spacing: 0) {
                ForEach(mediaTypes, id: \.self) { type in
                    Button(action: {
                        selectedMediaType = type
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: iconForMediaType(type))
                                .font(.system(size: 20))
                            Text(type)
                                .font(.system(size: 12, weight: .medium))
                        }
                        .foregroundColor(selectedMediaType == type ? .blue : .gray)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                    }
                }
            }
            .background(Color.black.opacity(0.05))
            
            // Main Content Area
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                if let selectedImage = selectedImage {
                    // Show selected image
                    VStack(spacing: 16) {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 300)
                            .cornerRadius(12)
                        
                        Button("Change Photo") {
                            showingImagePicker = true
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .cornerRadius(20)
                    }
                } else {
                    // Camera interface with controls at bottom
                    VStack {
                        Spacer() // Push everything to bottom
                        
                        // Camera controls at bottom
                        HStack(spacing: 40) {
                            // Gallery button
                            Button(action: {
                                showingImagePicker = true
                            }) {
                                Image(systemName: "photo.on.rectangle")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                            }
                            
                            // Capture button
                            Button(action: {
                                if selectedMediaType == "Photo" {
                                    showingCamera = true
                                }
                            }) {
                                Circle()
                                    .fill(selectedMediaType == "Photo" ? Color.white : Color.red)
                                    .frame(width: 70, height: 70)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white, lineWidth: 3)
                                            .frame(width: 80, height: 80)
                                    )
                            }
                            
                            // Switch camera button
                            Button(action: {
                                // Camera switch functionality
                            }) {
                                Image(systemName: "camera.rotate")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.bottom, 50) // Add bottom padding
                    }
                }
            }
            
            // Caption Input (only show if image is selected)
            if selectedImage != nil {
                VStack(spacing: 8) {
                    TextEditor(text: $caption)
                        .frame(minHeight: 100)
                        .padding(8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    
                    HStack {
                        Text("Add a caption...")
                            .foregroundColor(.gray)
                            .font(.caption)
                        Spacer()
                        Text("\(300 - caption.count)")
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                }
                .padding()
                .background(Color.white)
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .sheet(isPresented: $showingCamera) {
            CameraPicker(selectedImage: $selectedImage)
        }
    }
    
    func iconForMediaType(_ type: String) -> String {
        switch type {
        case "Photo": return "camera"
        case "Video": return "video"
        case "Audio": return "mic"
        default: return "camera"
        }
    }
    
    func postContent() {
        guard !caption.isEmpty else {
            print("Caption is required")
            return
        }
        
        guard let currentUser = authVM.currentUser else {
            print("No user logged in")
            return
        }
        
        isPosting = true
        
        // Convert image to base64 if available
        var imageBase64: String? = nil
        if let image = selectedImage,
           let imageData = image.jpegData(compressionQuality: 0.8) {
            imageBase64 = imageData.base64EncodedString()
        }
        
        guard let url = URL(string: "http://localhost:5001/api/posts") else {
            print("Invalid URL")
            isPosting = false
            return
        }
        
        var postData: [String: Any] = [
            "username": currentUser.username,
            "caption": caption,
            "media_type": selectedMediaType
        ]
        
        if let imageBase64 = imageBase64 {
            postData["image_data"] = imageBase64
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postData)
        } catch {
            print("Failed to encode post data")
            isPosting = false
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isPosting = false
                
                if let error = error {
                    print("Network error: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        if let success = json["success"] as? Bool, success {
                            print("✅ Post created successfully!")
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            print("❌ Post creation failed: \(json["error"] ?? "Unknown error")")
                        }
                    }
                } catch {
                    print("Failed to parse response")
                }
            }
        }.resume()
    }
}

// Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

// Camera Picker
struct CameraPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraPicker
        
        init(_ parent: CameraPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
