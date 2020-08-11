function varargout = ROI_act(varargin)
% ROI_ACT MATLAB code for ROI_act.fig
%      ROI_ACT, by itself, creates a new ROI_ACT or raises the existing
%      singleton*.
%
%      H = ROI_ACT returns the handle to a new ROI_ACT or the handle to
%      the existing singleton*.
%
%      ROI_ACT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ROI_ACT.M with the given input arguments.
%
%      ROI_ACT('Property','Value',...) creates a new ROI_ACT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ROI_act_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ROI_act_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ROI_act

% Last Modified by GUIDE v2.5 06-Aug-2020 22:25:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ROI_act_OpeningFcn, ...
    'gui_OutputFcn',  @ROI_act_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ROI_act is made visible.
function ROI_act_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ROI_act (see VARARGIN)
handles.image = [];
handles.ROI.points = cell(4, 1);
handles.ROI.line_handles = zeros(4, 1);
handles.ROI.label_handles = zeros(4, 1);
handles.ROI_act_figure = findobj('Tag', 'ROI_act_figure');
handles.axes_image = findobj('Tag', 'axes_image');
handles.ROI_line_colors = {'black', 'red', 'blue', 'green'};
handles.enable_ROI_checkboxes = zeros(4, 1);
handles.enable_ROI_edit_texts = zeros(4, 1);
for ROI_index = 1:4
    handles.enable_ROI_checkboxes(ROI_index) = findobj('Tag', sprintf('ROI_%d_checkbox', ROI_index));
    handles.enable_ROI_edit_texts(ROI_index) = findobj('Tag', sprintf('ROI_%d_edit_text', ROI_index));
end
handles.min_threshold_slider = findobj('Tag', 'min_threshold_slider');
handles.max_threshold_slider = findobj('Tag', 'max_threshold_slider');
handles.x_min_slider = findobj('Tag', 'x_min_slider');
handles.x_max_slider = findobj('Tag', 'x_max_slider');
handles.y_min_slider = findobj('Tag', 'y_min_slider');
handles.y_max_slider = findobj('Tag', 'y_max_slider');
handles.open_new_image_button = findobj('Tag', 'open_new_image_button');
handles.save_image_ROIs_button = findobj('Tag', 'save_image_ROIs_button');
handles.get_ROI_statistics_button = findobj('Tag', 'get_ROI_statistics_button');
handles.enter_ROI_button = findobj('Tag', 'new_ROI_button');
handles.delete_ROI_button = findobj('Tag', 'delete_ROI_button');
handles.load_ROI_button = findobj('Tag', 'load_ROIs_button');
handles.save_ROI_button = findobj('Tag', 'save_ROIs_button');
handles.move_ROI_button = findobj('Tag', 'move_ROI_button');
handles.move_ROI_point_button = findobj('Tag', 'move_ROI_point_button');
handles.add_ROI_point_button = findobj('Tag', 'add_ROI_point_button');
handles.help_needed_checkbox = findobj('Tag', 'help_needed_checkbox');
disable_all_UI_controls(handles);
set(handles.help_needed_checkbox, 'Enable', 'on');
set(handles.min_threshold_slider, 'Min', 0.00, 'Max', 1.00, 'Value', 0.50);
set(handles.max_threshold_slider, 'Min', 0.00, 'Max', 1.00, 'Value', 0.50);
set(handles.x_min_slider, 'Min', 0.00, 'Max', 1.00, 'Value', 0.00);
set(handles.x_max_slider, 'Min', 0.00, 'Max', 1.00, 'Value', 1.00);
set(handles.y_min_slider, 'Min', 0.00, 'Max', 1.00, 'Value', 0.00);
set(handles.y_max_slider, 'Min', 0.00, 'Max', 1.00, 'Value', 1.00);
for ROI_index = 1:4
    label = sprintf('ROI %d', ROI_index);
    set(handles.enable_ROI_edit_texts(ROI_index), 'String', label);
    set(handles.enable_ROI_checkboxes(ROI_index), 'Value', 0);
end
% Display an empty image
handles = update_image(handles, [], false);
set(handles.ROI_act_figure, 'Visible', 'on');
% Expressions below correspond to the case of a 4-inch fiber
% optics taper imaging onto a 1024x1024-pixel detector
pixel_width = 4 * 25.40 / 1024;
pixel_height = 4 * 25.40 / 1024;
prompt = {'Enter pixel width (in mm):', 'Enter pixel height (in mm):'};
default_input = {num2str(pixel_width, '%.4f'), num2str(pixel_height, '%.4f')};
% Get from the user the physical pixel size
answer = inputdlg(prompt, 'Enter pixel size', [1, 50], default_input);
update_UI_controls(handles);
if ~isempty(answer)
    handles.pixel_width = str2double(answer{1});
    handles.pixel_height = str2double(answer{2});
end
% Choose default command line output for ROI_act
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ROI_act wait for user response (see UIRESUME)
% uiwait(handles.ROI_act_figure);


