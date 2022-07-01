# Polynomial from points
Haskell script that turns an array of points into the coefficients for the simplest polynomial which crosses those points.\ 
When I first discovered this process I couldn't believe how elegant it was, which motivated me to implement it.\
This is accomplished by entering the points into a Gaussian Elimination matrix that looks like this:
```
For any array of m + 1 distinct points with no common x coordinates
[ 1    x0   x0^2 x0^3 ...  x0^m  y0  ]
[ 1    x1   x1^2 x1^3 ...  x1^m  y1  ]
[ ...  ...  ...  ...  ...  ...   ... ]
[ 1    xm   xm^2 xm^3 ...  xm^m  ym  ]
```
...which is then solved for the coefficients of x^0 (1), x^1, x^2, x^3 etc.\
This algorithm contains my Haskell implementation of generic Gaussian Elimination, which is used to solve for the aforementioned coefficients.
## Example
### Script
<img src="https://user-images.githubusercontent.com/45922387/176879740-e252743e-57af-47a5-b784-0aa186bce3ff.png" alt="picture" width=900 />

### Shown in Desmos
<img src="https://user-images.githubusercontent.com/45922387/176879734-7c180fd0-20c9-4f88-962a-5fbae5059eba.png" alt="picture" width=900 />

