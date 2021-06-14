import Foundation

class StockMaximize {

    func countProfit(prices: [Int]) -> Int {
        var profit = 0;
        
        if (prices.isEmpty) {
            return profit;
        }
        
        let pricesCount = prices.count;
        var boughtPrices: [Int] = [];
        var maxPrice = 0;
        
        for pi in 0..<pricesCount {
            
            let npi = pi + 1 < pricesCount ? pi + 1 : nil;
            var tempNpi = npi;
            
            while(
                tempNpi != nil &&
                tempNpi! < pricesCount &&
                prices[tempNpi!] >= prices[tempNpi! - 1]
            ) {
                maxPrice = prices[tempNpi!];
                tempNpi! += 1;
            }
            
            if (prices[pi] == maxPrice) {
                profit = boughtPrices.reduce(profit, { profitAcc, price in
                    return profitAcc + (maxPrice - price);
                })
                maxPrice = 0
                boughtPrices = [];
            } else if let _npi = npi, prices[_npi] >= prices[pi] {
                boughtPrices.append(prices[pi]);
            }
            
        }
        
        return profit;
    }
}