% --- Outputs from this function are returned to the command line.
function varargout = ROI_act_OutputFcn(~, ~, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function handles = update_image(handles, axes_image, reset_slides)
if isempty(axes_image)
    axes_image = handles.axes_image;
end
if ~isempty(handles.image)
    size = 5;
    filter = ones(size, size) / (size * size);
    % Smoothing with a mean (average) filter
    smoothed = filter2(filter, handles.image);
    % Enable all the slides because an image is present
    set(handles.min_threshold_slider, 'Enable', 'on');
    set(handles.max_threshold_slider, 'Enable', 'on');
    set(handles.x_min_slider, 'Enable', 'on');
    set(handles.x_max_slider, 'Enable', 'on');
    set(handles.y_min_slider, 'Enable', 'on');
    set(handles.y_max_slider, 'Enable', 'on');
    if reset_slides
        min_val = min(smoothed(:));
        max_val = max(smoothed(:));
        set(handles.min_threshold_slider, 'Min', min_val, 'Max', max_val, ...
            'Value', min_val, 'SliderStep', [0.01, 0.10]);
        set(handles.max_threshold_slider, 'Min', min_val, 'Max', max_val, ...
            'Value', max_val, 'SliderStep', [0.01, 0.10]);
    else
        min_val = get(handles.min_threshold_slider, 'Value');
        max_val = get(handles.max_threshold_slider, 'Value');
    end
    if min_val >= max_val
        uiwait(msgbox(['The value of the minimum threshold cannot exceed ', ...
            'that of the maximum threshold!']', 'Warning', 'warn'));
        % Fix the slide values if the minimum threshold
        % exceedes that of the maximum threshold
        new_val = (min_val + max_val) / 2;
        my_eps = 0.01;
        min_val = max([new_val - my_eps, min(smoothed(:))]);
        max_val = min([new_val + my_eps, max(smoothed(:))]);
        set(handles.min_threshold_slider, 'Value', min_val);
        set(handles.max_threshold_slider, 'Value', max_val);
    end
    handles.image_handle = imagesc(smoothed, 'Parent', axes_image, [min_val, max_val]);
    for ROI_index = 1:4
        points = handles.ROI.points{ROI_index};
        % Check if a ROI exists and is ebabled
        if ~isempty(points) && (get(handles.enable_ROI_checkboxes(ROI_index), 'Value') > 0)
            line_color = handles.ROI_line_colors{ROI_index};
            % Draw the ROI
            handles.ROI.line_handles(ROI_index) = line(points(:, 1), points(:, 2), ...
                'Color', line_color, 'LineStyle', '-', 'LineWidth', 1);
            text_pos = [(points(1, 1) + points(2, 1)) / 2, (points(1, 2) + points(2, 2)) / 2];
            text_angle = rad2deg(atan((points(1, 2) - points(2, 2)) / (points(1, 1) - points(2, 1))));
            % Write the ROI label
            handles.ROI.label_handles(ROI_index) = text(text_pos(1), text_pos(2), ...
                get(handles.enable_ROI_edit_texts(ROI_index), 'String'));
            set(handles.ROI.label_handles(ROI_index), 'Rotation', text_angle, ...
                'Color', line_color, 'LineStyle', 'none', 'BackgroundColor', 'none');
            set(handles.ROI.label_handles(ROI_index), 'HorizontalAlignment', 'center', ...
                'VerticalAlignment', 'bottom', 'FontSize', 10, 'clipping', 'on');
        end
    end
else
    % If there is no image to display, draw a gray image and disable all the slides
    handles.image_handle = imagesc(zeros(256, 256), 'Parent', axes_image, [-1, +1]);
    set(handles.min_threshold_slider, 'Enable', 'off');
    set(handles.max_threshold_slider, 'Enable', 'off');
    set(handles.x_min_slider, 'Enable', 'off');
    set(handles.x_max_slider, 'Enable', 'off');
    set(handles.y_min_slider, 'Enable', 'off');
    set(handles.y_max_slider, 'Enable', 'off');
end
axis(axes_image, 'image');
set(axes_image, 'YDir', 'normal', 'XDir', 'normal');
set(axes_image, 'XTick', [], 'YTick', []);
if ~isempty(handles.image)
    if reset_slides
        % Initialize the slides used for cropping
        axis_x_limits = get(axes_image, 'XLim');
        axis_y_limits = get(axes_image, 'YLim');
        set(handles.x_min_slider, 'Min', axis_x_limits(1), 'Max', axis_x_limits(2), ...
            'Value', axis_x_limits(1), 'SliderStep', [0.01, 0.10]);
        set(handles.x_max_slider, 'Min', axis_x_limits(1), 'Max', axis_x_limits(2), ...
            'Value', axis_x_limits(2), 'SliderStep', [0.01, 0.10]);
        set(handles.y_min_slider, 'Min', axis_y_limits(1), 'Max', axis_y_limits(2), ...
            'Value', axis_y_limits(1), 'SliderStep', [0.01, 0.10]);
        set(handles.y_max_slider, 'Min', axis_y_limits(1), 'Max', axis_y_limits(2), ...
            'Value', axis_y_limits(2), 'SliderStep', [0.01, 0.10]);
    else
        % Crops the image
        axis_x_limits = [get(handles.x_min_slider, 'Value'), get(handles.x_max_slider, 'Value')];
        axis_y_limits = [get(handles.y_min_slider, 'Value'), get(handles.y_max_slider, 'Value')];
        if (axis_x_limits(1) < axis_x_limits(2)) && (axis_y_limits(1) < axis_y_limits(2))
            set(axes_image, 'XLim', axis_x_limits, 'YLim', axis_y_limits);
        end
    end
end
% Low-counts areas are shown white;
% high-counts areas are shown black
colormap(flipud(bone(256)));


% --- Executes on button press in open_new_image_button.
function open_new_image_button_Callback(hObject, ~, handles)
% hObject    handle to open_new_image_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.help_needed_checkbox, 'Value') == 1
    [icondata, iconcmap] = imread('luca_caucci.jpeg');
    my_message = ['You are going to select a file with an image to open. ', ...
        'The image must be of size 1024 x 1024. The data type must be ', ...
        'little-endian 32-bit unsigned integer with no file header. You ', ...
        'can use the min/max threshold slides to change the grayscale map, ', ...
        'and you can use the slides below and to the left of the image to ', ...
        'zoom in and out by cutting the image around its edges.'];
    uiwait(msgbox(my_message, 'Help', 'custom', icondata, iconcmap, 'modal'));
end
ROI_present = zeros(4, 1);
for ROI_index = 1:4
    ROI_present(ROI_index) = ~isempty(handles.ROI.points{ROI_index});
end
if any(ROI_present) && ~isempty(handles.image)
    % Warn the user that they will lose the ROI if a new image is loaded
    message = ['An image and valid ROI(s) have already been entered/loaded. You ', ...
        'will lose them if you open a new image. Do you want to continue?'];
    answer = questdlg(message, 'ROI Present', 'Continue', 'Cancel', 'Continue');
else
    answer = 'Continue';
end
if strcmp(answer, 'Continue')
    [file, path] = uigetfile('*.dat', 'Select file for open image');
    if ~isequal(file, 0)
        filename = fullfile(path, file);
        fid = fopen(filename, 'r', 'ieee-le');
        if fid ~= -1
            tmp = fread(fid, [1024, 1024], 'uint32');
            fclose(fid);
            if isequal(size(tmp), [1024, 1024])
                % Correct for bad pixels: if there are a few pixels with
                % very large pixel count, reset their pixel count to 0
                max_val = max(tmp(:));
                if sum(tmp(:) > (max_val / 20)) < (numel(tmp) / 10^4)
                    tmp(tmp > (max_val / 20)) = 0;
                end
                handles.image = uint32(tmp);
                for ROI_index = 1:4
                    % Reset the ROI labels
                    handles.ROI.points{ROI_index} = [];
                    label = sprintf('ROI %d', ROI_index);
                    set(handles.enable_ROI_edit_texts(ROI_index), 'String', label);
                    set(handles.enable_ROI_checkboxes(ROI_index), 'Value', 0);
                end
            else
                msgbox('Unexpected file size!', 'Error', 'error', 'modal');
            end
        else
            error('Cannot open file %s!', filename);
        end
    end
end
handles = update_image(handles, [], true);
guidata(hObject, handles);
update_UI_controls(handles);


% --- Executes on slider movement.
function max_threshold_slider_Callback(hObject, ~, handles)
% hObject    handle to max_threshold_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles = update_image(handles, [], false);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function max_threshold_slider_CreateFcn(hObject, ~, ~)
% hObject    handle to max_threshold_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function min_threshold_slider_Callback(hObject, ~, handles)
% hObject    handle to min_threshold_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles = update_image(handles, [], false);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function min_threshold_slider_CreateFcn(hObject, ~, ~)
% hObject    handle to min_threshold_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in new_ROI_button.
function new_ROI_button_Callback(hObject, ~, handles)
% hObject    handle to new_ROI_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disable_all_UI_controls(handles);
if get(handles.help_needed_checkbox, 'Value') == 1
    [icondata, iconcmap] = imread('luca_caucci.jpeg');
    my_message = ['You will be asked first how many points you want to use ', ...
        'to define a polygon for the region-of-interest (ROI). You will enter ', ...
        'ROI points by clicking on the image. Green segments connecting the ', ...
        'points will appear. The polygon will automatically be closed and you ', ...
        'do not need to have the last point coincide with the first point. ', ...
        'Once done, the ROI segments will be colored red. You will then be ', ...
        'asked to enter a label for the ROI. You can change the label later.'];
    uiwait(msgbox(my_message, 'Help', 'custom', icondata, iconcmap, 'modal'));
end
ROI_absent = zeros(4, 1);
for ROI_index = 1:4
    ROI_absent(ROI_index) = isempty(handles.ROI.points{ROI_index});
end
% Look for the first "empty" ROI slot
ROI_index = find(ROI_absent, 1);
prompt = {'Enter the number of ROI vertices'};
answer = inputdlg(prompt, 'Number of ROI Vertices', [1, 35], {'8'});
if isempty(answer)
    num_points = 0;
else
    num_points = fix(str2double(answer{1}));
end
if num_points < 3
    msgbox('Invalid Value! You need at least 3 points!', 'Error', 'error', 'modal');
else
    % Create an empty "list of points" with an extra entry so that
    % the last element of the list can be set equal to the first
    points = zeros(num_points + 1, 2);
    axis_x_limits = get(handles.axes_image, 'XLim');
    axis_y_limits = get(handles.axes_image, 'YLim');
    old_pointer = get(handles.ROI_act_figure, 'Pointer');
    set(handles.ROI_act_figure, 'Pointer', 'crosshair');
    drawnow;
    % Set a "dummy" function so that CurrentPoint is constantly updated
    set(handles.ROI_act_figure, 'WindowButtonMotionFcn', @(o, e) []);
    num_entered = 0;
    while num_entered < num_points
        if num_entered >= 1
            mouse_listener = addlistener(handles.ROI_act_figure, 'WindowMouseMotion', ...
                @(o, e) new_ROI(o, e, ROI_line, ROI_label, points(1:num_entered, :), num_entered, handles));
        end
        valid_point = false;
        while ~valid_point
            key = waitforbuttonpress;
            while key ~= 0
                key = waitforbuttonpress;
            end
            tmp_point = get(handles.axes_image, 'CurrentPoint');
            clicked_point = tmp_point(1, 1:2);
            valid_point = within_limits(clicked_point, axis_x_limits, axis_y_limits);
        end
        if num_entered >= 1
            delete(mouse_listener);
        end
        num_entered = num_entered + 1;
        points(num_entered, :) = clicked_point;
        line_color = handles.ROI_line_colors{ROI_index};
        if num_entered == 1
            % If only one point has been entered, create the line and label objects
            ROI_line = line(clicked_point(1), clicked_point(2), ...
                'Color', line_color, 'LineStyle', '--', 'LineWidth', 1);
            ROI_label = text(clicked_point(1), clicked_point(2), 'New ROI');
            set(ROI_label, 'Visible', 'off', 'Color', line_color, ...
                'LineStyle', 'none', 'BackgroundColor', 'none');
            set(ROI_label, 'HorizontalAlignment', 'center', ...
                'VerticalAlignment', 'bottom', 'FontSize', 10, 'clipping', 'on');
        else
            % If at least two points have been entered, update the line
            % object, set the label position and make it visible
            set(ROI_line, 'XData', points(1:num_entered, 1));
            set(ROI_line, 'YData', points(1:num_entered, 2));
            text_pos = [(points(1, 1) + points(2, 1)) / 2, (points(1, 2) + points(2, 2)) / 2];
            text_angle = rad2deg(atan((points(1, 2) - points(2, 2)) / (points(1, 1) - points(2, 1))));
            set(ROI_label, 'Visible', 'on', 'Position', text_pos, 'Rotation', text_angle);
        end
        % Write the point index next to the point the user just entered
        text(clicked_point(1), clicked_point(2), int2str(num_entered), 'Color', ...
            line_color, 'VerticalAlignment', 'bottom', 'FontSize', 10, 'clipping', 'on');
        drawnow;
    end
    % Makes a closed polygon
    points(num_points + 1, :) = points(1, :);
    set(ROI_line, 'XData', points(:, 1), 'YData', points(:, 2));
    set(handles.ROI_act_figure, 'Pointer', old_pointer);
    drawnow;
    set(handles.ROI_act_figure, 'WindowButtonMotionFcn', []);
    % Make sure the ROI does not self intersect
    if is_self_intersecting(points)
        uiwait(msgbox('The ROI you entered is self-intersecting!', 'Error', 'error', 'modal'));
        handles = update_image(handles, [], false);
        guidata(hObject, handles);
    else
        % Get a label for the ROI
        prompt = 'Enter a label for the ROI you just entered:';
        default_input = {get(handles.enable_ROI_edit_texts(ROI_index), 'String')};
        answer = inputdlg(prompt, 'Label ROI', [1, 50], default_input);
        if ~isempty(answer)
            handles.ROI.points{ROI_index} = points;
            set(handles.enable_ROI_checkboxes(ROI_index), 'Value', 1);
            set(handles.enable_ROI_edit_texts(ROI_index), 'String', answer{1});
        end
    end
end
handles = update_image(handles, [], false);
guidata(hObject, handles);
update_UI_controls(handles);


function new_ROI(~, ~, ROI_line, ROI_label, points, num_entered, handles)
axis_x_limits = get(handles.axes_image, 'XLim');
axis_y_limits = get(handles.axes_image, 'YLim');
tmp_point = get(handles.axes_image, 'CurrentPoint');
point = tmp_point(1, 1:2);
if ~within_limits(point, axis_x_limits, axis_y_limits)
    point = force_within_limits(point, axis_x_limits, axis_y_limits);
end
new_segments_x = [points(:, 1); point(1)];
new_segments_y = [points(:, 2); point(2)];
set(ROI_line, 'XData', new_segments_x, 'YData', new_segments_y);
if num_entered == 1
    text_pos = [(points(1, 1) + point(1)) / 2, (points(1, 2) + point(2)) / 2];
    text_angle = rad2deg(atan((points(1, 2) - point(2)) / (points(1, 1) - point(1))));
    set(ROI_label, 'Visible', 'on', 'Position', text_pos, 'Rotation', text_angle);
end


function self_intersect = is_self_intersecting(points)
% Check if the ROI is self-intersecting by checking if each segment intersects
% with any of the segments that follow. Segment from P_1 to P_2 is parameterized
% as P(u) = u P_1 + (1 - u) P_2, with 0 <= u <= 1. If for segments P(u) and Q(v)
% we have P(u) = Q(u) for some 0 <= u <= 1 and 0 <= v <= 1, then the segments
% intersect.  Calculation of intersections requires solving a simple system of
% two equations with two unknowns.
self_intersect = false;
num_points = size(points, 1);
num_segments = num_points - 1;
if num_segments > 1
    for m = 1:(num_segments - 1)
        u_0 = points(m + 0, :);
        u_1 = points(m + 1, :);
        a = u_1 - u_0;
        for n = (m + 1):num_segments
            v_0 = points(n + 0, :);
            v_1 = points(n + 1, :);
            b = v_0 - v_1;
            c = v_0 - u_0;
            det_A = a(1) * b(2) - a(2) * b(1);
            if abs(det_A) > 1e-6
                t(1) = (b(2) * c(1) - b(1) * c(2)) / det_A;
                t(2) = (a(1) * c(2) - a(2) * c(1)) / det_A;
                if all(0 < t) && all(t < 1)
                    self_intersect = true;
                end
            end
        end
    end
end


% --- Executes on button press in get_ROI_statistics_button.
function get_ROI_statistics_button_Callback(~, ~, handles)
% hObject    handle to get_ROI_statistics_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.help_needed_checkbox, 'Value') == 1
    [icondata, iconcmap] = imread('luca_caucci.jpeg');
    my_message = ['The program will calculate a few statistics (area, ', ...
        'total number of counts, min/max pixel values, and so on) for ', ...
        'each ROI that is ebabled. Values will be displayed as a table.'];
    uiwait(msgbox(my_message, 'Help', 'custom', icondata, iconcmap, 'modal'));
end
% Get the enabled ROIs
ROI_enabled = zeros(4, 1);
for ROI_index = 1:4
    ROI_enabled(ROI_index) = ~isempty(handles.ROI.points{ROI_index}) && ...
        get(handles.enable_ROI_checkboxes(ROI_index), 'Value') > 0;
end
num_enabled = sum(ROI_enabled);
if num_enabled > 0
    ROI_info = cell(num_enabled, 8);
    table_column_width = 100;
    table_width = size(ROI_info, 2) * table_column_width + 2;
    table_height = 150;
    fig_width = table_width + 2 * 25;
    fig_height = table_height + 2 * 25;
    screen_size = get(0, 'ScreenSize');
    % Create a figure, center it, and add a table to the figure
    my_fig = figure('Name', 'ROI Statistics', 'NumberTitle', 'off', 'MenuBar', 'none', 'ToolBar', 'none', 'Resize', 'off');
    set(my_fig, 'Position', [(screen_size(3) - fig_width) / 2, (screen_size(4) - fig_height) / 2, fig_width, fig_height]);
    ROI_info_table = uitable(my_fig, 'Position', [25, 25, table_width, table_height]);
    set(ROI_info_table, 'ColumnWidth', repmat({table_column_width}, 1, size(ROI_info, 2)), 'RowName', []);
    column_names = {'ROI Label', 'Num. Counts', 'Size [mm^2]', 'Median', 'Mean', 'Variance', 'Min', 'Max'};
    set(ROI_info_table, 'ColumnName', column_names);
    m = 1;
    text_column_width = 14;
    % Show a text table as well
    fprintf('\n');
    fprintf('+-');
    for col = 1:length(column_names)
        fprintf('%s-+', repmat('-', 1, text_column_width));
    end
    fprintf('\n');
    fprintf('| ');
    fprintf('%*s |', -text_column_width, column_names{1});
    for col = 2:length(column_names)
        fprintf('%*s |', text_column_width, column_names{col});
    end
    fprintf('\n');
    fprintf('+-');
    for col = 1:length(column_names)
        fprintf('%s-+', repmat('-', 1, text_column_width));
    end
    fprintf('\n');
    pixel_area = handles.pixel_width * handles.pixel_height;
    for ROI_index = 1:4
        if ROI_enabled(ROI_index)
            % Get an array with all the pixels that fall within an ROI
            ROI_pixels = double(get_ROI_pixels(handles.image, handles.ROI.points{ROI_index}));
            % Calculate some parameters with the pixels within the ROI
            ROI_info{m, 1} = get(handles.enable_ROI_edit_texts(ROI_index), 'String');
            ROI_info{m, 2} = sum(ROI_pixels);
            ROI_info{m, 3} = pixel_area * numel(ROI_pixels);
            ROI_info{m, 4} = median(ROI_pixels);
            ROI_info{m, 5} = mean(ROI_pixels);
            ROI_info{m, 6} = var(ROI_pixels);
            ROI_info{m, 7} = min(ROI_pixels);
            ROI_info{m, 8} = max(ROI_pixels);
            set(ROI_info_table, 'Data', ROI_info(1:m, :), 'FontName', 'FixedWidth', 'FontSize', 10);
            fprintf('| ');
            fprintf('%*s |', -text_column_width, ROI_info{m, 1});
            for col = 2:8
                fprintf('%*.2f |', text_column_width, ROI_info{m, col});
            end
            fprintf('\n');
            m = m + 1;
        end
    end
    fprintf('+-');
    for col = 1:length(column_names)
        fprintf('%s-+', repmat('-', 1, text_column_width));
    end
    fprintf('\n\n');
else
    msgbox('No ROI present or enabled!', 'Error', 'error', 'modal');
end


function ROI_pixels = get_ROI_pixels(img, points)
% For each line of pixels, calculate the intersections between the line of
% pixels and all the segments that make up the ROI. The intersection points
% and then sorted from left to right. If we assume that the first point of
% each line is outside the ROI, then the first intersection corresponds to
% a transition from "outside ROI" to "inside ROI" while he next intersection
% corresponds to a transition from "inside ROI" to "outside ROI". The points
% between these two transitions are inside the ROI, and are therefore marked
% as such in a binary mask. At the end, the binary mask is used to get the
% list of pixels inside the ROI.
num_points = size(points, 1);
num_segments = num_points - 1;
if num_segments > 2
    mask = false(size(img));
    num_rows = size(img, 1);
    for y = 1:num_rows
        x_intersects = zeros(num_segments, 1);
        num_pos = 0;
        for m = 1:num_segments
            u_0 = points(m + 0, :);
            u_1 = points(m + 1, :);
            if abs(u_1(2) - u_0(2)) > 1e-6
                t = (y - u_0(2)) / (u_1(2) - u_0(2));
                if (0 <= t) && (t <= 1)
                    num_pos = num_pos + 1;
                    x = u_0(1) + t * (u_1(1) - u_0(1));
                    x_intersects(num_pos) = x;
                end
            end
        end
        tmp = sort(x_intersects(1:num_pos));
        for m = 1:2:(num_pos - 1)
            mask(y, round(tmp(m)):round(tmp(m + 1))) = true;
        end
    end
    ROI_pixels = img(mask);
else
    ROI_pixels = [];
end


% --- Executes on button press in save_ROIs_button.
function save_ROIs_button_Callback(~, ~, handles)
% hObject    handle to save_ROIs_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.help_needed_checkbox, 'Value') == 1
    [icondata, iconcmap] = imread('luca_caucci.jpeg');
    my_message = ['You will be asked to enter the name of the file ', ...
        'where you want to save all the ROIs. The ROI file is just a ', ...
        'text file, which you can look at and modify at your own risk.'];
    uiwait(msgbox(my_message, 'Help', 'custom', icondata, iconcmap, 'modal'));
