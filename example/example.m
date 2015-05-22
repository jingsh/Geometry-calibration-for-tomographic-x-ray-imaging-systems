%% Example
%%% This script provide an example how to use the geometry calibration.
%%% A 3D digital phantom (with ideal beads features) is provided. 
%%% User can set a focal spot location (reference to detector plane)
%%% The script will simulate the projection image of the digital phantom by
%%% the set focal spot. Then the focal spot will be solved using the 3D
%%% feature and simulated 2D feature in the projection image. The results
%%% will be print out for comparison.

%% Load the coordinates of features in the digital phantom
load('feature3D.mat');

%% Set the focal spot location, in the detector coordinate system. 
%%%In this example, we randomly generate the location.
F = (rand(1,3)+2)*300;

%% Simulate the projection image of the digital phantom.
%%% (1) randomly place the phantom in the space, but above the detector.
%%%     - produce a random 3D tranlation vector tr.
%%%     - produce a random 3D rotation matrix Rot
tr = rand(1,3)*50;
[Rot,~] = qr(rand(3));

%%% (2) generate the 2D coordinates of the feature in the projection image.
feature2D = zeros(size(feature3D,1),2);
for i = 1:size(feature3D,1)
    feature3D(i,:) = (tr'+ Rot*feature3D(i,:)')';
    feature2D(i,1) = (F(3)*feature3D(i,1)-F(1)*feature3D(i,3))/(F(3)-feature3D(i,3));
    feature2D(i,2) = (F(3)*feature3D(i,2)-F(2)*feature3D(i,3))/(F(3)-feature3D(i,3));
end

%% Solve the focal spot location, using the coordinates of 3D phantom and the projection image.
[solF(1),solF(2),solF(3)] = solveGeo(feature3D,feature2D);

%% Print out the results for comparison.
display('User set focal spot:');
F
display('Solved focal spot location:')
solF