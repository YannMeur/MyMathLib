//
//  Matrice.swift
//  MyMathLibPackageDescription
//
//  Created by Yann Meurisse on 29/01/2018.
// 
import Foundation

postfix operator °

public class Matrice: CustomStringConvertible
{
   // Tableau qui contient les composantes du vecteur
   var data: [Double] = []
   // Dimension du vecteur.
   var (nbl, nbc) = (0,0)
   
   /********************************************************
    Initialiseurs
    *********************************************************/
   public init(_ datas: [Double], nbl: Int, nbc: Int)
   {
      if datas.count == nbl*nbc
      {
         for element in datas
         {
            self.data.append(element)
         }
         self.nbc = nbc
         self.nbl = nbl
      } else
      {
         print("Erreur : Nb d'éléments du tableau != nbl*nbc !!")
      }
   }
   
   public init(_ M: Matrice)
   {
      self.data = M.data
      self.nbc = M.nbc
      self.nbl = M.nbl
   }
 
   public init(nbl: Int, nbc: Int)
   {
      self.data = Array(repeating: 0.0, count: nbl*nbc)
      self.nbc = nbc
      self.nbl = nbl
   }

   public init(nbl: Int)
   {
      self.data = Array(repeating: 0.0, count: nbl*nbl)
      self.nbl = nbl
      self.nbl = nbl
   }

   
   
   /*********************************************************
    Implémente la conversion en String pour "\(Matrice)"
    *********************************************************/
   public var description: String
   {
      var result = ""
      
      for l in 0...nbl-1
      {
         for c in 0...nbc-1
         {
            let element = data[l*nbc + c]
            if element < 1.0e-10
            {
               result += " "+epsilonCar+" \t\t"
            } else
            {
               result += "\(round(element*10)/10)\t\t"
            }
         }
         result.removeLast()
         result += "\n"
      }
      return result
   }
   
   /*********************************************************
    Implémente la notion d'indice (subscript) pour "\(Matrice)"
    *********************************************************/
   public subscript(_ x: Int,_ y: Int) -> Double
   {
      get {
         return self.data[x*self.nbc + y]
      }
      set {
         self.data[x*self.nbc + y] = newValue
      }
   }
   
   /*********************************************************
    Implémente la transposition d'une Matrice à l'aide d'un
    opérateur postfixé "°"
    Retourne la transposée de la Matrice
    *********************************************************/
   public static postfix func °(m: Matrice) -> Matrice
   {
      var data: [Double] = []
      
      for i in 0...m.nbc-1
      {
         for j in 0...m.nbl-1
         {
            data.append(m[j,i])
         }
      }
      
      return Matrice(data,nbl: m.nbc,nbc: m.nbl)
   }
   
   /*********************************************************
    Implémente le "*" de 2 Matrices
    TODO : vérifier compatibilité des dimensions
    *********************************************************/
   public static func *(lhs: Matrice, rhs: Matrice) -> Matrice?
   {
      if (lhs.nbc != rhs.nbl)
      {
         print("Dimensions incompatibles !")
         return nil
      } else
      {
         var data: [Double] = []
         for i in 0...lhs.nbl-1
         {
            for j in 0...rhs.nbc-1
            {
               data.append((lhs.ligne(i)*rhs.colonne(j))!)
            }
         }
         return Matrice(data,nbl: lhs.nbl,nbc: rhs.nbc)
      }
   }
   
   
   /*********************************************************
    Fonction qui retourne une ligne, sous forme d'un Vecteur,
    de la matrice
    TODO: Gérer les erreurs d'indice
    *********************************************************/
   public func ligne(_ ind: Int) -> Vecteur
   {
      return (Vecteur(Array(self.data[ind*self.nbc...(ind+1)*self.nbc - 1]))).transpose()
   }
   /*********************************************************
    Fonction qui retourne une colonne, sous forme d'un Vecteur,
    de la matrice
    TODO: Gérer les erreurs d'indice
    *********************************************************/
   public func colonne(_ ind: Int) -> Vecteur
   {
      var tempArray: [Double] = []
      
      for i in stride(from: ind, to: ind+(self.nbl)*self.nbc, by: self.nbc)
      {
         tempArray.append(self.data[i])
      }
      return Vecteur(tempArray)
   }
   