end
ROI_present = zeros(4, 1);
for ROI_index = 1:4
    ROI_present(ROI_index) = ~isempty(handles.ROI.points{ROI_index});
end
num_ROIs = sum(ROI_present);
if num_ROIs == 0
    error('No ROIs have been entered or loaded!');
end
[file, path] = uiputfile('*.roi', 'Save ROI(s) to file');
if ~isequal(file, 0)
    filename = fullfile(path, file);
    fid = fopen(filename, 'wt', 'ieee-le');
    if fid ~= -1
        fprintf(fid, '%d\n', num_ROIs);
        for ROI_index = 1:4
            if ROI_present(ROI_index)
                fprintf(fid, '%d\n', ROI_index);
                label = get(handles.enable_ROI_edit_texts(ROI_index), 'String');
                fprintf(fid, '%s\n', label);
                points = handles.ROI.points{ROI_index};
                fprintf(fid, '%d\n', size(points, 1));
                for m = 1:size(points, 1)
                    fprintf(fid, '%.8f %.8f\n', points(m, 1), points(m, 2));
                end
            end
        end
        fclose(fid);
    else
        error('Cannot open file %s!', filename);
    end
end


% --- Executes on button press in load_ROIs_button.
function load_ROIs_button_Callback(hObject, ~, handles)
% hObject    handle to load_ROIs_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.help_needed_checkbox, 'Value') == 1
    [icondata, iconcmap] = imread('luca_caucci.jpeg');
    my_message = ['You will be asked to enter the name of the file that ', ...
        'contains ROIs (and their labels) to load. All the ROIs will be enabled.'];
    uiwait(msgbox(my_message, 'Help', 'custom', icondata, iconcmap, 'modal'));
