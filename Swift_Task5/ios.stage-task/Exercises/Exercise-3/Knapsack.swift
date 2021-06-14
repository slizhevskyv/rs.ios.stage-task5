import Foundation

public typealias Supply = (weight: Int, value: Int)

fileprivate typealias TypedSupplyWithCoeff = (weight: Int, value: Int, coeff: Float, type: SupplyType)

enum SupplyType {
    case food
    case drink
}

public final class Knapsack {
    let maxWeight: Int
    let drinks: [Supply]
    let foods: [Supply]
    var maxKilometers: Int {
        findMaxKilometres()
    }
    
    init(_ maxWeight: Int, _ foods: [Supply], _ drinks: [Supply]) {
        self.maxWeight = maxWeight
        self.drinks = drinks
        self.foods = foods
    }
    
    func findMaxKilometres() -> Int {
        var foodKnapsack: [TypedSupplyWithCoeff] = knapsack(weight: maxWeight, items: foods).map{ ($0.weight, $0.value, Float($0.value)/Float($0.weight), .food) }.sorted{ $0.coeff > $1.coeff };
        var drinkKnapsack: [TypedSupplyWithCoeff] = knapsack(weight: maxWeight, items: drinks).map{ ($0.weight, $0.value, Float($0.value)/Float($0.weight), .drink) }.sorted{ $0.coeff > $1.coeff };
        
        var items: [TypedSupplyWithCoeff] = [];
        
        var capacity = maxWeight;
        var shouldProceed = true;
        
        while(shouldProceed) {
            let food = foodKnapsack.isEmpty ? nil : foodKnapsack.remove(at: 0);
            let drink = drinkKnapsack.isEmpty ? nil : drinkKnapsack.remove(at: 0);
            
            if let f = food, f.weight <= capacity {
                items.append(f);
                capacity -= f.weight;
            }
            
            if let d = drink, d.weight <= capacity {
                items.append(d);
                capacity -= d.weight
            }
            
            if food == nil && drink == nil {
                shouldProceed = false;
            }
        }
        
        let foodValue = items.filter { $0.type == .food }.reduce(0) { acc, item in
            return acc + item.value;
        }
        
        let drinkValue = items.filter { $0.type == .drink }.reduce(0) { acc, item in
            return acc + item.value;
        }
        
        return min(foodValue, drinkValue)
    }
    
    fileprivate func knapsack(weight: Int, items: [Supply]) -> [Supply] {
        var DP: [[Int]] = Array.init(repeating: Array.init(repeating: 0, count: weight + 1), count: items.count + 1);
        
        for i in 1...items.count {
            let w = items[i-1].weight
            let v = items[i-1].value
            
            for sz in 1...weight {
                DP[i][sz] = DP[i-1][sz];
                if (sz >= w && DP[i-1][sz-w] + v > DP[i][sz]) {
                    DP[i][sz] = DP[i-1][sz-w] + v;
                }
            }
        }
        
        var selectedItems: [Supply] = [];
        
        var sz = weight;
        
        var i = items.count;
        while(i > 0) {
            if (DP[i][sz] != DP[i-1][sz]) {
                let itemIndex = i - 1;
                selectedItems.append(items[itemIndex]);
                sz -= items[itemIndex].weight;
            }
            i -= 1;
        }
        
        return selectedItems;
    }
}
