function varargout = gui_trial(varargin)
% GUI_TRIAL MATLAB code for gui_trial.fig
%      GUI_TRIAL, by itself, creates a new GUI_TRIAL or raises the existing
%      singleton*.
%
%      H = GUI_TRIAL returns the handle to a new GUI_TRIAL or the handle to
%      the existing singleton*.
%
%      GUI_TRIAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_TRIAL.M with the given input arguments.
%
%      GUI_TRIAL('Property','Value',...) creates a new GUI_TRIAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_trial_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_trial_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_trial

% Last Modified by GUIDE v2.5 04-Jul-2019 23:09:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @gui_trial_OpeningFcn, ...
    'gui_OutputFcn',  @gui_trial_OutputFcn, ...
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


% --- Executes just before gui_trial is made visible.
function gui_trial_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_trial (see VARARGIN)

% % Create the data to plot.
% handles.peaks=peaks(35);
% handles.membrane=membrane;
% [x,y] = meshgrid(-8:.5:8);
% r = sqrt(x.^2+y.^2) + eps;
% sinc = sin(r)./r;
% handles.sinc = sinc;
% % Set the current data value.
% handles.current_data = handles.peaks;
% surf(handles.current_data)

handles.isManual = false;

% Choose default command line output for gui_trial
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_trial wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_trial_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename,filepath]=uigetfile('*.*','请选择文件'); %filename为文件名，filepath为文件路径
handles.im1 = imread(strcat(filepath,filename)); %读取图片文件
handles.I1 = rgb2gray(handles.im1);
% set(handles.axes3,'position',[120,6,size(handles.im1,1),size(handles.im1,2)]);
axes(handles.axes3)
imshow(handles.im1);

handles.points1 = detectHarrisFeatures(handles.I1);

guidata(hObject, handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename,filepath]=uigetfile('*.*','请选择文件'); %filename为文件名，filepath为文件路径
handles.im2 = imread(strcat(filepath,filename)); %读取图片文件
handles.I2 = rgb2gray(handles.im2);
axes(handles.axes1)
imshow(handles.im2);

handles.points2 = detectHarrisFeatures(handles.I2);

guidata(hObject, handles);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Display contour plot of the currently selected data.

if handles.isManual == true
    movingPoints = evalin('base','movingPoints');
    % assignin('caller','movingPoints',movingPoints);
    fixedPoints = evalin('base','fixedPoints');
    % assignin('caller','fixedPoints',fixedPoints);
    tform = fitgeotrans(movingPoints,fixedPoints,'projective');
else
    [f1,vpts1] = extractFeatures(handles.I1,handles.points1);
    [f2,vpts2] = extractFeatures(handles.I2,handles.points2);
    
    indexPairs = matchFeatures(f1,f2);
    matchedPoints1 = vpts1(indexPairs(:,1));
    matchedPoints2 = vpts2(indexPairs(:,2));
    
    tform = fitgeotrans(matchedPoints1.Location,matchedPoints2.Location,'projective');
end

im1_trans = imwarp(handles.im1,tform);
left_top = round(transformPointsForward(tform,[1 1]));
right_top = round(transformPointsForward(tform,[size(handles.im2,2) 1]));
left_bottom = round(transformPointsForward(tform,[1 size(handles.im2,1)]));
right_bottom = round(transformPointsForward(tform,[size(handles.im2,2) size(handles.im2,1)]));

if right_top(2) <= 0
    im1_trans_seg = [zeros(size(im1_trans,1)+right_top(2),min(left_top(1),left_bottom(1)),3) im1_trans(-right_top(2)+1:end,:,:)]; % if right_top(2) < 0
else
    im1_trans_seg_part = [zeros(size(im1_trans,1),min(left_top(1),left_bottom(1)),3) im1_trans];
    im1_trans_seg = [zeros(right_top(2),min(left_top(1),left_bottom(1))+size(im1_trans,2),3);im1_trans_seg_part];
