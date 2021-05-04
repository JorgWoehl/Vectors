function hGroup = vector(O, P, style, vect)
%VECTOR Draw 3D vector.
%   VECTOR(O,P) draws a three-dimensional vector from origin O to point P
%   in the current axes if both points are specified as row vectors
%   containing the respective Cartesian coordinates, [x,y,z]. If O and/or P
%   are specified as matrices, [x1,y1,z1; x2,y2,z2; ...], then multiple
%   vectors are drawn. If O is a row vector and P is an N-by-3 matrix, then
%   N vectors are drawn from point O to the points given by the rows of P
%   (and vice-versa). If both O and P are N-by-3 matrices, then N vectors
%   are drawn from the points given by the rows of O to the points given by
%   the corresponding rows of P.
%
%   H = VECTOR(O,P,...) returns the handle H of a Group object containing
%   the vector(s) from O to P.
%
%   Vector properties are based on the following vector components: the
%   cone (arrowhead), the shaft, and an optional sphere marking the origin.
%   The cone itself consists of the base, the rim, the outer cone surface,
%   and the tip.
%
%          |<------------ Shaft ------------>|<---- Cone ---->|
%
%                                           RRR*
%                                          R   R*****
%         OOO                             R     R********i
%        OOOOO))))))))))))))))))))))))))))))))  R********iiiiii
%         OOO                             R     R********i  |
%          |                               R   R*****       |
%          |                              / RRR*           Tip
%       Sphere                           /
%                               Base with rim (R)
%
%   VECTOR(O,P,STYLE) draws a vector or group of vectors with properties
%   specified in short form by the character vector STYLE. STYLE can
%   contain any or all of the following properties in any order: the main
%   color, the width (diameter) of the shaft in points, where 1 point =
%   1/72 of an inch, and the tip highlight mode (see below for more
%   details).
%
%   Main color:   'r'  red      'c'  cyan       'k'  black (default)
%                 'g'  green    'm'  magenta    'w'  white
%                 'b'  blue     'y'  yellow
%
%   Shaft width in points: simple decimal notation (default: 1 point)
%
%   Tip highlight mode:         ''   never (default)
%                               'o'  when facing camera
%                               '*'  always
%
%   If a property is specified more than once (as in STYLE = 'rg'), then
%   only the first occurrence ('r') is taken into account. Invalid
%   characters in STYLE will be ignored.
%
%   VECTOR(..., Name-Value-Pairs) specifies vector properties using
%   comma-separated 'NAME',VALUE syntax or the the equal-sign syntax
%   NAME=VALUE introduced in R2021a. The following properties can be
%   assigned:
%
%   'Color'
%      Main color of the vector(s), specified as an RGB triplet; this
%      overrides any color specified in STYLE. The default is black. The
%      main color is the default color for all vector parts except for the
%      base and the tip.
%   'ConeColor'
%      Color of the outer cone surface, specified as an RGB triplet. The
%      default is the main color.
%   'RimColor'
%      Color of the rim, specified as an RGB triplet. The default is the
%      cone color.
%   'BaseColor'
%      Color of the base (inside the rim), specified as an RGB triplet. The
%      default is a lighter shade of the cone color, or light grey if the
%      cone color is white.
%   'TipColor'
%      Color of the highlighted tip, specified as an RGB triplet. The
%      default is a lighter shade of the cone color, or light grey if the
%      cone color is white. Note that the tip uses 'TipColor' only if
%      'TipMode' is set to '*', or set to '*' and the vector in question is
%      directly facing the camera. If the tip is not highlighted, the
%      default color is the cone color.
%   'SphereColor'
%      Color of the sphere marking the origin, specified as an RGB triplet.
%      The default is the main color.
%   'TipMode'
%      Tip highlight mode ('' (default)|'o'|'*'); this overrides any mode
%      specified in STYLE. In default mode, the tip is not highlighted but
%      uses the same color as the rest of the outer cone surface. If the
%      mode is set to '*', the tip is highlighted using 'TipColor'. If the
%      mode is set to 'o', the tip is highlighted using 'TipColor' but only
%      if the vector in question is directly facing the camera.
%   'SphereDiameter'
%      Diameter of the sphere marking the origin specified in points,
%      where 1 point = 1/72 of an inch. The default is 0 (no sphere).
%   'ShaftWidth'
%      Width (diameter) of the shaft in points, where 1 point = 1/72 of an
%      inch; this overrides any width specified in STYLE. The default is 1
%      point. Note that the default cone width and default cone length
%      scale linearly with 'ShaftWidth'.
%   'ConeWidth'
%      Width (diameter) of the cone base incl. rim in points, where 1 point
%      = 1/72 of an inch. The default is 12 times 'ShaftWidth'.
%   'ConeLength'
%      Full length of the cone in points, where 1 point = 1/72 of an inch.
%      The default is 3 times 'ConeWidth'. Note that a cone appears in its
%      full length only if the vector is parallel to the viewing plane.
%   'TipFraction'
%      Ratio of the length of the tip to the full length of the cone,
%      expressed as a fractional value between 0 and 1. The default is 0.2.
%   'RimFraction'
%      Ratio of the rim thickness to the radius of the cone, expressed as a
%      fractional value between 0 and 1. The default is 0.1.
%   'NumPoints'
%      Number of points around the vector circumference, specified as a
%      positive whole number. The minimum is 2; the default is 50.
%
%   A vector will have the intended appearance as long as the axis limits
%   do not change when the vector is drawn. It is therefore strongly
%   recommended to set all axis limits before drawing the vector(s), or to
%   call VECTORUPDATE after drawing the vector(s). VECTORUPDATE can also be
%   called non-programmatically for a vector group by clicking on any
%   vector in the group.
%
%   Resizing the figure or axes will also change the vector dimensions.
%   Call VECTORUPDATE in order to restore it to its intended appearance.
%
%   Furthermore, VECTOR needs access to the data aspect ratio, which is
%   only reported by MATLAB if the (default) “stretch-to-fill” behavior is
%   disabled. If necessary, VECTOR will therefore change the data aspect
%   ratio mode to 'manual' and issue a warning. If the data aspect ratio is
%   changed after a vector is drawn, call VECTORUPDATE to restore the
%   vector to its intended appearance.
%
%Example:
%
%   % Cartesian unit vectors with a red sphere at the origin
%   figure; view(3); daspect([1,1,1]);
%   xlim([-0.5,1]); ylim([-0.5,1]); zlim([-0.5,1]);
%   vector([0,0,0], [1,0,0; 0,1,0; 0,0,1], SphereDiameter=6, SphereColor=[1,0,0]);
%
%See also VECTORUPDATE.

