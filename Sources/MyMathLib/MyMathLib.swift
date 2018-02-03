


let epsilonCar = "\u{03B5}"


postfix operator °

 

public class Vecteur: CustomStringConvertible, Equatable
{
   
   // Tableau qui contient les composantes du vecteur
   var data: [Double] = []
   // Dimension du vecteur. Par défaut vecteur colonne, nbc=1
   var (nbl, nbc) = (0,1)
   
   
   public init(_ datas: [Double])
   {
      for element in datas
      {
         self.data.append(element)
      }
      self.nbc = 1
      self.nbl = data.count
   }
   
   public init(_ datas: [Int])
   {
      for element in datas
      {
         self.data.append(Double(element))
      }
      self.nbc = 1
      self.nbl = data.count
   }
   
   public init(_ vec: Vecteur)
   {
      self.data = vec.data
      self.nbc = vec.nbc
      self.nbl = vec.nbl
   }
   
   /*********************************************************
    Implémente la notion d'indice (subscript) pour "\(Vecteur)"
    *********************************************************/
   public subscript(x: Int) -> Double
   {
      get {
         return self.data[x]
      }
      set {
         self.data[x] = newValue
      }
   }
   
   /*********************************************************
    Implémente la conversion en String pour "\(Vecteur)"
    *********************************************************/
   public var description: String
   {
      var result = ""
      if nbc == 1
      {
         for element in self.data
         {
            result += "|\(element)|\n"
         }
      } else
      {
         result = "["
         for element in self.data
         {
            result += "\(element),"
         }
         result.removeLast()
         result += "]"
      }
      return result
   }
   
   /*********************************************************
    Implémente le "==" de 2 vecteurs
    (pour se conformer au protocole Equatable)
    TODO : Traiter cas de vecteurs "vides"
    *********************************************************/
   public static func ==(lhs: Vecteur, rhs: Vecteur) -> Bool
   {
      var result = (lhs.nbl == rhs.nbl) && (lhs.nbc == rhs.nbc)
      
      for i in 0..<lhs.data.count
      {
         result = result && (lhs.data[i] == rhs.data[i])
      }
      return result
   }
   
   /*********************************************************
    Implémente le "+" de 2 vecteurs
    *********************************************************/
   public static func +(lhs: Vecteur, rhs: Vecteur) -> Vecteur?
   {
      if (lhs.nbc == rhs.nbc && lhs.nbl == rhs.nbl)
      {
         var result = Vecteur(lhs)
         
         for ind in 0...max(lhs.nbc,lhs.nbl)-1
         {
            result[ind] = result[ind] + rhs[ind]
         }
         return result
      } else
      {
         print("Dimensions incompatibes pour l'addition de 2 Vecteurs!")
         return nil
      }
   }
   
   /*********************************************************
    Implémente le "-" de 2 vecteurs
    *********************************************************/
   public static func -(lhs: Vecteur, rhs: Vecteur) -> Vecteur?
   {
      if (lhs.nbc == rhs.nbc && lhs.nbl == rhs.nbl)
      {
         var result = Vecteur(lhs)
         
         for ind in 0...max(lhs.nbc,lhs.nbl)-1
         {
            result[ind] = result[ind] - rhs[ind]
         }
         return result
      } else
      {
         print("Dimensions incompatibes pour l'addition de 2 Vecteurs!")
         return nil
      }
   }
   
   /*********************************************************
    Implémente le "*" de 2 vecteurs
    TODO : vérifier compatibilité des dimensions
    *********************************************************/
   public static func *(lhs: Vecteur, rhs: Vecteur) -> Double?
   {
      
      if (lhs.nbl == 1 && lhs.nbc == rhs.nbl && rhs.nbc == 1)
      {
         if lhs.nbc > 0
         {
            var result = lhs[0] * rhs[0]
            for ind in 1...lhs.nbc-1
            {
               result = result + lhs[ind] * rhs[ind]
               //ind += 1
            }
            return result
         } else
         {
            print("Vecteurs vides !")
            return nil
         }
      } else
      {
         print("Dimensions incompatibes pour * de 2 Vecteurs!")
         return nil
      }
   }
   
   /*********************************************************
    Implémente le "*" d'1 Double et d'1 Vecteur
    TODO : vérifier compatibilité des dimensions
    *********************************************************/
   public static func *(lhs: Double, rhs: Vecteur) -> Vecteur
   {
      var result = rhs
      var ind = 0
      for elem in rhs.data
      {
         result[ind] = result[ind] * lhs
         ind += 1
      }
      return result
   }
   
   /*********************************************************
    Implémente la transposition d'un vecteur
    Retourne le transposé du Vecteur
    *********************************************************/
   public func transpose() -> Vecteur
   {
      var result = Vecteur(self)
      
      result.nbl = self.nbc
      result.nbc = self.nbl
      return result
   }
   /*********************************************************
    Implémente la transposition d'un vecteur à l'aide d'un
    opérateur postfixé "°"
    Retourne le transposé du Vecteur
    *********************************************************/
   public static postfix func °(v: Vecteur) -> Vecteur
   {
      var result = Vecteur(v)
      
      result.nbl = v.nbc
      result.nbc = v.nbl
      return result
   }
   
   
}