end

im = im1_trans_seg(1:size(handles.im2,1),:,:);
im(:,1:size(handles.im2,2),:) = handles.im2;
im1_trans_seg_gray = rgb2gray(im1_trans_seg);

axes(handles.axes4)
imshow(im);

edge_left = min(left_top(1),left_bottom(1));
edge_right = size(handles.im2,2);
edge_width = edge_right-edge_left;

for row=1:size(im,1)
    for col=edge_left:edge_right
        if im1_trans_seg_gray(row,col) == 0
            weight = 1;
        else
            weight = (edge_width - (col - edge_left)) / edge_width;
        end
        
        im(row,col,:) = uint8(double(handles.im2(row,col,:))*weight + double(im1_trans_seg(row,col,:))*(1-weight));
    end
end

axes(handles.axes5)
imshow(im);


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

% Determine the selected data set.
str = get(hObject, 'String');
val = get(hObject,'Value');
handles.isManual = false;
% Set current data to the selected data set.
switch str{val}
    case 'Harris'
        % handles.isManual = false;
        handles.points1 = detectHarrisFeatures(handles.I1);
        handles.points2 = detectHarrisFeatures(handles.I2);
    case 'SURF'
        % handles.isManual = false;
        handles.points1 = detectSURFFeatures(handles.I1);
        handles.points2 = detectSURFFeatures(handles.I2);
    case 'FAST'
        % handles.isManual = false;
        handles.points1 = detectFASTFeatures(handles.I1);
        handles.points2 = detectFASTFeatures(handles.I2);
    case 'BRISK'
        % handles.isManual = false;
        handles.points1 = detectBRISKFeatures(handles.I1);
        handles.points2 = detectBRISKFeatures(handles.I2);
    case 'MSER'
        % handles.isManual = false;
        handles.points1 = detectMSERFeatures(handles.I1);
        handles.points2 = detectMSERFeatures(handles.I2);
    case 'MinEigen'
        % handles.isManual = false;
        handles.points1 = detectMinEigenFeatures(handles.I1);
        handles.points2 = detectMinEigenFeatures(handles.I2);
    case 'manual'
        handles.isManual = true;
        cpselect(handles.im1,handles.im2)
end

% Save the handles structure.
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

set(gca,'XColor',get(gca,'Color')) ;% 这两行代码功能：将坐标轴和坐标刻度转为白色
set(gca,'YColor',get(gca,'Color'));

set(gca,'XTickLabel',[]); % 这两行代码功能：去除坐标刻度
set(gca,'YTickLabel',[]);

% Hint: place code in OpeningFcn to populate axes1


% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

set(gca,'XColor',get(gca,'Color')) ;% 这两行代码功能：将坐标轴和坐标刻度转为白色
set(gca,'YColor',get(gca,'Color'));

set(gca,'XTickLabel',[]); % 这两行代码功能：去除坐标刻度
set(gca,'YTickLabel',[]);

% Hint: place code in OpeningFcn to populate axes3


% --- Executes during object creation, after setting all properties.
function axes4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

set(gca,'XColor',get(gca,'Color')) ;% 这两行代码功能：将坐标轴和坐标刻度转为白色
set(gca,'YColor',get(gca,'Color'));

set(gca,'XTickLabel',[]); % 这两行代码功能：去除坐标刻度
set(gca,'YTickLabel',[]);

% Hint: place code in OpeningFcn to populate axes4


% --- Executes during object creation, after setting all properties.
function axes5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

set(gca,'XColor',get(gca,'Color')) ;% 这两行代码功能：将坐标轴和坐标刻度转为白色
set(gca,'YColor',get(gca,'Color'));

set(gca,'XTickLabel',[]); % 这两行代码功能：去除坐标刻度
set(gca,'YTickLabel',[]);

% Hint: place code in OpeningFcn to populate axes5
