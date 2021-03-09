//
//  LinearRegression.swift
//  MLbySascha
//
//  Created by Sascha Rexhäuser on 23.02.21.
//

import Foundation

class Regression {
 
    let X:Matrix
    let y:Matrix
    var coefficients:[String:Float64] = [:]
    let variablesNames:[String]
    
    init(regressorMatrix:Matrix, targetVector:Matrix, variablesNames:[String]){
        self.X = regressorMatrix
        self.y = targetVector
        self.variablesNames = variablesNames
        for v in self.variablesNames {
            self.coefficients[v] = nil
        }
    }
    
    func fit(){
        
        let temp_coefficients:[[Float64]] = self.X.transpose().multiply(with: self.X).inverse().multiply(with: self.X.transpose()).multiply(with: self.y).data
        
        for c in 0...(self.variablesNames.count - 1) {
            self.coefficients[self.variablesNames[c]] = temp_coefficients[c][0]
        }
        
    }
    
}


//let X:Matrix = Matrix(data: [[1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7], [1, 8], [1, 9], [1, 10]])
//let y:Matrix = Matrix(data: [[1.6], [2.1], [2.4], [2.9], [2.9], [3.5], [4.1], [4.7], [4.8], [5.6]])
//let reg:Regression = Regression(regressorMatrix: X, targetVector: y, variablesNames: ["const", "x"])
//reg.fit()
//print(reg.coefficients)

// To-Do: 1) add a method for adding the constant vetcor
//        2) method for R2
//        3) p-values for H0: betas == 0? (via bootstrap)
//        4) feature importance?