   /*******************************************************************
    Retourne une matrice identique mais dont les éléments ont été
    convertis en Double
    ********************************************************************/
   public func eye() -> Matrice
   {
      var zeros = Array(repeating: 0.0, count: self.nbl*self.nbc)
      var I = Matrice(zeros,nbl: self.nbl, nbc: self.nbc)
      for i in 0...self.nbc-1
      {
         I[i,i] = 1.0
      }
      return I
   }
   
   
   /*******************************************************************
    Fonction qui retourne une Matrice trangulaire sup. "équivalente"
    à la Matrice (carrée) fournie.
    Fonction utilisée pour l'inversion par pivot de Gauss
    TODO: Gérer les erreurs d'indice
    *******************************************************************/
   public func triangSup(_ A: Matrice) -> Matrice
   {
      var B: Matrice = Matrice(A)
      let n = A.nbc
      
      for j in 0...n-2
      {
         // On trouve i entre j et n-1 tel que |A(i,j)| soit maximal
         var indTrouve = j
         var absAijCourant: Double = abs(A[indTrouve,j] )
         
         for i in j+1...n-1
         {
            if abs(A[i,j]) > absAijCourant
            {
               indTrouve = i
               absAijCourant = abs(A[i,j])
            }
         }
         // On échange Ligne(indTrouve) et Ligne(j)
         let tempo = B.data[indTrouve*n...(indTrouve+1)*n-1]
         B.data[indTrouve*n...(indTrouve+1)*n-1] = B.data[j*n...(j+1)*n-1]
         B.data[j*n...(j+1)*n-1] = tempo
         
         // on fait apparaitre les "0" sous la diagonale
         for i in j+1...n-1
         {
            let ligneTempo = B.ligne(i) - (B[i,j]/B[j,j]) * B.ligne(j)
            B.data[i*n...(i+1)*n-1] = (ligneTempo?.data[0...n-1])!
         }
      }
      return B
   }
   
   /*******************************************************************
    Fonction qui retourne l'inverse d'une Matrice carrée
    TODO: Gérer les erreurs d'indice 
    *******************************************************************/
   public func inv(_ A: Matrice) -> Matrice
   {
      var B: Matrice = Matrice(A)
      var I:Matrice = A.eye()
      let n = A.nbc
      
      print("I=\n\(I)")
      
      // On triangularise la matrice
      for j in 0...n-2
      {
         // On trouve i entre j et n-1 tel que |A(i,j)| soit maximal
         var indTrouve = j
         var absAijCourant: Double = abs(A[indTrouve,j] )
         
         for i in j+1...n-1
         {
            if abs(A[i,j]) > absAijCourant
            {
               indTrouve = i
               absAijCourant = abs(A[i,j])
            }
         }
         // On échange Ligne(indTrouve) et Ligne(j)
         let tempoB = B.data[indTrouve*n...(indTrouve+1)*n-1]
         B.data[indTrouve*n...(indTrouve+1)*n-1] = B.data[j*n...(j+1)*n-1]
         B.data[j*n...(j+1)*n-1] = tempoB
         let tempoI = I.data[indTrouve*n...(indTrouve+1)*n-1]
         I.data[indTrouve*n...(indTrouve+1)*n-1] = I.data[j*n...(j+1)*n-1]
         I.data[j*n...(j+1)*n-1] = tempoI
         
         // on fait apparaitre les "0" sous la diagonale
         for i in j+1...n-1
         {
            let coef = B[i,j]/B[j,j]
            var ligneTempo = B.ligne(i) - coef * B.ligne(j)
            B.data[i*n...(i+1)*n-1] = (ligneTempo?.data[0...n-1])!
            ligneTempo = I.ligne(i) - coef * I.ligne(j)
            I.data[i*n...(i+1)*n-1] = (ligneTempo?.data[0...n-1])!
         }
      }
      
      print("I=\n\(I)")
      
      // On diagonalise la matrice
      for jj in 0...n-2
      {
         let j = -jj+n-1
         for ii in 0...j-1
         {
            let i = -ii+j-1
            let coef = B[i,j]/B[j,j]
            var ligneTempo = B.ligne(i) - coef * B.ligne(j)
            B.data[i*n...(i+1)*n-1] = (ligneTempo?.data[0...n-1])!
            ligneTempo = I.ligne(i) - coef * I.ligne(j)
            I.data[i*n...(i+1)*n-1] = (ligneTempo?.data[0...n-1])!
         }
      }
      
      print("B=\n\(B)")
      print("I=\n\(I)")
      
      // On fait apparaitre des "1" sur la diagonale de B
      for i in 0...n-1
      {
         let coef = 1/B[i,i]
         var ligneTempo = coef*B.ligne(i)
         B.data[i*n...(i+1)*n-1] = (ligneTempo.data[0...n-1])
         ligneTempo = coef*I.ligne(i)
         I.data[i*n...(i+1)*n-1] = (ligneTempo.data[0...n-1])
      }
      return I
   }
}

