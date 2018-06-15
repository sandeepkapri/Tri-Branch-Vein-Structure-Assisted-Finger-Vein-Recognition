function varargout = triBranch(varargin)
%TRIBRANCH MATLAB code file for triBranch.fig
%      TRIBRANCH, by itself, creates a new TRIBRANCH or raises the existing
%      singleton*.
%
%      H = TRIBRANCH returns the handle to a new TRIBRANCH or the handle to
%      the existing singleton*.
%
%      TRIBRANCH('Property','Value',...) creates a new TRIBRANCH using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to triBranch_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      TRIBRANCH('CALLBACK') and TRIBRANCH('CALLBACK',hObject,...) call the
%      local function named CALLBACK in TRIBRANCH.M with the given input
%      arguments.
%n
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help triBranch

% Last Modified by GUIDE v2.5 08-Apr-2018 09:58:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @triBranch_OpeningFcn, ...
                   'gui_OutputFcn',  @triBranch_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before triBranch is made visible.
function triBranch_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for triBranch
uiwait(msgbox('Locate the TBVS Directory.'))
handles.codeDir = uigetdir();
handles.output = hObject;
handles.ldcFlag = 0;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes triBranch wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = triBranch_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in locate_directory.
function locate_directory_Callback(hObject, eventdata, handles)
folderLoc = uigetdir(handles.codeDir);
handles.ldcFlag = 1;
handles.fLoc = folderLoc;
guidata(hObject,handles);


% --- Executes on button press in training.
function training_Callback(hObject, eventdata, handles)
if(handles.ldcFlag == 1)
    trainingTriBranch(handles);
    trainingPBBM(handles);
else
msgbox('Kindly locate the directory first.');
end
set(handles.statusText, 'String', 'Training Completed.');
drawnow;


% --- Executes on button press in verification.
function verification_Callback(hObject, eventdata, handles)
[pathstr,~,~] = fileparts(mfilename('fullpath'));
pathstrt = handles.codeDir;
[filename,pathname]=uigetfile(...
    {'*.jpg;*.png;*.bmp',...
     'image file(*.jpg,*.png,*.bmp)';'*.*','all files(*.*)'},...
     'Select an image for verification',pathstrt);
 
% need to handle the case where the user presses cancel
if filename~=0
    fullimagefilename = fullfile(pathname,filename);

  %Loadng and extracting Tri Branch vein of Probe Image
    probeimg = imread(fullimagefilename);
    probeimg=im2double(rgb2gray(probeimg));
    
    probeTbMap = tbMap(probeimg);  
    disp('+-----------------------Tri Branch Filtered Image----------------------+')
    candidateVec = verificationTriBranch(probeimg,handles); 
    lcv = length(candidateVec(:,1));
    candidateVecArr = cell2mat(candidateVec(2:lcv,1));
    disp('+-------------------Second Level Output(PBBM used)-------------------+')
    verificationPBBM(probeimg,candidateVecArr,handles);
end
