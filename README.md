<head>
    <script type="text/javascript"
            src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
    </script>
</head>

# Geometry-calibration-for-tomographic-x-ray-imaging-systems
An Matlab implementation for geometry calibration of an x-ray imaging system. 

The methods and algorithm are inspired by Li, Xinhua, Da Zhang, and Bob Liu. ["A generic geometric calibration method for tomographic imaging systems with flat-panel detectors—A detailed implementation guide."](http://scitation.aip.org/content/aapm/journal/medphys/37/7/10.1118/1.3431996) Medical physics 37, 7 (2010): 3844-3854.

## How to install?
Drag the function file into your project and/or add it to your matlab function search path. 

## How to use?
### General usage
The function will output three values corresponding to the x-ray focal spot positions (in pixels) x, y, and z in the detector coordinate system. 

1. Load the 3D coordinates of the features of the calibration phantom in Matlab. 


If you want to 