end
ROI_present = zeros(4, 1);
for ROI_index = 1:4
    ROI_present(ROI_index) = ~isempty(handles.ROI.points{ROI_index});
end
if any(ROI_present) && ~isempty(handles.image)
    message = ['An image and valid ROI(s) have already been entered/loaded. You ', ...
        'will lose these ROI(s) if you open an ROI file. Do you want to continue?'];
    answer = questdlg(message, 'ROI Present', 'Continue', 'Cancel', 'Continue');
else
    answer = 'Continue';
end
if strcmp(answer, 'Continue')
    [file, path] = uigetfile('*.roi', 'Select file to load ROI(s)');
    if ~isequal(file, 0)
        for ROI_index = 1:4
            handles.ROI.points{ROI_index} = [];
            set(handles.enable_ROI_checkboxes(ROI_index), 'Value', 0, 'Enable', 'off');
            set(handles.enable_ROI_edit_texts(ROI_index), 'String', sprintf('ROI %d', ROI_index), 'Enable', 'off');
        end
        filename = fullfile(path, file);
        fid = fopen(filename, 'rt', 'ieee-le');
        if fid ~= -1
            num_ROIs = fscanf(fid, '%d\n', 1);
            for index = 1:num_ROIs
                ROI_index = fscanf(fid, '%d\n', 1);
                label = fgetl(fid);
                set(handles.enable_ROI_checkboxes(ROI_index), 'Value', 1, 'Enable', 'on');
                set(handles.enable_ROI_edit_texts(ROI_index), 'String', label, 'Enable', 'on');
                num_points = fscanf(fid, '%d\n', 1);
                points = zeros(num_points, 2);
                for m = 1:num_points
                    points(m, :) = fscanf(fid, '%f %f\n', 2);
                end
                % Make sure that the ROI is closed
                if any(points(1, :) ~= points(end, :))
                    handles.ROI.points{ROI_index} = [points; points(1, :)];
                else
                    handles.ROI.points{ROI_index} = points;
                end
            end
            fclose(fid);
        else
            error('Cannot open file %s!', filename);
        end
    end
end
handles = update_image(handles, [], false);
guidata(hObject, handles);
update_UI_controls(handles);


% --- Executes on button press in help_needed_checkbox.
function help_needed_checkbox_Callback(hObject, ~, handles)
% hObject    handle to help_needed_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of help_needed_checkbox
if get(handles.help_needed_checkbox, 'Value') == 1
    [icondata, iconcmap] = imread('luca_caucci.jpeg');
    my_message = ['Hi, I''m Luca, and I''m here to help you.  As long as the ', ...
        'checkbox you just clicked on remains checked, a short message ', ...
        'telling you what to do will pop up every time you push on a button. ', ...
        'Happy working!'];
    msgbox(my_message, 'Help', 'custom', icondata, iconcmap, 'modal');
end
guidata(hObject, handles);


% --- Executes on button press in move_ROI_point_button.
function move_ROI_point_button_Callback(hObject, ~, handles)
% hObject    handle to move_ROI_point_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disable_all_UI_controls(handles);
if get(handles.help_needed_checkbox, 'Value') == 1
    [icondata, iconcmap] = imread('luca_caucci.jpeg');
    my_message = ['Click near the ROI point you want to move. The ', ...
        'segments affected by the point position will be colored ', ...
        'blue. Then, click on the new position for the point.'];
    uiwait(msgbox(my_message, 'Help', 'custom', icondata, iconcmap, 'modal'));
