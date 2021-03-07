//
//  LinearRegression.swift
//  MLbySascha
//
//  Created by Sascha Rexhäuser on 23.02.21.
//

import Foundation

class LinearRegression {
 
    let X:Matrix
    let y:Matrix
    var coefficients:[[Float64]]
    
    init(regressorMatrix: Matrix, targetVector :Matrix){
        self.X = regressorMatrix
        self.y = targetVector
        self.coefficients = []
    }
    
    func fit(){
        self.coefficients = self.X.transpose().multiply(with: self.X).inverse().multiply(with: self.X.transpose()).multiply(with: self.y).data
    }
    
}

//let X:Matrix = Matrix(data: [[1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7], [1, 8], [1, 9], [1, 10]])
//let y:Matrix = Matrix(data: [[1.6], [2.1], [2.4], [2.9], [2.9], [3.5], [4.1], [4.7], [4.8], [5.6]])

//let reg:LinearRegression = LinearRegression(regressorMatrix: X, targetVector: y)
//reg.fit()
//print(reg.coefficients)

// To-Do: 1) add a method for adding the constant vetcor
//        2) add colum names
//        3) method for R2
//        4) p-values for H0: betas == 0? (via bootstrap)
//        5) feature importance?
