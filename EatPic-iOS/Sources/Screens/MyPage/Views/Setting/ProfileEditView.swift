//
//  ProfileEditView.swift
//  EatPic-iOS
//
//  Created by 이은정 on 8/15/25.
//

import SwiftUI

struct ProfileEditView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var nickname: String = "잇콩"
    @State private var id: String = "itcong"
    @State private var introduction: String = "내용"
    @State private var showEditProfileImageDialog = false
    
    var body: some View {
        VStack {
            
            topNavigationBar
            
            Spacer().frame(height: 24)
            
            profileImageEditView
            
            Spacer().frame(height: 23)
            
            profileInfoEditView
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .navigationBarHidden(true)
        
    }
    
    // MARK: 상단 네비게이션 바
    private var topNavigationBar: some View {
        HStack {
            Button("취소") {
                print("취소하기")
                dismiss()
            }
            .foregroundStyle(Color.gray060)
            .font(.dsBody)
            
            Spacer()
            
            Text("프로필 수정")
                .foregroundStyle(Color.gray080)
                .font(.dsTitle2)
            
            Spacer()
            
            Button("저장") {
                print("저장하지")
                dismiss()
            }
            .foregroundStyle(Color.gray080)
            .font(.dsHeadline)
        }
        .padding(.vertical, 15)
    }
    
    // MARK: 프로필 이미지 수정 뷰
    private var profileImageEditView: some View {
        ZStack {
            Image("img_mypage_itcong")
                .resizable()
                .frame(width: 130, height: 130)

            Button(action: {
                showEditProfileImageDialog = true
            }, label: {
                Image("btn_home_record")
                    .resizable()
                    .frame(width: 40, height: 40)
            })
            .offset(x: 50, y: 45)
            .confirmationDialog(
                "프로필 사진 설정",
                isPresented: $showEditProfileImageDialog,
                titleVisibility: .visible
            ) {
                Button("갤러리") {
                    print("갤러리 버튼 클릭")
                }
                
                Button("카메라") {
                    print("카메라 버튼 클릭")
                }

                Button("프로필 사진 삭제", role: .destructive) {
                    print("프로필 사진 삭제")
                }
                
                Button("취소", role: .cancel) { }
            }
        }
    }
    
    // MARK: 프로필 정보 수정 뷰
    private var profileInfoEditView: some View {
        VStack(spacing: 0) {
            
            Divider()
            
            // 닉네임
            HStack {
                Text("닉네임")
                    .foregroundStyle(Color.gray080)
                    .font(.dsHeadline)
                
                Spacer().frame(width: 54)
                
                TextField("", text: $nickname)
                
                Spacer()
            }
            .padding(.vertical, 14)
            
            Divider()
            
            // 아이디
            HStack {
                Text("아이디")
                    .foregroundStyle(Color.gray080)
                    .font(.dsHeadline)
                
                Spacer().frame(width: 54)
                
                TextField("", text: $id)
                
                Spacer()
            }
            .padding(.vertical, 14)
            
            Divider()
            
            // 소개
            HStack {
                Text("소개")
                    .foregroundStyle(Color.gray080)
                    .font(.dsHeadline)
                
                Spacer().frame(width: 68)
                
                TextField("", text: $introduction)
                
                Spacer()
            }
            .padding(.vertical, 14)
        }
    }
}

#Preview {
    ProfileEditView()
}
