//
//  UploadView.swift
//  Arthouse
//
//  Created on 7/21/25.
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
    let maxCharacters = 280
    
    var body: some View {
        VStack(spacing: 0) {
            // Top header section
            HStack {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.blue)
                .font(.system(size: 17, weight: .medium))
                
                Spacer()
                
                Text("New Post")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Button("Post") {
                    postContent()
                }
                .foregroundColor(canPost() ? .blue : .gray)
                .font(.system(size: 17, weight: .semibold))
                .disabled(!canPost() || isPosting)
                
                if isPosting {
                    ProgressView()
                        .scaleEffect(0.8)
                        .padding(.leading, 8)
                }
            }
            .padding()
            .background(Color(red: 173/255, green: 198/255, blue: 255/255))
            
            // Media selection tabs
            HStack(spacing: 0) {
                ForEach(mediaTypes, id: \.self) { type in
                    Button(action: {
                        selectedMediaType = type
                    }) {
                        VStack(spacing: 6) {
                            Image(systemName: iconForMediaType(type))
                                .font(.system(size: 22, weight: .medium))
                            Text(type)
                                .font(.system(size: 13, weight: .medium))
                        }
                        .foregroundColor(selectedMediaType == type ? .blue : .gray)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            selectedMediaType == type ?
                            Color.blue.opacity(0.1) : Color.clear
                        )
                    }
                }
            }
            .background(Color(.systemGray6))
            
            // Main camera/photo area
            ZStack {
                LinearGradient(
                    colors: [Color.black, Color.black.opacity(0.8)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                if let selectedImage = selectedImage {
                    // Show the selected photo
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 400)
                            .cornerRadius(16)
                            .shadow(color: .white.opacity(0.1), radius: 10, x: 0, y: 5)
                        
                        Button("Change Photo") {
                            showingImagePicker = true
                        }
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium))
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            LinearGradient(
                                colors: [Color.blue, Color.blue.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(25)
                        .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                        
                        Spacer()
                    }
                } else {
                    // Camera interface when no photo selected
                    VStack {
                        Spacer()
                        
                        // Instructions for user
                        VStack(spacing: 8) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 48))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text("Capture Your Art")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text("Take a photo or choose from gallery")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.bottom, 40)
                        
                        Spacer()
                        
                        // Camera controls at bottom
                        HStack(spacing: 50) {
                            // Gallery button
                            Button(action: {
                                showingImagePicker = true
                            }) {
                                VStack(spacing: 8) {
                                    Image(systemName: "photo.on.rectangle")
                                        .font(.system(size: 28, weight: .medium))
                                        .foregroundColor(.white)
                                        .frame(width: 56, height: 56)
                                        .background(Color.white.opacity(0.2))
                                        .clipShape(Circle())
                                    
                                    Text("Gallery")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.white.opacity(0.8))
                                }
                            }
                            
                            // Main capture button
                            Button(action: {
                                if selectedMediaType == "Photo" {
                                    showingCamera = true
                                }
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 76, height: 76)
                                    
                                    Circle()
                                        .fill(selectedMediaType == "Photo" ? Color.white : Color.red)
                                        .frame(width: 64, height: 64)
                                        .overlay(
                                            Circle()
                                                .stroke(selectedMediaType == "Photo" ? Color.black.opacity(0.1) : Color.white, lineWidth: 2)
                                        )
                                }
                                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            
                            // Camera flip button
                            Button(action: {
                                // TODO: Add camera switching functionality
                            }) {
                                VStack(spacing: 8) {
                                    Image(systemName: "camera.rotate")
                                        .font(.system(size: 28, weight: .medium))
                                        .foregroundColor(.white)
                                        .frame(width: 56, height: 56)
                                        .background(Color.white.opacity(0.2))
                                        .clipShape(Circle())
                                    
                                    Text("Flip")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.white.opacity(0.8))
                                }
                            }
                        }
                        .padding(.bottom, 60)
                    }
                }
            }
            
            // Caption section (only shows when photo is selected)
            if selectedImage != nil {
                VStack(spacing: 0) {
                    // Caption header with character counter
                    HStack {
                        Text("Add Caption")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        // Character counter with color coding
                        Text("\(maxCharacters - caption.count)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(characterCountColor())
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(characterCountColor().opacity(0.1))
                            .clipShape(Capsule())
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    
                    // Text input area
                    ZStack(alignment: .topLeading) {
                        if caption.isEmpty {
                            Text("What's the story behind this photo?")
                                .font(.system(size: 16))
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                        }
                        
                        TextEditor(text: $caption)
                            .font(.system(size: 16))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .frame(minHeight: 100)
                            .onChange(of: caption) { newValue in
                                // Stop user from going over character limit
                                if newValue.count > maxCharacters {
                                    caption = String(newValue.prefix(maxCharacters))
                                }
                            }
                    }
                    .background(Color.white)
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .sheet(isPresented: $showingCamera) {
            CameraPicker(selectedImage: $selectedImage)
        }
    }
    
    // Helper functions
    func iconForMediaType(_ type: String) -> String {
        switch type {
        case "Photo": return "camera"
        case "Video": return "video"
        case "Audio": return "mic"
        default: return "camera"
        }
    }
    
    // Changes color of character counter based on how close to limit
    private func characterCountColor() -> Color {
        let remaining = maxCharacters - caption.count
        if remaining < 20 { return .red }
        if remaining < 50 { return .orange }
        return .secondary
    }
    
    // Checks if post is ready to be submitted
    private func canPost() -> Bool {
        return selectedImage != nil &&
               !caption.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               caption.count <= maxCharacters
    }
    
    func postContent() {
        guard canPost() else {
            print("Can't post yet - missing image or caption")
            return
        }
        
        guard let currentUser = authVM.currentUser else {
            print("No user logged in")
            return
        }
        
        isPosting = true
        
        // Convert the image to base64 for uploading
        var imageBase64: String? = nil
        if let image = selectedImage,
           let imageData = image.jpegData(compressionQuality: 0.8) {
            imageBase64 = imageData.base64EncodedString()
        }
        
        guard let url = URL(string: "http://127.0.0.1:5001/api/posts") else {
            print("Bad URL")
            isPosting = false
            return
        }
        
        var postData: [String: Any] = [
            "username": currentUser.username,
            "caption": caption.trimmingCharacters(in: .whitespacesAndNewlines),
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
            print("Failed to package post data")
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
                    print("No response data")
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        if let success = json["success"] as? Bool, success {
                            print("✅ Post uploaded successfully!")
                            // Clear everything and go back
                            caption = ""
                            selectedImage = nil
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            print("❌ Post failed: \(json["error"] ?? "Unknown error")")
                        }
                    }
                } catch {
                    print("Couldn't parse server response")
                }
            }
        }.resume()
    }
}

// Image picker for photo library
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

// Camera picker for taking new photos
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
