import UserNotifications

func scheduleNotification(for goal: Goal) {
    let content = UNMutableNotificationContent()
    content.title = "Goal Reminder"
    content.body = "\(goal.name) is nearing its deadline!"
    content.sound = .default

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60 * 60 * 24, repeats: false)

    let request = UNNotificationRequest(identifier: goal.id.uuidString, content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Failed to add notification: \(error)")
        }
    }
}