% Created 2021-04-26 by Jorg C. Woehl.
% 2021-05-02 (JCW): First release version (v1.0).

%% Input argument validation

arguments
    O (:,3) double {mustBeNonempty, mustBeFinite, mustBeReal}
    P (:,3) double {mustBeNonempty, mustBeFinite, mustBeReal}
    % these properties will be stored as vect.O and vect.P
    style {mustBeTextScalar} = '1'
    % overridden by vect.TipMode, vect.Color, and vect.ShaftWidth (if specified)
    vect.Color (1,3) double {mustBeFinite, mustBeInRange(vect.Color,0,1,'inclusive')}
    vect.ConeColor (1,3) double {mustBeFinite, mustBeInRange(vect.ConeColor,0,1,'inclusive')}
    vect.RimColor (1,3) double {mustBeFinite, mustBeInRange(vect.RimColor,0,1,'inclusive')}
    vect.BaseColor (1,3) double {mustBeFinite, mustBeInRange(vect.BaseColor,0,1,'inclusive')}
    vect.TipColor (1,3) double {mustBeFinite, mustBeInRange(vect.TipColor,0,1,'inclusive')}
    vect.SphereColor (1,3) double {mustBeFinite, mustBeInRange(vect.SphereColor,0,1,'inclusive')}
    vect.TipMode {mustBeMember(vect.TipMode, {'','o','*'})}
    vect.SphereDiameter double {mustBeScalarOrEmpty, mustBeFinite, mustBeNonnegative} = 0
    vect.ShaftWidth double {mustBeScalarOrEmpty, mustBeFinite, mustBeNonnegative}
    vect.ConeWidth double {mustBeScalarOrEmpty, mustBeFinite, mustBeNonnegative} = []
    vect.ConeLength double {mustBeScalarOrEmpty, mustBeFinite, mustBeNonnegative} = []
    vect.TipFraction (1,1) double {mustBeFinite, mustBeInRange(vect.TipFraction,0,1,'inclusive')} = 0.2
    vect.RimFraction (1,1) double {mustBeFinite, mustBeInRange(vect.RimFraction,0,1,'inclusive')} = 0.1
    vect.NumPoints (1,1) double {mustBeFinite, mustBeInteger, mustBeGreaterThan(vect.NumPoints,1)} = 50
