-- this file is separate to script.hs and is not needed for normal operation 

e :: Int -> [[Double]] -> [[Double]]
e c xss = head xss : take c (tail xss) ++ map (\xs ->
  take c xs ++ zipWith (\x y -> x - (y * (xs !! c) / (xss !! c !! c))) (drop c xs) (drop c (xss !! c))) (drop c (tail xss))
elim :: Int -> [[Double]] -> [[Double]]
elim 0 xss = e 0 xss
elim i xss = e i (elim (i - 1) xss)
knowns :: Int -> [Double] -> [Double]
knowns 0 row = []
knowns i row = take i (drop (length row - 1 - i) row)
coeffs :: Int -> [[Double]] -> [Double]
coeffs 0 xss = []
coeffs i xss = drop (length xss - i) (map last xss)
xn :: Int -> [[Double]] -> [Double] -> Double
xn i xss row = (last row - sum (zipWith (*) (coeffs i xss) (knowns i row))) / (row !! (length row - 2 - i))
b :: Int -> [[Double]] -> [[Double]]
b i xss = take (length xss - 1 - i) xss ++ [init (xss !! (length xss - 1 - i)) ++ [xn i xss (xss !! (length xss - 1 - i))]] ++ drop (length xss - i) xss
back :: Int -> [[Double]] -> [[Double]]
back 0 xss = b 0 xss
back i xss = b i (back (i - 1) xss)
solve :: [[Double]] -> [Double]
solve xss = (coeffs (length xss) . back (length xss - 1) . elim (length xss - 2)) xss