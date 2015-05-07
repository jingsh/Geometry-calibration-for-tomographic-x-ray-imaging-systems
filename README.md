<head>
    <script type="text/javascript"
            src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
    </script>
</head>

# Geometry-calibration-for-tomographic-x-ray-imaging-systems
An Matlab implementation for geometry calibration of an x-ray imaging system. 

The methods and algorithm are inspired by Li, Xinhua, Da Zhang, and Bob Liu. ["A generic geometric calibration method for tomographic imaging systems with flat-panel detectors—A detailed implementation guide."](http://scitation.aip.org/content/aapm/journal/medphys/37/7/10.1118/1.3431996) Medical physics 37, 7 (2010): 3844-3854.

## How to install?
Drag the function file (`solveGeo.m`) into your project and/or add it to your matlab function search path. 

## How to use?
### General usage
The function will output three values corresponding to the x-ray focal spot positions (in pixels) x, y, and z in the detector coordinate system. 

1. Load the 3D coordinates of the features of the calibration phantom in Matlab. We recommend format this file into a `m-by-3` matrix, where `m` is the total number of features in the phantom. The first column is the `x` coordinates of the features in the **phantom coordination system**. The second and third column corresponds the `y` and `z` coordinates. 

    **IMPORTANT: your phantom MUST have at least 6 features.**

2. In the x-ray projection image of the phantom, use your own method to identify `m` features in the image. Find the coordinates of each feaute in the **projection image coordinate system**. And make a `m-by-2` matrix `2D`, where the first column is the `x` coordinate of the feature in the image plane (`u`), and the second column is the `y` coordinates of the features in the image plane (`v`).

    **IMPORTANT: the 2D feaure matrix MUST correspond to the 3D feature matrix.**

3. Calculate the focal spot location using the provided function `solveGeo.m`. 

    `[x,y,z] = solveGeo(feature3D, feature2D)`

4. The result from step 3 is in the units of `pixels` in the **detector coordinate system**. To convert the number into real dimensions, multiply each value by the ***pixel size of the detector***.

### Batch process a sequence of tomographic projection images
If you want to batch process the whole sequence, you can loop through the projection images, apply the function on each image to calculate the focal spot location for the image, and summarize the results in an array. A pseudocode snippets is provided as example.

```matlab
load('feature3D.mat');
N = numel(imageSequence);
Location = zeros(N,3);
for i = 1:N
    image = loadYourIthImage(imageSequence,i);
    feature2D = yourAlgorithmToFind2DFeatures(image); %% Implement your own methods to locate the features here.
    Location(i,:) = solveGeo(feature3D,feature2D);
end
```

##Reference
Li, Xinhua, Da Zhang, and Bob Liu. ["A generic geometric calibration method for tomographic imaging systems with flat-panel detectors—A detailed implementation guide."](http://scitation.aip.org/content/aapm/journal/medphys/37/7/10.1118/1.3431996) Medical physics 37, 7 (2010): 3844-3854.

##License

