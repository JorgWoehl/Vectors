function hGroup = vectorupdate(hArg, new)
%VECTORUPDATE Update or restore vectors.
%   VECTORUPDATE restores the appearance of vectors that have become
%   distorted or have changed in size due to changes in figure size, axis
%   limits, or data aspect ratio, and updates vector properties with new
%   values passed as arguments. By default, VECTORUPDATE acts on all
%   vectors found in the current axes.  Axis limits are frozen at the
%   current values to ensure that vectors are properly dimensioned after
%   VECTORUPDATE is called.
%
%   VECTORUPDATE(H) will only act on the vectors in the vector group
%   specified by H instead of all vectors in the current axes.
%
%   VECTORUPDATE(AX) will act on all vectors in the axes specified by AX
%   instead of the current axes.
%
%   VECTORUPDATE(FIG) will act on all vectors in the current axes of the
%   figure specified by FIG instead of the current axes.
%
%   VECTORUPDATE(..., Name-Value-Pairs) updates vector properties using
%   comma-separated 'NAME',VALUE syntax or the the equal-sign syntax
%   NAME=VALUE introduced in R2021a. All properties that can be passed as
%   arguments to VECTOR are supported. In addition, the origin(s) O and
%   point(s) P can be changed using the properties 'O' and 'P',
%   respectively.
%
%   H = VECTORUPDATE(...) returns the handle of a Group object H containing
%   the restored or updated vectors.
%
%   The figure and axes containing the restored or updated vectors will
%   become the current figure and current axes, respectively, when
%   VECTORUPDATE is executed.
%
%Example:
%
%   % draw a 3D vector but let MATLAB choose the axis limits
%   figure; view(-30, 15); axis equal; set(gca,'Clipping','off');
%   vector([0 0 0], [3 3 3]); box on;
%   % axis limits have changed -> call vectorupdate
%   vectorupdate;
%
%See also VECTOR.

% Created 2021-04-26 by Jorg C. Woehl.

%% Input argument validation

arguments
    hArg {mustBeScalarOrEmpty} = []
    new.O (:,3) double {mustBeNonempty, mustBeFinite, mustBeReal}
    new.P (:,3) double {mustBeNonempty, mustBeFinite, mustBeReal}
    new.Color (1,3) double {mustBeFinite, mustBeInRange(new.Color,0,1,'inclusive')}
    new.ConeColor (1,3) double {mustBeFinite, mustBeInRange(new.ConeColor,0,1,'inclusive')}
    new.RimColor (1,3) double {mustBeFinite, mustBeInRange(new.RimColor,0,1,'inclusive')}
    new.BaseColor (1,3) double {mustBeFinite, mustBeInRange(new.BaseColor,0,1,'inclusive')}
    new.TipColor (1,3) double {mustBeFinite, mustBeInRange(new.TipColor,0,1,'inclusive')}
    new.SphereColor (1,3) double {mustBeFinite, mustBeInRange(new.SphereColor,0,1,'inclusive')}
    new.TipMode {mustBeMember(new.TipMode, {'','o','*'})}
    new.SphereDiameter double {mustBeScalarOrEmpty, mustBeFinite, mustBeNonnegative}
    new.ShaftWidth double {mustBeScalarOrEmpty, mustBeFinite, mustBeNonnegative}
    new.ConeWidth double {mustBeScalarOrEmpty, mustBeFinite, mustBeNonnegative}
    new.ConeLength double {mustBeScalarOrEmpty, mustBeFinite, mustBeNonnegative}
    new.TipFraction (1,1) double {mustBeFinite, mustBeInRange(new.TipFraction,0,1,'inclusive')}
    new.RimFraction (1,1) double {mustBeFinite, mustBeInRange(new.RimFraction,0,1,'inclusive')}
    new.NumPoints double {mustBeInteger, mustBeGreaterThan(new.NumPoints,1),...
        mustBeFinite, mustBeScalarOrEmpty, mustBeNonempty}
end

if isempty(hArg)
    % [] was passed or hArg was not specified; look for current figure
    fig = get(groot,'CurrentFigure');	% get current figure handle without forcing the creation of a new figure
    if isempty(fig)
        error('vectorupdate:NoCurrentFigure',...
            'This function requires a current figure.');
    end
    h = findobj(fig, 'Tag', 'vectorgroup');
elseif (isa(hArg, 'matlab.ui.Figure') || isa(hArg, 'matlab.graphics.axis.Axes'))
    h = findobj(hArg, 'Tag', 'vectorgroup');
elseif (isa(hArg, 'matlab.graphics.primitive.Group') && strcmp(hArg.Tag, 'vectorgroup'))
    h = hArg;
else
    error('vectorupdate:IncorrectInputType',...
        ['Optional input 1 must be a figure, axes object, or vectorgroup, not a "' class(hArg) '".']);
end

%% Redraw vector(s)

if ~isempty(h)
    ax = ancestor(h, 'axes');           % determine axes containing h
    axes(ax);                           % make ax the current axes
    axis manual;                        % freeze axis limits

    % get vector properties
    vect = h.UserData;
    
    % override with new properties (if applicable)
    newFields = fieldnames(new);
    for m = 1:numel(newFields)
        vect.(newFields{m}) = new.(newFields{m});
    end
    
    % extract required arguments (O and P)
    O = vect.O;
    P = vect.P;
    
    % remove fields O and P from vect
    vect = rmfield(vect, {'O', 'P'});
    
    % delete existing vectorgroup
    delete(h);
    
    % create new vectorgroup
    nvPairs = namedargs2cell(vect);
    hGroup = vector(O, P, '', nvPairs{:});
else
    hGroup = matlab.graphics.primitive.Group.empty;
end

end
