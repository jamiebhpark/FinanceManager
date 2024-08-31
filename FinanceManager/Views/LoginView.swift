import SwiftUI
import KakaoSDKAuth
import KakaoSDKUser

struct LoginView: View {
    @StateObject private var authService = AuthService()

    var body: some View {
        VStack {
            Button(action: {
                authService.kakaoLogin()
            }) {
                Image("kakao_login_button")  // Assets에 추가한 이미지 이름
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 50)  // 버튼 크기 조정
            }
            .padding()
        }
        .alert(isPresented: .constant(authService.errorMessage != nil)) {
            Alert(
                title: Text("로그인 오류"),
                message: Text(authService.errorMessage ?? "알 수 없는 오류가 발생했습니다."),
                dismissButton: .default(Text("확인"))
            )
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
