import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct FinanceManagerApp: App {

    init() {
        KakaoSDK.initSDK(appKey: "3fb311ae4ad9cc1115ad22ec12f09d18")
    }

    var body: some Scene {
        WindowGroup {
            LoginView()
                .onOpenURL { url in
                    // Kakao login URL handling
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        // handleOpenUrl의 결과를 사용하여 경고를 제거합니다.
                        if AuthController.handleOpenUrl(url: url) {
                            print("Kakao login URL handled successfully.")
                        } else {
                            print("Failed to handle Kakao login URL.")
                        }
                    }
                }
        }
    }
}
