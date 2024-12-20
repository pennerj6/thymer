import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var activeMinutes: Int = 0
    @State private var activeSeconds: Int = 10
    @State private var cooldownMinutes: Int = 0
    @State private var cooldownSeconds: Int = 5
    @State private var timeRemaining: Int = 0
    @State private var isRunning = false
    @State private var currentCountdown = 1
    @State private var timer: Timer?

    var body: some View {
        ZStack {
            (currentCountdown == 1 ? Color.yellow : Color.mint)
                .edgesIgnoringSafeArea(.all)
                .animation(.easeInOut(duration: 0.5), value: currentCountdown)

            VStack {
                Text("Thymer")
                    .font(.largeTitle)
                    .padding()

                HStack {
                    Text("Active:")
                    VStack {
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 2)
                                Picker("Seconds", selection: $activeSeconds) {
                                    ForEach(0..<60) { second in
                                        Text("\(second)").tag(second)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .frame(width: 70, height: 40)
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                            }
                            .frame(width: 70, height: 40)
                            Text("Sec")
                                .frame(width: 30, alignment: .leading)
                        }
                    }
                }
                .padding()

                HStack {
                    Text("Cooldown:")
                    VStack {
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 2)
                                Picker("Seconds", selection: $cooldownSeconds) {
                                    ForEach(0..<60) { second in
                                        Text("\(second)").tag(second)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .frame(width: 70, height: 40)
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                            }
                            .frame(width: 70, height: 40)
                            Text("Sec")
                                .frame(width: 30, alignment: .leading)
                        }
                    }
                }
                .padding()

                Text(currentCountdown == 1 ? "Active: \(timeRemaining) sec" : "Cooldown: \(timeRemaining) sec")
                    .font(.title)
                    .padding()

                Button(action: {
                    if isRunning {
                        stopTimer()
                    } else {
                        startTimer()
                    }
                }) {
                    Text(isRunning ? "Stop" : "Start")
                        .font(.title)
                        .padding()
                        .background(isRunning ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .onAppear {
            setupAudioSession()
        }
    }
    
    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }

    func startTimer() {
        let activeTotalSeconds = activeMinutes * 60 + activeSeconds
        let cooldownTotalSeconds = cooldownMinutes * 60 + cooldownSeconds
        
        timeRemaining = currentCountdown == 1 ? activeTotalSeconds : cooldownTotalSeconds
        isRunning = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                AudioServicesPlaySystemSound(1111)
                currentCountdown = currentCountdown == 1 ? 2 : 1
                timeRemaining = currentCountdown == 1 ? activeTotalSeconds : cooldownTotalSeconds
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        timeRemaining = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