end
% Get the enabled ROIs
ROI_enabled = zeros(4, 1);
for ROI_index = 1:4
    ROI_enabled(ROI_index) = ~isempty(handles.ROI.points{ROI_index}) && ...
        get(handles.enable_ROI_checkboxes(ROI_index), 'Value') > 0;
end
if ~any(ROI_enabled)
    msgbox('At least one ROI must be enabled!', 'Error', 'error', 'modal');
else
    axis_x_limits = get(handles.axes_image, 'XLim');
    axis_y_limits = get(handles.axes_image, 'YLim');
    old_pointer = get(handles.ROI_act_figure, 'Pointer');
    set(handles.ROI_act_figure, 'Pointer', 'crosshair');
    drawnow;
    num_entered = 0;
    while num_entered < 1
        valid_point = false;
        while ~valid_point
            key = waitforbuttonpress;
            while key ~= 0
                key = waitforbuttonpress;
            end
            tmp_point = get(handles.axes_image, 'CurrentPoint');
            clicked_point = tmp_point(1, 1:2);
            valid_point = within_limits(clicked_point, axis_x_limits, axis_y_limits);
        end
        num_entered = num_entered + 1;
    end
    [ROI_index_found, point_index] = find_closest_ROI_point(handles.ROI.points, ROI_enabled, clicked_point);
    points = handles.ROI.points{ROI_index_found};
    ROI_label = handles.ROI.label_handles(ROI_index_found);
    set(handles.ROI.line_handles(ROI_index_found), 'Visible', 'off');
    line_color = handles.ROI_line_colors{ROI_index_found};
    if point_index(1) == 1
        % Recall that the first and the last point in the list are the same; a
        % special case is when the point being moved is the first one of the list
        text_pos = [(clicked_point(1) + points(2, 1)) / 2, (clicked_point(2) + points(2, 2)) / 2];
        text_angle = rad2deg(atan((clicked_point(2) - points(2, 2)) / (clicked_point(1) - points(2, 1))));
        set(ROI_label, 'Color', line_color, 'Position', text_pos, 'Rotation', text_angle);
        ROI_line = line([points(end - 1, 1), clicked_point(1), points(2, 1)], ...
            [points(end - 1, 2), clicked_point(2), points(2, 2)], ...
            'Color', line_color, 'LineStyle', '--', 'LineWidth', 1);
        line(points(2:(end - 1), 1), points(2:(end - 1), 2), ...
            'Color', line_color, 'LineStyle', '-', 'LineWidth', 1);
    else
        if point_index(1) == 2
            text_pos = [(points(1, 1) + clicked_point(1)) / 2, (points(1, 2) + clicked_point(2)) / 2];
            text_angle = rad2deg(atan((points(1, 2) - clicked_point(2)) / (points(1, 1) - clicked_point(1))));
            set(ROI_label, 'Color', line_color, 'Position', text_pos, 'Rotation', text_angle);
            ROI_line = line([points(1, 1), clicked_point(1), points(3, 1)], ...
                [points(1, 2), clicked_point(2), points(3, 2)], ...
                'Color', line_color, 'LineStyle', '--', 'LineWidth', 1);
            line(points(3:end, 1), points(3:end, 2), ...
                'Color', line_color, 'LineStyle', '-', 'LineWidth', 1);
        else
            ROI_line = line([points(point_index(1) - 1, 1), clicked_point(1), points(point_index(1) + 1, 1)], ...
                [points(point_index(1) - 1, 2), clicked_point(2), points(point_index(1) + 1, 2)], ...
                'Color', line_color, 'LineStyle', '--', 'LineWidth', 1);
            line([points((point_index(1) + 1):end, 1); points(1:(point_index(1) - 1), 1)], ...
                [points((point_index(1) + 1):end, 2); points(1:(point_index(1) - 1), 2)], ...
                'Color', line_color, 'LineStyle', '-', 'LineWidth', 1);
        end
    end
    % Set a "dummy" function so that CurrentPoint is constantly updated
    set(handles.ROI_act_figure, 'WindowButtonMotionFcn', @(o, e) []);
    mouse_listener = addlistener(handles.ROI_act_figure, 'WindowMouseMotion', ...
        @(o, e) move_ROI_point(o, e, ROI_line, ROI_label, points, point_index(1), handles));
    num_entered = 0;
    while num_entered < 1
        valid_point = false;
        while ~valid_point
            key = waitforbuttonpress;
            while key ~= 0
                key = waitforbuttonpress;
            end
            tmp_point = get(handles.axes_image, 'CurrentPoint');
            clicked_point = tmp_point(1, 1:2);
            valid_point = within_limits(clicked_point, axis_x_limits, axis_y_limits);
        end
        num_entered = num_entered + 1;
    end
    for ROI_index = 1:length(point_index)
        points(point_index(ROI_index), :) = clicked_point;
    end
    set(handles.ROI_act_figure, 'Pointer', old_pointer);
    drawnow;
    set(handles.ROI_act_figure, 'WindowButtonMotionFcn', []);
    delete(mouse_listener);
    if is_self_intersecting(points)
        uiwait(msgbox('The new ROI would be self-intersecting!', 'Error', 'error', 'modal'));
    else
        handles.ROI.points{ROI_index_found} = points;
    end
end
handles = update_image(handles, [], false);
guidata(hObject, handles);
update_UI_controls(handles);


function move_ROI_point(~, ~, ROI_line, ROI_label, points, point_index, handles)
axis_x_limits = get(handles.axes_image, 'XLim');
axis_y_limits = get(handles.axes_image, 'YLim');
tmp_point = get(handles.axes_image, 'CurrentPoint');
point = tmp_point(1, 1:2);
if ~within_limits(point, axis_x_limits, axis_y_limits)
    point = force_within_limits(point, axis_x_limits, axis_y_limits);
end
if point_index == 1
    new_segments_x = [points(end - 1, 1), point(1), points(2, 1)];
    new_segments_y = [points(end - 1, 2), point(2), points(2, 2)];
else
    new_segments_x = [points(point_index - 1, 1), point(1), points(point_index + 1, 1)];
    new_segments_y = [points(point_index - 1, 2), point(2), points(point_index + 1, 2)];
end
set(ROI_line, 'XData', new_segments_x, 'YData', new_segments_y);
if point_index == 1
    text_pos = [(point(1) + points(2, 1)) / 2, (point(2) + points(2, 2)) / 2];
    text_angle = rad2deg(atan((point(2) - points(2, 2)) / (point(1) - points(2, 1))));
    set(ROI_label, 'Position', text_pos, 'Rotation', text_angle);
end
if point_index == 2
    text_pos = [(points(1, 1) + point(1)) / 2, (points(1, 2) + point(2)) / 2];
    text_angle = rad2deg(atan((points(1, 2) - point(2)) / (points(1, 1) - point(1))));
    set(ROI_label, 'Position', text_pos, 'Rotation', text_angle);
end


function [ROI_index_found, point_index] = find_closest_ROI_point(ROI_points, ROI_enabled, point)
ROI_index_found = [];
point_index = [];
min_dist_sq = +Inf;
for ROI_index = 1:4
    if ROI_enabled(ROI_index)
        points = ROI_points{ROI_index};
        dist_sq = zeros(size(points, 1), 1);
        for m = 1:size(points, 1)
            tmp = points(m, :) - point;
            dist_sq(m) = dot(tmp, tmp);
        end
        if min_dist_sq > min(dist_sq)
            ROI_index_found = ROI_index;
            min_dist_sq = min(dist_sq);
            point_index = find(dist_sq == min_dist_sq);
        end
    end
end


% --- Executes on button press in add_ROI_point_button.
function add_ROI_point_button_Callback(hObject, ~, handles)
% hObject    handle to add_ROI_point_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disable_all_UI_controls(handles);
if get(handles.help_needed_checkbox, 'Value') == 1
    [icondata, iconcmap] = imread('luca_caucci.jpeg');
    my_message = ['Click near the segment you want to break with an extra ', ...
        'point. The segment will get colored in blue.  Then click on the ', ...
        'location where you want the extra point to be located.'];
    uiwait(msgbox(my_message, 'Help', 'custom', icondata, iconcmap, 'modal'));
