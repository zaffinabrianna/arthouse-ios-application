//
//  UploadView.swift
//  Arthouse
//
//  Created by Roberto Chavez on 7/21/25.
//
import SwiftUI

struct UploadView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var caption = ""
    @State private var selectedMediaType = "Choose a Media Type"
    @State private var isDropdownOpen = false
    @State private var isPosting = false
    
    let mediaTypes = ["Photo", "Video", "Audio Files"]
    
    var body: some View {
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
                    Text("Post")
                        .fontWeight(.semibold)
                }
                .disabled(isPosting)
                .foregroundColor(.white)
            }
            .padding()
            .background(Color(red: 173/255, green: 198/255, blue: 255/255)) // Light blue background
            
            // Media Type Dropdown
            VStack(spacing: 0) {
                Button(action: {
                    withAnimation {
                        isDropdownOpen.toggle()
                    }
                }) {
                    HStack {
                        Text(selectedMediaType)
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: isDropdownOpen ? "chevron.up" : "chevron.down")
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                }
                
                if isDropdownOpen {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(mediaTypes, id: \.self) { type in
                            Button(action: {
                                selectedMediaType = type
                                isDropdownOpen = false
                            }) {
                                Text(type)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                }
            }
            .padding()
            
            // Description Area
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
                        .frame(height: 100)
                        .background(Color.white)
                        .cornerRadius(8)
                        .opacity(0.95)
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Footer with char count and upload icon
            HStack {
                Text("\(300 - caption.count)")
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "arrow.up.circle.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 24))
            }
            .padding()
            .background(Color(red: 173/255, green: 198/255, blue: 255/255)) // Light blue
            
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color.white)
    }
    
    func postContent() {
        isPosting = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            print("Posted media type: \(selectedMediaType), caption: \(caption)")
            isPosting = false
            presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    UploadView()
}