end

% store O and P in the vector structure
vect.O = O;
vect.P = P;

% check size of O and extend if needed
if (size(O,1) == 1)
    % O is 1-by-3; repeat it to match the size of P
    oneOrigin = true;
    O = repmat(O, size(P,1), 1);
else
    oneOrigin = false;
end

% check size of P and extend if needed
if (size(P,1) == 1)
    % P is 1-by-3; repeat it to match the size of O
    P = repmat(P, size(O,1), 1);
end

% make sure O and P have the same size
assert(isequal(size(O), size(P)), 'vector:IncorrectInputType',...
    'If input 1 and input 2 are matrices, they must have the same size.');

% get current axes
ax = gca;
if ~strcmp(ax.DataAspectRatioMode, 'manual')
    warning('vector:DataAspectRatio',...
        'Data aspect ratio mode changed to ''manual''.');
end
ax.DataAspectRatioMode = 'manual';

%% Parse STYLE

% color: parse style for one of the predefined colors (see ColorSpec documentation)
pat = regexpPattern('(y|m|c|r|g|b|w|k)');
vectorColor = extract(style, pat);
if isempty(vectorColor)
    % nothing found, check optional Color argument
    if ~isfield(vect, 'Color')
        % not specified, set to default color (black)
        vect.Color = [0 0 0];
    end