end
% Get the enabled ROIs
ROI_enabled = zeros(4, 1);
for ROI_index = 1:4
    ROI_enabled(ROI_index) = ~isempty(handles.ROI.points{ROI_index}) && ...
        get(handles.enable_ROI_checkboxes(ROI_index), 'Value') > 0;
end
if ~any(ROI_enabled)
    msgbox('At least one ROI must be enabled!', 'Error', 'error', 'modal');
else
    axis_x_limits = get(handles.axes_image, 'XLim');
    axis_y_limits = get(handles.axes_image, 'YLim');
    old_pointer = get(handles.ROI_act_figure, 'Pointer');
    set(handles.ROI_act_figure, 'Pointer', 'crosshair');
    drawnow;
    num_entered = 0;
    while num_entered < 1
        valid_point = false;
        while ~valid_point
            key = waitforbuttonpress;
            while key ~= 0
                key = waitforbuttonpress;
            end
            tmp_point = get(handles.axes_image, 'CurrentPoint');
            clicked_point = tmp_point(1, 1:2);
            valid_point = within_limits(clicked_point, axis_x_limits, axis_y_limits);
        end
        num_entered = num_entered + 1;
    end
    [ROI_index_found, segment_index] = find_closest_ROI_segment(handles.ROI.points, ROI_enabled, clicked_point);
    points = handles.ROI.points{ROI_index_found};
    ROI_label = handles.ROI.label_handles(ROI_index_found);
    line_color = handles.ROI_line_colors{ROI_index_found};
    if segment_index(1) == 1
        text_pos = [(points(1, 1) + clicked_point(1)) / 2, (points(1, 2) + clicked_point(2)) / 2];
        text_angle = rad2deg(atan((points(1, 2) - clicked_point(2)) / (points(1, 1) - clicked_point(1))));
        set(ROI_label, 'Position', text_pos, 'Rotation', text_angle);
    end
    ROI_line = line([points(segment_index(1), 1), clicked_point(1), points(segment_index(1) + 1, 1)], ...
        [points(segment_index(1), 2), clicked_point(2), points(segment_index(1) + 1, 2)], ...
        'Color', line_color, 'LineStyle', '--', 'LineWidth', 1);
    set(handles.ROI.line_handles(ROI_index_found), 'Visible', 'off');
    line(points(1:segment_index(1), 1), points(1:segment_index(1), 2), ...
        'Color', line_color, 'LineStyle', '-', 'LineWidth', 1);
    line(points((segment_index(1) + 1):end, 1), points((segment_index(1) + 1):end, 2), ...
        'Color', line_color, 'LineStyle', '-', 'LineWidth', 1);
    % Set a "dummy" function so that CurrentPoint is constantly updated
    set(handles.ROI_act_figure, 'WindowButtonMotionFcn', @(o, e) []);
    mouse_listener = addlistener(handles.ROI_act_figure, 'WindowMouseMotion', ...
        @(o, e) move_ROI_segments(o, e, ROI_line, ROI_label, points, segment_index(1), handles));
    num_entered = 0;
    while num_entered < 1
        valid_point = false;
        while ~valid_point
            key = waitforbuttonpress;
            while key ~= 0
                key = waitforbuttonpress;
            end
            tmp_point = get(handles.axes_image, 'CurrentPoint');
            clicked_point = tmp_point(1, 1:2);
            valid_point = within_limits(clicked_point, axis_x_limits, axis_y_limits);
        end
        num_entered = num_entered + 1;
    end
    points((segment_index(1) + 2):(end + 1), :) = points((segment_index(1) + 1):end, :);
    points(segment_index(1) + 1, :) = clicked_point;
    set(handles.ROI_act_figure, 'Pointer', old_pointer);
    drawnow;
    set(handles.ROI_act_figure, 'WindowButtonMotionFcn', []);
    delete(mouse_listener);
    if is_self_intersecting(points)
        uiwait(msgbox('The new ROI would be self-intersecting!', 'Error', 'error', 'modal'));
    else
        handles.ROI.points{ROI_index_found} = points;
    end
end
handles = update_image(handles, [], false);
guidata(hObject, handles);
update_UI_controls(handles);


function move_ROI_segments(~, ~, ROI_line, ROI_label, points, segment_index, handles)
axis_x_limits = get(handles.axes_image, 'XLim');
axis_y_limits = get(handles.axes_image, 'YLim');
tmp_point = get(handles.axes_image, 'CurrentPoint');
point = tmp_point(1, 1:2);
if ~within_limits(point, axis_x_limits, axis_y_limits)
    point = force_within_limits(point, axis_x_limits, axis_y_limits);
end
new_segments_x = [points(segment_index, 1), point(1), points(segment_index + 1, 1)];
new_segments_y = [points(segment_index, 2), point(2), points(segment_index + 1, 2)];
set(ROI_line, 'XData', new_segments_x, 'YData', new_segments_y);
if segment_index == 1
    text_pos = [(points(1, 1) + point(1)) / 2, (points(1, 2) + point(2)) / 2];
    text_angle = rad2deg(atan((points(1, 2) - point(2)) / (points(1, 1) - point(1))));
    set(ROI_label, 'Position', text_pos, 'Rotation', text_angle);
end


function [ROI_index_found, segment_index] = find_closest_ROI_segment(ROI_points, ROI_enabled, point)
% For each ROI, calculate the minimun distance between each segment of
% the ROI and a given point P. The segment from P_1 to P_2 is defined as
% P(u) = u P_1 + (1 - u) P_2, for 0 <= u <= 1. The closest point is found
% by first finding the value u_0 that minimizes | P(u_0) - P |^2. The value
% u_0 is considered so long as it satisfies 0 <= u_0 <= 1. Because we are,
% essentially, minimizing f(u) for 0 <= u <= 1 by solving f'(u) = 0, we also
% need to check the values f(0) and f(1).
ROI_index_found = [];
segment_index = [];
min_dist_sq = +Inf;
for ROI_index = 1:4
    if ROI_enabled(ROI_index)
        points = ROI_points{ROI_index};
        dist_sq = zeros(size(points, 1) - 1, 1);
        for m = 1:(size(points, 1) - 1)
            p_1 = points(m + 0, :);
            p_2 = points(m + 1, :);
            ell = dot(p_1 - point, p_1 - p_2) / dot(p_1 - p_2, p_1 - p_2);
            if (0 <= ell) && (ell <= 1)
                vect = point - (p_1 + ell * (p_2 - p_1));
                dist_sq(m) = dot(vect, vect);
            else
                dist_sq(m) = +Inf;
            end
            vect = point - p_1;
            dist_sq(m) = min(dist_sq(m), dot(vect, vect));
            vect = point - p_2;
            dist_sq(m) = min(dist_sq(m), dot(vect, vect));
        end
        if min_dist_sq > min(dist_sq)
            ROI_index_found = ROI_index;
            min_dist_sq = min(dist_sq);
            segment_index = find(dist_sq == min_dist_sq);
        end
    end
end


% --- Executes on button press in save_image_ROIs_button.
function save_image_ROIs_button_Callback(~, ~, handles)
% hObject    handle to save_image_ROIs_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.help_needed_checkbox, 'Value') == 1
    [icondata, iconcmap] = imread('luca_caucci.jpeg');
    my_message = ['You will be asked to enter the name of the file where ', ...
        'you want to save the current image, along with any active ROIs ', ...
        '(and their labels). The image will be saved in PNG format.'];
    uiwait(msgbox(my_message, 'Help', 'custom', icondata, iconcmap, 'modal'));
end
[file, path] = uiputfile('*.png', 'Select file for save image with ROI(s)');
if ~isequal(file, 0)
    image_fig = figure('Position', [0, 0, size(handles.image) / 2]);
    set(image_fig, 'MenuBar', 'none', 'ToolBar', 'none', 'Visible', 'off');
    new_axes = axes;
    outer_pos = get(new_axes, 'OuterPosition');
    tight_inset = get(new_axes, 'TightInset');
    min_margin = min(tight_inset);
    left = outer_pos(1) + min_margin;
    bottom = outer_pos(2) + min_margin;
    axes_width = outer_pos(3) - 2 * min_margin;
    axes_height = outer_pos(4) - 2 * min_margin;
    update_image(handles, new_axes, false);
    set(new_axes, 'Position', [left, bottom, axes_width, axes_height]);
    set(new_axes, 'Box', 'off', 'Visible', 'off');
    drawnow;
    filename = fullfile(path, file);
    print(image_fig, filename, '-dpng', '-painters');
    close(image_fig);
