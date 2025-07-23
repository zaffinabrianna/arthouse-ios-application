//
//  UploadView.swift
//  Arthouse
//
//  Created by Roberto Chavez on 7/21/25.
//

import SwiftUI

struct UploadView: View {
    @State private var caption = ""
    @State private var selectedImage = false
    @State private var isPosting = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Image placeholder
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(
                        VStack(spacing: 20) {
                            Image(systemName: "photo.on.rectangle")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            
                            Button(action: {
                                // TODO: open image picker
                                print("Select photo tapped")
                                selectedImage = true
                            }) {
                                Text("Select Photo")
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                    )
                    .padding()
                
                // Caption input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Caption")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    TextEditor(text: $caption)
                        .padding(8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .frame(height: 100)
                        .padding(.horizontal)
                }
                
                Spacer()
                
                // Post button
                Button(action: {
                    postContent()
                }) {
                    HStack {
                        if isPosting {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        }
                        Text(isPosting ? "Posting..." : "Post")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedImage ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(!selectedImage || isPosting)
                }
                .padding()
            }
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    func postContent() {
        isPosting = true
        
        // fake post upload
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            print("Posted with caption: \(caption)")
            isPosting = false
            presentationMode.wrappedValue.dismiss()
        }
    }
}
