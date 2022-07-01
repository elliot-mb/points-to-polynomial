import System.Directory.Internal.Prelude (getArgs)
import Data.List

row :: Double -> Int -> [Double]
row x n = [x ^ m | m <- [0..n]]

matrixGE :: [(Double, Double)] -> [[Double]]
matrixGE xs = map (\(x, y) -> row x (length xs - 1) ++ [y]) xs

-- c is the distance from the left hand side of the matrix 
e :: Int -> [[Double]] -> [[Double]]
e c xss = head xss : take c (tail xss) ++ map (\xs ->
  take c xs ++ zipWith (\x y -> x - (y * (xs !! c) / (xss !! c !! c))) (drop c xs) (drop c (xss !! c))) (drop c (tail xss))

-- xss is our matrix
elim :: Int -> [[Double]] -> [[Double]]
elim 0 xss = e 0 xss
elim i xss = e i (elim (i - 1) xss)

-- which values do we know in back substitution 
knowns :: Int -> [Double] -> [Double]
knowns 0 row = []
knowns i row = take i (drop (length row - 1 - i) row)

-- gets known coefficients (last element of each row) from the bottom up
coeffs :: Int -> [[Double]] -> [Double]
coeffs 0 xss = []
coeffs i xss = drop (length xss - i) (map last xss)
-- [1 ][x1][c1] (c1 = value of coefficient corresponding to x1) ^ 
-- [1 ][x2][c2] (c2 = value of coefficient corresponding to x2) ^

-- Int (how far from the bottom), [Double] our known xs, [Double] this row -> produces next known
xn :: Int -> [[Double]] -> [Double] -> Double
xn i xss row = (last row - sum (zipWith (*) (coeffs i xss) (knowns i row))) / (row !! (length row - 2 - i))

-- handles one row of back substitution, building a new row with the corresponding coefficient of x(order - i) at the end 
b :: Int -> [[Double]] -> [[Double]]
b i xss = take (length xss - 1 - i) xss ++ [init (xss !! (length xss - 1 - i)) ++ [xn i xss (xss !! (length xss - 1 - i))]] ++ drop (length xss - i) xss

back :: Int -> [[Double]] -> [[Double]]
back 0 xss = b 0 xss
back i xss = b i (back (i - 1) xss)

check :: [(Double, Double)] -> String
check xss
  -- if there are >= distinct x coords than y coords, we're good. else the poly is impossible  
  | length (nub (map fst xss)) == length xss = (pretty 0 . coeffs (length xss) . back (length xss - 1) . elim (length xss - 2) . matrixGE) xss
  | otherwise                                = "Impossible polynomial."

pretty :: Int -> [Double] -> String
pretty i (x:[]) = "c" ++ show i ++ ": " ++ show x
pretty i (x:xs) = "c" ++ show i ++ ": " ++ show x ++ "\r\n" ++ pretty (i + 1) xs
pretty i [] = ""

main :: IO ()
main =
  getArgs >>= (\(arg:args) ->
  pure (read arg :: [(Double, Double)]) >>= (putStr . check . nub))