end


% --- Executes on button press in ROI_1_checkbox.
function ROI_1_checkbox_Callback(hObject, ~, handles)
% hObject    handle to ROI_1_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ROI_1_checkbox
handles = update_image(handles, [], false);
guidata(hObject, handles);


function ROI_1_edit_text_Callback(hObject, ~, handles)
% hObject    handle to ROI_1_edit_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ROI_1_edit_text as text
%        str2double(get(hObject,'String')) returns contents of ROI_1_edit_text as a double
handles = update_image(handles, [], false);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ROI_1_edit_text_CreateFcn(hObject, ~, ~)
% hObject    handle to ROI_1_edit_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ROI_2_checkbox.
function ROI_2_checkbox_Callback(hObject, ~, handles)
% hObject    handle to ROI_2_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ROI_2_checkbox
handles = update_image(handles, [], false);
guidata(hObject, handles);


function ROI_2_edit_text_Callback(hObject, ~, handles)
% hObject    handle to ROI_2_edit_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ROI_2_edit_text as text
%        str2double(get(hObject,'String')) returns contents of ROI_2_edit_text as a double
handles = update_image(handles, [], false);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ROI_2_edit_text_CreateFcn(hObject, ~, ~)
% hObject    handle to ROI_2_edit_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ROI_3_checkbox.
function ROI_3_checkbox_Callback(hObject, ~, handles)
% hObject    handle to ROI_3_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ROI_3_checkbox
handles = update_image(handles, [], false);
guidata(hObject, handles);


function ROI_3_edit_text_Callback(hObject, ~, handles)
% hObject    handle to ROI_3_edit_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ROI_3_edit_text as text
%        str2double(get(hObject,'String')) returns contents of ROI_3_edit_text as a double
handles = update_image(handles, [], false);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ROI_3_edit_text_CreateFcn(hObject, ~, ~)
% hObject    handle to ROI_3_edit_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ROI_4_checkbox.
function ROI_4_checkbox_Callback(hObject, ~, handles)
% hObject    handle to ROI_4_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ROI_4_checkbox
handles = update_image(handles, [], false);
guidata(hObject, handles);


function ROI_4_edit_text_Callback(hObject, ~, handles)
% hObject    handle to ROI_4_edit_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ROI_4_edit_text as text
%        str2double(get(hObject,'String')) returns contents of ROI_4_edit_text as a double
handles = update_image(handles, [], false);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ROI_4_edit_text_CreateFcn(hObject, ~, ~)
% hObject    handle to ROI_4_edit_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in move_ROI_button.
function move_ROI_button_Callback(hObject, ~, handles)
% hObject    handle to move_ROI_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disable_all_UI_controls(handles);
if get(handles.help_needed_checkbox, 'Value') == 1
    [icondata, iconcmap] = imread('luca_caucci.jpeg');
    my_message = ['Click near any segment of the ROI you want to move. ', ...
        'The selected ROI (and label) will get colored blue. Then move ', ...
        'the mouse and, when the ROI is where you want it, click again.'];
    uiwait(msgbox(my_message, 'Help', 'custom', icondata, iconcmap, 'modal'));
end
ROI_enabled = zeros(4, 1);
for ROI_index = 1:4
    ROI_enabled(ROI_index) = ~isempty(handles.ROI.points{ROI_index}) && ...
        get(handles.enable_ROI_checkboxes(ROI_index), 'Value') > 0;
end
if ~any(ROI_enabled)
    msgbox('At least one ROI must be enabled!', 'Error', 'error', 'modal');
else
    axis_x_limits = get(handles.axes_image, 'XLim');
    axis_y_limits = get(handles.axes_image, 'YLim');
    old_pointer = get(handles.ROI_act_figure, 'Pointer');
    set(handles.ROI_act_figure, 'Pointer', 'crosshair');
    drawnow;
    num_entered = 0;
    while num_entered < 1
        valid_point = false;
        while ~valid_point
            key = waitforbuttonpress;
            while key ~= 0
                key = waitforbuttonpress;
            end
            tmp_point = get(handles.axes_image, 'CurrentPoint');
            point_1 = tmp_point(1, 1:2);
            valid_point = within_limits(point_1, axis_x_limits, axis_y_limits);
        end
        num_entered = num_entered + 1;
    end
    [ROI_index_found, ~] = find_closest_ROI_segment(handles.ROI.points, ROI_enabled, point_1);
    old_points = handles.ROI.points{ROI_index_found};
    ROI_line = handles.ROI.line_handles(ROI_index_found);
    ROI_label = handles.ROI.label_handles(ROI_index_found);
    set(ROI_line, 'LineStyle', '--');
    % Set a "dummy" function so that CurrentPoint is constantly updated
    set(handles.ROI_act_figure, 'WindowButtonMotionFcn', @(o, e) []);
    mouse_listener = addlistener(handles.ROI_act_figure, 'WindowMouseMotion', ...
        @(o, e) move_ROI(o, e, ROI_line, ROI_label, point_1, old_points, handles));
    num_entered = 0;
    while num_entered < 1
        valid_point = false;
        while ~valid_point
            key = waitforbuttonpress;
            while key ~= 0
                key = waitforbuttonpress;
            end
            tmp_point = get(handles.axes_image, 'CurrentPoint');
            point_2 = tmp_point(1, 1:2);
            valid_point = within_limits(point_2, axis_x_limits, axis_y_limits);
        end
        num_entered = num_entered + 1;
    end
    shift = point_2 - point_1;
    new_points(:, 1) = old_points(:, 1) + shift(1);
    new_points(:, 2) = old_points(:, 2) + shift(2);
    if ~all(within_limits(new_points, axis_x_limits, axis_y_limits))
        new_points = force_within_limits(new_points, axis_x_limits, axis_y_limits);
    end
    handles.ROI.points{ROI_index_found} = new_points;
    handles = update_image(handles, [], false);
    set(handles.ROI_act_figure, 'Pointer', old_pointer);
    drawnow;
    set(handles.ROI_act_figure, 'WindowButtonMotionFcn', []);
    delete(mouse_listener);
end
handles = update_image(handles, [], false);
guidata(hObject, handles);
update_UI_controls(handles);


function within = within_limits(points, x_limits, y_limits)
within_x = (x_limits(1) <= points(:, 1)) & (points(:, 1) <= x_limits(2));
within_y = (y_limits(1) <= points(:, 2)) & (points(:, 2) <= y_limits(2));
within = within_x & within_y;


function points = force_within_limits(points, x_limits, y_limits)
if min(points(:, 1)) < x_limits(1)
    delta = min(points(:, 1)) - x_limits(1);
    points(:, 1) = points(:, 1) - delta;
end
if min(points(:, 2)) < y_limits(1)
    delta = min(points(:, 2)) - y_limits(1);
    points(:, 2) = points(:, 2) - delta;
end
if max(points(:, 1)) > x_limits(2)
    delta = max(points(:, 1)) - x_limits(2);
    points(:, 1) = points(:, 1) - delta;
end
if max(points(:, 2)) > y_limits(2)
    delta = max(points(:, 2)) - y_limits(2);
    points(:, 2) = points(:, 2) - delta;
end


function move_ROI(~, ~, ROI_line, ROI_label, old_position, old_points, handles)
axis_x_limits = get(handles.axes_image, 'XLim');
axis_y_limits = get(handles.axes_image, 'YLim');
tmp_point = get(handles.axes_image, 'CurrentPoint');
new_position = tmp_point(1, 1:2);
shift = new_position - old_position;
new_points = zeros(size(old_points));
new_points(:, 1) = old_points(:, 1) + shift(1);
new_points(:, 2) = old_points(:, 2) + shift(2);
if ~all(within_limits(new_points, axis_x_limits, axis_y_limits))
    new_points = force_within_limits(new_points, axis_x_limits, axis_y_limits);
