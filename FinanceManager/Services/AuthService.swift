import Foundation
import KakaoSDKAuth
import KakaoSDKUser

class AuthService: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String?

    func kakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                self?.handleLoginResult(oauthToken: oauthToken, error: error)
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
                self?.handleLoginResult(oauthToken: oauthToken, error: error)
            }
        }
    }

    private func handleLoginResult(oauthToken: OAuthToken?, error: Error?) {
        if let error = error {
            self.errorMessage = "Login failed: \(error.localizedDescription)"
            print(self.errorMessage ?? "Error during login.")
            return
        }
        
        self.isLoggedIn = true
        if let authorizationCode = oauthToken?.accessToken {
            // Access Token을 Authorization Code로 사용
            self.sendAuthorizationCodeToServer(authorizationCode: authorizationCode)
        }
    }

    private func sendAuthorizationCodeToServer(authorizationCode: String) {
        guard let url = URL(string: "http://localhost:8080/auth/kakao/callback") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        // 서버로 보낼 데이터 준비
        let bodyString = "code=\(authorizationCode)"
        request.httpBody = bodyString.data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending authorization code to backend: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("Successfully sent authorization code to backend.")
            } else {
                print("Failed to send authorization code to backend.")
            }
        }
        task.resume()
    }
}
