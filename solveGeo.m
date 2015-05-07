function [Xc,Yc,Zc] = solveGeo(feature3D,feature2D)
if size(feature3D) < 6
    display ('Not enough features for geometry calibration.');
    msgID = 'Not enough features';
    msg = 'Not enough features for the calibration. At least 6 features needed.';
    exception = MException(msgID,msg);
    throw(exception);
end

%% Nomalize 3D features
mean3D = mean(feature3D);
point = feature3D;
point(:,1) = point(:,1)-mean3D(1);
point(:,2) = point(:,2)-mean3D(2);
point(:,3) = point(:,3)-mean3D(3);
s = 0;
for i = 1:size(point,1)
    s = s + point(i,:)*point(i,:)';
end
s = sqrt(s/numel(point));
point = point./s;

%% Normalize 2D features
mean2D = mean(feature2D);
point2 = feature2D;
point2(:,1) = point2(:,1)-mean2D(1);
point2(:,2) = point2(:,2)-mean2D(2);
s2 = 0;
for j = 1:size(point2,1)
    s2 = s2 + point2(j,:)*point2(j,:)';
end
s2 = sqrt(s2/numel(point2));
point2 = point2./s2;

%% Compute array A for homogeneous equations A*x = 0
A = zeros(2*size(point,1),12);
for k = 1:size(point,1)
    A(2*k-1,1) = point(k,1);
    A(2*k-1,2) = point(k,2);
    A(2*k-1,3) = point(k,3);
    A(2*k-1,4) = 1;
    A(2*k-1,5:8) = 0;
    A(2*k-1,9) = -point2(k,1)*point(k,1);
    A(2*k-1,10) = -point2(k,1)*point(k,2);
    A(2*k-1,11) = -point2(k,1)*point(k,3);
    A(2*k-1,12) = -point2(k,1);
    A(2*k,1:4) = 0;
    A(2*k,5) = point(k,1);
    A(2*k,6) = point(k,2);
    A(2*k,7) = point(k,3);
    A(2*k,8) = 1;
    A(2*k,9) = -point2(k,2)*point(k,1);
    A(2*k,10) = -point2(k,2)*point(k,2);
    A(2*k,11) = -point2(k,2)*point(k,3);
    A(2*k,12) = -point2(k,2);
end

%% Use sigular value decomposition to solve A*x=0. The solution vector x is the column vector corresponding to the minimum sigular value.
[U,Sin,V]=svd(A,0);

%% Compute projection matrix
P = zeros(3,4);
P(1,1) = V(1,12);
P(1,2) = V(2,12);
P(1,3) = V(3,12);
P(1,4) = V(4,12);
P(2,1) = V(5,12);
P(2,2) = V(6,12);
P(2,3) = V(7,12);
P(2,4) = V(8,12);
P(3,1) = V(9,12);
P(3,2) = V(10,12);
P(3,3) = V(11,12);
P(3,4) = V(12,12);

%% data denomalization
T4 = [1/s, 0, 0, -mean3D(1)/s;0,1/s,0,-mean3D(2)/s;0, 0, 1/s,-mean3D(3)/s;0,0,0,1];
T3 = [s2,0,mean2D(1);0,s2,mean2D(2);0,0,1];

P = T3*P*T4;

%% projection matrix normalization
scale = sqrt(P(3,1:3)*P(3,1:3)');
if P(3,4) < 0
    scale = -scale;
end
P = P./scale;

%% Calculate parameters
Pleft = P(:,1:3);
S = [0,0,1;0,1,0;1,0,0];
PL = Pleft'*S;
[Q,R] = qr(PL,0);
Rot = zeros(3,3);
Rot(1,:) = Q(:,3)';
Rot(2,:) = Q(:,2)';
Rot(3,:) = Q(:,1)';

K = S*R'*S;

for m = 1:3
    if K(m,m)<0
        K(:,m)=-K(:,m);
        Rot(m,:) = -Rot(m,:);
    end
end

%% Translation vector
Tr = zeros(3,1);
Tr(3) = P(3,4);
Tr(2) = (P(2,4)-K(2,3)*P(3,4))/K(2,2);
Tr(1) = (P(1,4)-K(1,2)*Tr(2)-K(1,3)*P(3,4))/K(1,1);

Cr = - Rot'*Tr;

%% Rotation angle
aY = asin(-Rot(3,1));
if cos(aY) > 0
    aX = atan2(Rot(3,3),Rot(3,2));
    aZ = atan2(Rot(1,1),Rot(2,1));
else
    aX = atan2(-Rot(3,3),-Rot(3,2));
    aZ = atan2(-Rot(1,1),-Rot(2,1));
end
angle = [aX, aY, aZ]' .* 180/pi;

%% Finalize calculation.
Xc = K(1,3);
Yc = K(2,3);
Zc = K(1,1);
end