else
    if isfield(vect, 'Color')
        warning('vector:Color',...
            'Value for ''Color'' overrides color specified in input 3.');
    else
        % only keep first occurrence
        vectorColor = vectorColor{1};
        % convert to RGB triplet by drawing an invisible dummy line
        % (because it's invisible, it will not change any axes limits!)
        h = line(ax, 0, 0, 0, 'Color', vectorColor, 'Visible', 'off');
        vect.Color = h.Color;
        delete(h);
    end
end

% shaft width in points: parse style for number
pat = regexpPattern('\d+[.]?\d*');
shaftWidth = extract(style, pat);
if isempty(shaftWidth)
    % nothing found, check optional ShaftWidth argument
    if ~isfield(vect, 'ShaftWidth')
        % not specified, set to 1 point (default)
        vect.ShaftWidth = 1;
    end
else
    if isfield(vect, 'ShaftWidth')
        warning('vector:ShaftWidth',...
            'Value for ''ShaftWidth'' overrides width specified in input 3.');
    else
        % only keep first occurrence
        vect.ShaftWidth = str2double(shaftWidth{1});
    end
end

% tip highlight: parse style for 'o' or '*'
pat = regexpPattern('(*|o)');
TipMode = extract(style, pat);
if isempty(TipMode)
    % nothing found, check optional TipMode argument
    if ~isfield(vect, 'TipMode')
        % not specified, set to '' (default)
        vect.TipMode = '';
    end
else
    if isfield(vect, 'TipMode')
        warning('vector:TipMode',...
            'Value for ''TipMode'' overrides style specified in input 3.');
    else
        % only keep first occurrence
        vect.TipMode = TipMode{1};
    end
end

%% Dimensions

% diameter of sphere (in points) marking the origin O
if isempty(vect.SphereDiameter)
    vect.SphereDiameter = 0;         % no origin marker (sphere)
end

% cone width in points
if isempty(vect.ConeWidth)
    vect.ConeWidth = 12*vect.ShaftWidth;  % default cone width
end

% cone length in points
if isempty(vect.ConeLength)
    vect.ConeLength = 3*vect.ConeWidth;   % default cone length
end

% fraction of cone height that forms the tip
fTip = vect.TipFraction;

% fraction of cone base radius that forms the rim
fRim = vect.RimFraction;

% determine the angle needed for highlighting the tip
if isempty(vect.TipMode)
    % never highlight the tip; set angle alpha to 0 (default)
    alpha = 0;
elseif strcmp(vect.TipMode, 'o')
    % highlight the tip when it faces the camera; set alpha to base angle (w/o tip)
    alpha = atan(vect.ConeWidth/2/((1-fTip)*vect.ConeLength));
elseif strcmp(vect.TipMode, '*')
    % always highlight the tip; set alpha to infinity
    alpha = Inf;
end

%% Colors

% cone color
if ~isfield(vect, 'ConeColor')
    % default color is the vector color
    vect.ConeColor = vect.Color;
end

% rim color
if ~isfield(vect, 'RimColor')
    % default color is the cone color
    vect.RimColor = vect.ConeColor;
end

% lighter shade of the cone color (default color of base and tip)
liteCol = 1 - 0.2*(1 - vect.ConeColor);
if all(liteCol == vect.ConeColor)
    % cone color is white, so make it light grey
    liteCol = [0.95 0.95 0.95];
end

% base color
if ~isfield(vect, 'BaseColor')
    % default color is a lighter shade of the cone color
    vect.BaseColor = liteCol;
end

% tip color
if ~isfield(vect, 'TipColor')
    % default color is a lighter shade of the cone color
    vect.TipColor = liteCol;
end

% sphere color
if ~isfield(vect, 'SphereColor')
    % default color is the vector color
    vect.SphereColor = vect.Color;
end

%% Create (folded) arrow shape for vector

% get data aspect ratio (to draw cone without distortion)
d = daspect;

% get azimuth and elevation angles in degrees
az = ax.View(1);
el = ax.View(2);

% get axis-to-points conversion factors for current view
[xppt, yppt, zppt] = points2axes(ax);
% convert to sections-per-point
f = [xppt, yppt, zppt]./d;
% reduction factors (due to rotation out of camera plane)
xRed = sqrt(cosd(az)^2 + sind(az)^2*sind(el)^2);
yRed = sqrt(sind(az)^2 + cosd(az)^2*sind(el)^2);
zRed = abs(cosd(el));

% pick the best axes for constructing arrow shape
if (max(f) == f(1))
    fh = f(2)*yRed;      	% horizontal axis is y
    fv = f(3)*zRed;     	% vertical axis is z
    arrowDir = [0 0 1];     % arrow direction
elseif (max(f) == f(2))
    fh = f(1)*xRed;       	% horizontal axis is x
    fv = f(3)*zRed;        	% vertical axis is z
    arrowDir = [0 0 1];     % arrow direction
else
    fh = f(1)*xRed;        	% horizontal axis is x
    fv = f(2)*yRed;       	% vertical axis is y
    arrowDir = [0 1 0];     % arrow direction
end

% convert dimensions in points to axis units
shaftWidth = vect.ShaftWidth*fh;
coneWidth = vect.ConeWidth*fh;
sphDia = vect.SphereDiameter*fh;
coneLength = vect.ConeLength*fv;

% build upright vector with tip at origin and base center at -coneLength
% 1: tip apex
% 1->2: tip
% 2->3: outer cone surface
% 3->4: rim
% 4->5: base
% 5->6: shaft
% 6->7: end of shaft
% 7: origin
[hVector1, hVector2, ~] = cylinder([0, coneWidth/2*fTip, coneWidth/2, coneWidth/2*(1-fRim),...
    shaftWidth/2, shaftWidth/2, 0], vect.NumPoints);
% section the tip and translate cone so that tip apex is at origin
vVector = zeros(size(hVector1));
vVector(2,:) = vVector(2,:) - fTip*coneLength;
vVector(3:5,:) = vVector(3:5,:) - coneLength;

% back to x, y, z coordinates
if (max(f) == f(1))
    yVector = hVector1;
    zVector = vVector;
    xVector = hVector2;
elseif (max(f) == f(2))
    xVector = hVector1;
    zVector = vVector;
    yVector = hVector2;
else
    xVector = hVector1;
    yVector = vVector;
    zVector = hVector2;
end

% color data for vector surface
cVector = ones([size(xVector), 3]);
% set tip (index 1) to cone color; will change to tip color only if highlighted
cVector(1,:,1) = vect.ConeColor(1);
cVector(1,:,2) = vect.ConeColor(2);
cVector(1,:,3) = vect.ConeColor(3);
% set outer cone surface (index 2) to cone color
cVector(2,:,1) = vect.ConeColor(1);
cVector(2,:,2) = vect.ConeColor(2);
cVector(2,:,3) = vect.ConeColor(3);
% set rim (index 3) to rim color
cVector(3,:,1) = vect.RimColor(1);
cVector(3,:,2) = vect.RimColor(2);
cVector(3,:,3) = vect.RimColor(3);
% set base (index 4) to base color
cVector(4,:,1) = vect.BaseColor(1);
cVector(4,:,2) = vect.BaseColor(2);
cVector(4,:,3) = vect.BaseColor(3);
% set shaft (index 5 to 7) to vector color
cVector(5:7,:,1) = vect.Color(1);
cVector(5:7,:,2) = vect.Color(2);
cVector(5:7,:,3) = vect.Color(3);

%% Create sphere as origin marker

% unit sphere centered at [0 0 0]
[xSph, ySph, zSph] = sphere;
% enlarge sphere to final diameter
xSph = xSph * sphDia/2;
ySph = ySph * sphDia/2;
zSph = zSph * sphDia/2;

% color data for sphere surface
cSph = ones([size(xSph) 3]);
cSph(:,:,1) = vect.SphereColor(1);
cSph(:,:,2) = vect.SphereColor(2);
cSph(:,:,3) = vect.SphereColor(3);

%% Plot vectors and spheres

% get camera position (to determine whether to highlight the tip)
cam = (camtarget-campos)./d;	% "squeezed" camera view direction vector
camDir = cam/norm(cam);         % corresponding unit vector

% create group object for vectors and spheres
hGroup = hggroup('Tag', 'vectorgroup', 'UserData', vect,...
    'ButtonDownFcn', {@(src,evt) vectorupdate(src)});

% save current axis limits
axLims = [ax.XLim ax.YLim ax.ZLim];

for n = 1:size(P,1)
    A = O(n,:);                 % origin
    B = P(n,:);                 % tip
    
    % produce "squeezed" vector to account for future expansion by aspect ratio
    sqz = (B-A)./d;             % squeezed vector pointing from origin to tip
    sqzDir = sqz/norm(sqz);     % corresponding unit vector
    
    % draw folded arrow (temporary)
    hVector = surface(xVector, yVector, zVector, cVector,...
        'FaceColor', 'flat', 'EdgeColor', 'none', 'Tag', 'vector', 'Parent', hGroup,...
        'HitTest', 'off');
    
    % rotate arrow so that it aligns with (squeezed) unit vector
    rotAxis = cross(arrowDir,sqzDir);
    if isequal(rotAxis, [0 0 0])
        % unit vectors are parallel or antiparallel, so pick any axis
        rotAxis = [1 0 0];
    end
    rotAngle = acosd(dot(sqzDir,arrowDir));
    rotate(hVector, rotAxis, rotAngle, [0 0 0]);
    
    % expand coordinates of rotated squeezed vector according to data aspect ratio
    x = hVector.XData*d(1);
    y = hVector.YData*d(2);
    z = hVector.ZData*d(3);
    
    % move vector tip (with attached cone) into B
    x(1:5,:) = x(1:5,:) + B(1);
    y(1:5,:) = y(1:5,:) + B(2);
    z(1:5,:) = z(1:5,:) + B(3);
    
    % move vector origin into A
    x(6:end,:) = x(6:end,:) + A(1);
    y(6:end,:) = y(6:end,:) + A(2);
    z(6:end,:) = z(6:end,:) + A(3);
    
    % update vector
    hVector.XData = x;
    hVector.YData = y;
    hVector.ZData = z;
    
    % highlight tip?
    if (acos(dot(-camDir, sqzDir)) < alpha)
        c = hVector.CData;
        % set color of tip (index 1)
        c(1,:,1) = vect.TipColor(1);
        c(1,:,2) = vect.TipColor(2);
        c(1,:,3) = vect.TipColor(3);
        hVector.CData = c;
    end
    
    if (((n==1) || ~oneOrigin) && (sphDia>0))
        % draw sphere as origin marker
        surface(xSph*d(1)+A(n,1), ySph*d(2)+A(n,2), zSph*d(3)+A(n,3), cSph,...
            'FaceColor', 'flat', 'EdgeColor', 'none', 'Tag', 'sphere', 'Parent', hGroup,...
            'HitTest', 'off');
    end
end

% issue warning if axis limits have changed
if ~all(axLims == [ax.XLim ax.YLim ax.ZLim])
    % axis limits have changed
    warning('vector:AxisLimitsChanged',...
        'Axis limits and vector dimensions have changed! Call ''vectorupdate'' or click on any vector to correct this issue.');
end