end
text_pos = [(new_points(1, 1) + new_points(2, 1)) / 2, (new_points(1, 2) + new_points(2, 2)) / 2];
text_angle = rad2deg(atan((new_points(1, 2) - new_points(2, 2)) / (new_points(1, 1) - new_points(2, 1))));
set(ROI_label, 'Position', text_pos, 'Rotation', text_angle);
set(ROI_line, 'XData', new_points(:, 1), 'YData', new_points(:, 2));


% --- Executes on slider movement.
function x_min_slider_Callback(hObject, ~, handles)
% hObject    handle to x_min_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles = update_image(handles, [], false);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function x_min_slider_CreateFcn(hObject, ~, ~)
% hObject    handle to x_min_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function x_max_slider_Callback(hObject, ~, handles)
% hObject    handle to x_max_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles = update_image(handles, [], false);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function x_max_slider_CreateFcn(hObject, ~, ~)
% hObject    handle to x_max_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function y_max_slider_Callback(hObject, ~, handles)
% hObject    handle to y_max_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles = update_image(handles, [], false);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function y_max_slider_CreateFcn(hObject, ~, ~)
% hObject    handle to y_max_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function y_min_slider_Callback(hObject, ~, handles)
% hObject    handle to y_min_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles = update_image(handles, [], false);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function y_min_slider_CreateFcn(hObject, ~, ~)
% hObject    handle to y_min_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in delete_ROI_button.
function delete_ROI_button_Callback(hObject, ~, handles)
% hObject    handle to delete_ROI_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disable_all_UI_controls(handles);
if get(handles.help_needed_checkbox, 'Value') == 1
    [icondata, iconcmap] = imread('luca_caucci.jpeg');
    my_message = ['Click near the ROI you want to delete. The ', ...
        'selected ROI will be marked with dashed segments. A dialog ', ...
        'box will ask for confirmation before deleting the ROI.'];
    uiwait(msgbox(my_message, 'Help', 'custom', icondata, iconcmap, 'modal'));
end
ROI_enabled = zeros(4, 1);
for ROI_index = 1:4
    ROI_enabled(ROI_index) = ~isempty(handles.ROI.points{ROI_index}) && ...
        get(handles.enable_ROI_checkboxes(ROI_index), 'Value') > 0;
end
if ~any(ROI_enabled)
    msgbox('At least one ROI must be enabled!', 'Error', 'error', 'modal');
else
    axis_x_limits = get(handles.axes_image, 'XLim');
    axis_y_limits = get(handles.axes_image, 'YLim');
    old_pointer = get(handles.ROI_act_figure, 'Pointer');
    set(handles.ROI_act_figure, 'Pointer', 'crosshair');
    drawnow;
    num_entered = 0;
    while num_entered < 1
        valid_point = false;
        while ~valid_point
            key = waitforbuttonpress;
            while key ~= 0
                key = waitforbuttonpress;
            end
            tmp_point = get(handles.axes_image, 'CurrentPoint');
            clicked_point = tmp_point(1, 1:2);
            valid_point = within_limits(clicked_point, axis_x_limits, axis_y_limits);
        end
        num_entered = num_entered + 1;
    end
    [ROI_index_found, ~] = find_closest_ROI_segment(handles.ROI.points, ROI_enabled, clicked_point);
    set(handles.ROI.line_handles(ROI_index_found), 'LineStyle', '--');
    drawnow;
    answer = questdlg('Are you sure you want to detele this ROI?', ...
        'Delete ROI?', 'Yes', 'No', 'No');
    if strcmp(answer, 'Yes')
        handles.ROI.points{ROI_index_found} = [];
        label = sprintf('ROI %d', ROI_index_found);
        set(handles.enable_ROI_edit_texts(ROI_index_found), 'String', label, 'Enable', 'off');
        set(handles.enable_ROI_checkboxes(ROI_index_found), 'Value', 0, 'Enable', 'off');
    else
        set(handles.ROI.line_handles(ROI_index_found), 'LineStyle', '-');
    end
    set(handles.ROI_act_figure, 'Pointer', old_pointer);
    drawnow;
end
handles = update_image(handles, [], false);
guidata(hObject, handles);
update_UI_controls(handles);


function disable_all_UI_controls(handles)
% This function is used to disable all the buttons so that the user will
% not push a button when a click on the image is required instead. It
% avoids having to deal with maintaining the status coherent as the
% callback functions are called.
set(handles.min_threshold_slider, 'Enable', 'off');
set(handles.max_threshold_slider, 'Enable', 'off');
set(handles.x_min_slider, 'Enable', 'off');
set(handles.x_max_slider, 'Enable', 'off');
set(handles.y_min_slider, 'Enable', 'off');
set(handles.y_max_slider, 'Enable', 'off');
set(handles.open_new_image_button, 'Enable', 'off');
set(handles.save_image_ROIs_button, 'Enable', 'off');
set(handles.get_ROI_statistics_button, 'Enable', 'off');
set(handles.enter_ROI_button, 'Enable', 'off');
set(handles.delete_ROI_button, 'Enable', 'off');
set(handles.load_ROI_button, 'Enable', 'off');
set(handles.save_ROI_button, 'Enable', 'off');
set(handles.move_ROI_button, 'Enable', 'off');
set(handles.move_ROI_point_button, 'Enable', 'off');
set(handles.add_ROI_point_button, 'Enable', 'off');
for ROI_index = 1:4
    set(handles.enable_ROI_checkboxes(ROI_index), 'Enable', 'off');
    set(handles.enable_ROI_edit_texts(ROI_index), 'Enable', 'off');
end


function update_UI_controls(handles)
% Enable/disable the buttons based on the status of the image (present
% or not) and the number of ROI that have been entered or loaded
set(handles.open_new_image_button, 'Enable', 'on');
ROI_present = zeros(4, 1);
for ROI_index = 1:4
    ROI_present(ROI_index) = ~isempty(handles.ROI.points{ROI_index});
end
if ~isempty(handles.image)
    set(handles.save_image_ROIs_button, 'Enable', 'on');
    set(handles.load_ROI_button, 'Enable', 'on');
    if any(ROI_present)
        set(handles.get_ROI_statistics_button, 'Enable', 'on');
        set(handles.delete_ROI_button, 'Enable', 'on');
        set(handles.save_ROI_button, 'Enable', 'on');
        set(handles.move_ROI_button, 'Enable', 'on');
        set(handles.move_ROI_point_button, 'Enable', 'on');
        set(handles.move_ROI_point_button, 'Enable', 'on');
        set(handles.add_ROI_point_button, 'Enable', 'on');
    else
        set(handles.get_ROI_statistics_button, 'Enable', 'off');
        set(handles.delete_ROI_button, 'Enable', 'off');
        set(handles.save_ROI_button, 'Enable', 'off');
        set(handles.move_ROI_button, 'Enable', 'off');
        set(handles.move_ROI_point_button, 'Enable', 'off');
        set(handles.move_ROI_point_button, 'Enable', 'off');
        set(handles.add_ROI_point_button, 'Enable', 'off');
    end
    if all(ROI_present)
        set(handles.enter_ROI_button, 'Enable', 'off');
    else
        set(handles.enter_ROI_button, 'Enable', 'on');
    end
else
    set(handles.save_image_ROIs_button, 'Enable', 'off');
    set(handles.get_ROI_statistics_button, 'Enable', 'off');
    set(handles.enter_ROI_button, 'Enable', 'off');
    set(handles.delete_ROI_button, 'Enable', 'off');
    set(handles.load_ROI_button, 'Enable', 'off');
    set(handles.save_ROI_button, 'Enable', 'off');
    set(handles.move_ROI_button, 'Enable', 'off');
    set(handles.move_ROI_point_button, 'Enable', 'off');
    set(handles.add_ROI_point_button, 'Enable', 'off');
end
for ROI_index = 1:4
    if ROI_present(ROI_index)
        set(handles.enable_ROI_checkboxes(ROI_index), 'Enable', 'on');
        set(handles.enable_ROI_edit_texts(ROI_index), 'Enable', 'on');
    else
        set(handles.enable_ROI_checkboxes(ROI_index), 'Enable', 'off');
        set(handles.enable_ROI_edit_texts(ROI_index), 'Enable', 'off');
    end
end
