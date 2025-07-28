//
//  UploadView.swift
//  Arthouse
//
//  Created by Roberto Chavez on 7/21/25.
//

import SwiftUI

struct UploadView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var caption = ""
    @State private var selectedMediaType: MediaType = .photo
    @State private var isPosting = false
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var selectedImage: UIImage?
    
    enum MediaType: String, CaseIterable {
        case photo = "Photo"
        case video = "Video"
        case audio = "Audio Files"
        
        var icon: String {
            switch self {
            case .photo: return "camera.fill"
            case .video: return "video.fill"
            case .audio: return "waveform"
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        postContent()
                    }) {
                        if isPosting {
                            Text("Posting...")
                                .fontWeight(.semibold)
                        } else {
                            Text("Post")
                                .fontWeight(.semibold)
                        }
                    }
                    .disabled(isPosting || caption.isEmpty)
                    .foregroundColor(.white)
                }
                .padding()
                .background(Color(red: 173/255, green: 198/255, blue: 255/255))
                
                // Media type tabs
                HStack(spacing: 0) {
                    ForEach(MediaType.allCases, id: \.self) { mediaType in
                        Button(action: {
                            selectedMediaType = mediaType
                        }) {
                            VStack(spacing: 4) {
                                Image(systemName: mediaType.icon)
                                    .font(.system(size: 18))
                                Text(mediaType.rawValue)
                                    .font(.caption)
                            }
                            .foregroundColor(selectedMediaType == mediaType ? Color(red: 173/255, green: 198/255, blue: 255/255) : .white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                        }
                    }
                }
                .background(Color.black.opacity(0.8))
                
                // Main camera/preview area
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        // Camera preview area
                        ZStack {
                            if let selectedImage = selectedImage {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width, height: geometry.size.width)
                                    .clipped()
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: geometry.size.width, height: geometry.size.width)
                                    .overlay(
                                        VStack(spacing: 16) {
                                            Image(systemName: selectedMediaType.icon)
                                                .font(.system(size: 50))
                                                .foregroundColor(.white.opacity(0.7))
                                            
                                            Text("Tap to capture \(selectedMediaType.rawValue.lowercased())")
                                                .foregroundColor(.white.opacity(0.7))
                                                .font(.headline)
                                        }
                                    )
                                    .onTapGesture {
                                        if selectedMediaType == .photo {
                                            showingCamera = true
                                        }
                                    }
                            }
                            
                            // Camera controls overlay
                            if selectedImage == nil {
                                VStack {
                                    Spacer()
                                    
                                    HStack {
                                        Button(action: {
                                            showingImagePicker = true
                                        }) {
                                            Image(systemName: "photo.on.rectangle")
                                                .font(.system(size: 24))
                                                .foregroundColor(.white)
                                                .frame(width: 50, height: 50)
                                                .background(Color.black.opacity(0.6))
                                                .clipShape(Circle())
                                        }
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            if selectedMediaType == .photo {
                                                showingCamera = true
                                            } else if selectedMediaType == .video {
                                                print("Start video recording")
                                            } else if selectedMediaType == .audio {
                                                print("Start audio recording")
                                            }
                                        }) {
                                            ZStack {
                                                Circle()
                                                    .fill(Color.white)
                                                    .frame(width: 70, height: 70)
                                                
                                                Circle()
                                                    .fill(selectedMediaType == .video ? Color.red : Color.white)
                                                    .frame(width: 60, height: 60)
                                                    .overlay(
                                                        Circle()
                                                            .stroke(Color.black, lineWidth: 2)
                                                    )
                                                
                                                if selectedMediaType == .audio {
                                                    Image(systemName: "mic.fill")
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 20))
                                                }
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            print("Switch camera")
                                        }) {
                                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                                .font(.system(size: 24))
                                                .foregroundColor(.white)
                                                .frame(width: 50, height: 50)
                                                .background(Color.black.opacity(0.6))
                                                .clipShape(Circle())
                                        }
                                    }
                                    .padding(.horizontal, 30)
                                    .padding(.bottom, 30)
                                }
                            }
                        }
                        
                        Spacer()
                    }
                }
                
                // Description area (only show if image is selected)
                if selectedImage != nil {
                    HStack(alignment: .top) {
                        Circle()
                            .fill(Color.gray.opacity(0.4))
                            .frame(width: 40, height: 40)
                            .overlay(Image(systemName: "person.fill").foregroundColor(.white))
                        
                        ZStack(alignment: .topLeading) {
                            if caption.isEmpty {
                                Text("Add a description . . .")
                                    .foregroundColor(.gray)
                                    .padding(8)
                            }
                            
                            TextEditor(text: $caption)
                                .padding(8)
                                .frame(height: 80)
                                .background(Color.white)
                                .cornerRadius(8)
                                .opacity(0.95)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                    .padding(.bottom, 20)
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .fullScreenCover(isPresented: $showingCamera) {
            CameraView(selectedImage: $selectedImage)
        }
    }
    
    func postContent() {
        guard !caption.isEmpty else {
            print("Caption is required")
            return
        }
        
        guard let username = authVM.currentUser?.username else {
            print("User not logged in")
            return
        }
        
        isPosting = true
        
        guard let url = URL(string: "http://localhost:5001/api/posts") else {
            print("Invalid URL")
            isPosting = false
            return
        }
        
        let postData = [
            "username": username,
            "caption": caption,
            "media_type": selectedMediaType.rawValue
        ]
        
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
        picker.allowsEditing = true
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
            if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

// Camera View
struct CameraView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    UploadView()
}
