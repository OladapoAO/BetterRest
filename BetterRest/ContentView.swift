
import CoreML
import SwiftUI

struct BetterRest: View {
    
    @State private var wakeUp = defaultWaketime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
   
    
    
    static var defaultWaketime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var sleepResults: String {
        
        do {
            
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour,.minute], from:wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            return  "Your ideal Bedtime is " + sleepTime.formatted(date:.omitted, time:.shortened)
            
        } catch {
            
            return "There was an Error"
        }
        
       
    }
    
    var body: some View {
    
        NavigationView{
            
            Form{
                
                Section("When do you want to wake up?"){
                    DatePicker("Please enter a time",selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                Section("Desired amount of sleep"){
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step:0.25)
                }
                 
                Section("Daily Cofee Intake"){
                    
                    Picker("Number of Cups" , selection: $coffeeAmount){
                       ForEach(0..<20){
                            Text(String($0))
                        }
                    }
                }
                
                Text(sleepResults)
                    .font(.title3)
                
            }.navigationBarTitle("Better Rest")
               
           
        }
    }
    
   
}







struct BetterRest_Previews: PreviewProvider {
    static var previews: some View {
        BetterRest()
    }
}
