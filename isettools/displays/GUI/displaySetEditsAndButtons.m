function displaySetEditsAndButtons(handles)
%% function displaySetEditsAndButtons
%    Fill scene window fields based on the current display information
%    displaySetEditsAndButtons(handles)
%
%  (HJ) May, 2014


%% Set values to boxes in display window
d = vcGetObject('DISPLAY');

if isempty(d)
    % No display, so set empty
    str = [];
    set(handles.editMaxLum, 'String', str);
    set(handles.editVar, 'String', 'N/A');
    set(handles.editPPI, 'String', str);
    
    % Select scene popup contents
    set(handles.popupSelectDisplay,...
        'String', 'No Display',...
        'Value', 1);
else
    % Text boxes on right: we should reduce the fields in SCENE.
    xyz = displayGet(d, 'white xyz');
    set(handles.editMaxLum, 'String', num2str(xyz(2)));
    set(handles.editVar, 'String', 'N/A');
    set(handles.editPPI, 'String', num2str(displayGet(d, 'dpi')));
    
    % Select scene popup contents
    set(handles.popupSelectDisplay,...
        'String',vcGetObjectNames('DISPLAY'),...
        'Value',vcGetSelectedObject('DISPLAY'));    
end

%% Description box on upper right
set(handles.txtSummary,'String', displayDescription(d));

%% Redraw the main image 
displayShowImage(d, [], handles.axes1);

%% Set subpixel figure
psfs = displayGet(d, 'psfs');
if ~isempty(psfs)
    if size(psfs,3) == 3
        imshow(psfs / max(psfs(:)), 'Parent', handles.axes4);
    else
        gam = 1;
        wave = displayGet(d, 'wave');
        photons = vcReadImage(psfs, 'rgb', d);
        axes(handles.axes4);
        imageSPD(photons, wave, gam, [], [], 1);
        axes(handles.axes1);
    end
end

%% END
return;