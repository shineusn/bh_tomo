function varargout = bh_tomo_initial3d(varargin)
% BH_TOMO_INITIAL3D M-file for bh_tomo_initial3d.fig
%      BH_TOMO_INITIAL3D, by itself, creates a new BH_TOMO_INITIAL3D or raises the existing
%      singleton*.
%
%      H = BH_TOMO_INITIAL3D returns the handle to a new BH_TOMO_INITIAL3D or the handle to
%      the existing singleton*.
%
%      BH_TOMO_INITIAL3D('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BH_TOMO_INITIAL3D.M with the given input arguments.
%
%      BH_TOMO_INITIAL3D('Property','Value',...) creates a new BH_TOMO_INITIAL3D or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before bh_tomo_initial_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to bh_tomo_initial3d_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright (C) 2005 Bernard Giroux
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
% 
% 

% Last Modified by GUIDE v2.5 18-Feb-2013 15:14:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bh_tomo_initial3d_OpeningFcn, ...
                   'gui_OutputFcn',  @bh_tomo_initial3d_OutputFcn, ...
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


% --- Executes just before bh_tomo_initial3d is made visible.
function bh_tomo_initial3d_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to bh_tomo_initial3d (see VARARGIN)

% Choose default command line output for bh_tomo_initial3d
handles.output = hObject;
handles.second_output = [];

% Update handles structure
guidata(hObject, handles);

h.grx = (-0.2:0.2:1.2)';
h.gry = (-0.2:0.2:1.2)';
h.grz = (-2.2:0.2:0.2)';
h.background = 1/0.1;
h.valeur = 1/0.06;
h.cont = [];
h.model_orig = [];
h.draw_cont = false;

h.model3d = varargin{1};
if nargin>=5
    h.model_orig = varargin{2};
end
h.cont = h.model3d.grid3d.cont.slowness;
h.grz = h.model3d.grid3d.grz;
h.gry = h.model3d.grid3d.gry;
h.grx =h.model3d.grid3d.grx;
 
ind1=2:length(h.grx);
ind2=1:length(h.grx)-1;
h.gridx=(h.grx(ind2)+h.grx(ind1))/2;
ind1=2:length(h.gry);
ind2=1:length(h.gry)-1;
h.gridy=(h.gry(ind2)+h.gry(ind1))/2;
ind1=2:length(h.grz);
ind2=1:length(h.grz)-1;
h.gridz=(h.grz(ind2)+h.grz(ind1))/2;

h.aa=[min(h.grx)*ones(length(h.grz),1) max(h.grx)*ones(length(h.grz),1);h.grx h.grx]';
h.bb=[h.grz h.grz; min(h.grz)*ones(length(h.grx),1) max(h.grz)*ones(length(h.grx),1)]';

if isempty( h.model_orig )
	h.model = h.background*ones(numel(h.gridx)*numel(h.gridz),numel(h.gridy));
else
	h.model = h.model_orig;
end
h.str = get_str_locale();

set(handles.edit_background, 'String', num2str(1/h.background))
set(handles.edit_valeur, 'String', num2str(1/h.valeur))
set(handles.popupmenu_y,'String',h.gridy);
set_string_locale(handles,h.str)

setappdata(handles.fig_bh_initial, 'h', h)
update_fig(handles)

update_popupmenu_inv(handles);  %added 2012-11-15 YH

% UIWAIT makes bh_tomo_initial3d wait for user response (see UIRESUME)
uiwait(handles.fig_bh_initial);


% --- Outputs from this function are returned to the command line.
function varargout = bh_tomo_initial3d_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = handles.second_output;




function update_fig(handles)
h=getappdata(handles.fig_bh_initial,'h');
model = h.model;
indY = get(handles.popupmenu_y,'Value');
if ~isempty(h.cont) & h.draw_cont
	for nx=1:length(h.gridx)
		for nz=1:length(h.gridz)
			ix = ( h.cont.data(:,2)>=h.grx(nx) & h.cont.data(:,2)<h.grx(nx+1) ); 
			iz = ( h.cont.data(:,1)>=h.grz(nz) & h.cont.data(:,1)<h.grz(nz+1) ); 
			ind = ix&iz;
			if sum(ind)~=0
				model((nx-1)*numel(h.gridz)+nz,indY) = mean(h.cont.data(ind,3));
			end
		end
	end
end
axes(handles.axes_model)
imagesc(h.gridx,h.gridz,reshape(1./model(:,indY),length(h.gridz),length(h.gridx)))
colorbar('peer',handles.axes_model);
hold(handles.axes_model,'on')
plot(handles.axes_model,h.aa,h.bb,'Color',[0.5 0.5 0.5])
xlabel(h.str.s119)
ylabel(h.str.s120)
set(handles.axes_model,'YDir','normal')
hold(handles.axes_model,'off')

function edit_background_Callback(hObject, eventdata, handles)
h = getappdata(handles.fig_bh_initial, 'h');
indY = get(handles.popupmenu_y,'Value');
ind = h.model==h.background;
h.background = 1/str2num(get(hObject,'String'));
h.model(ind,indY) = h.background;
setappdata(handles.fig_bh_initial, 'h', h)
update_fig(handles)

function edit_background_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_valeur_Callback(hObject, eventdata, handles)
h = getappdata(handles.fig_bh_initial, 'h');
h.valeur = 1/str2num(get(hObject,'String'));
setappdata(handles.fig_bh_initial, 'h', h)


function edit_valeur_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pushbutton_edit_Callback(hObject, eventdata, handles)
if get(handles.checkbox_draw_cont,'Value')==1
	return
end
h = getappdata(handles.fig_bh_initial, 'h');
indY = get(handles.popupmenu_y,'Value');
axes(handles.axes_model)
[x,z,b] = ginput(1);
while b==1
    ix=findnear(x,h.gridx);
    iz=findnear(z,h.gridz);
    h.model((ix-1)*numel(h.gridz)+iz,indY) = h.valeur;
	setappdata(handles.fig_bh_initial, 'h', h)
	update_fig(handles)
    [x,z,b] = ginput(1);
end


function pushbutton_quit_Callback(hObject, eventdata, handles)
h = getappdata(handles.fig_bh_initial, 'h');
handles.second_output = h.model;
guidata(hObject, handles);
uiresume;


function pushbutton_annuler_Callback(hObject, eventdata, handles)
h = getappdata(handles.fig_bh_initial, 'h');
handles.second_output = h.model_orig;
guidata(hObject, handles);
uiresume;


function checkbox_draw_cont_Callback(hObject, eventdata, handles)
h = getappdata(handles.fig_bh_initial, 'h');
h.draw_cont = get(hObject,'Value');
setappdata(handles.fig_bh_initial, 'h', h)
update_fig(handles);


function pushbutton_help_Callback(hObject, eventdata, handles)
h=getappdata(handles.fig_bh_initial,'h');
helpdlg(h.str.s30);

function set_string_locale(handles,str)

set(handles.text_background,     'String', str.s49)
set(handles.text_valeur,         'String', str.s95)
set(handles.checkbox_draw_cont,  'String', str.s44)
set(handles.pushbutton_help,     'String', str.s32)
set(handles.pushbutton_edit,     'String', str.s122)
set(handles.pushbutton_annuler,  'String', str.s91)
set(handles.pushbutton_quit,     'String', str.s193)

function pushbutton_load_Callback(hObject, eventdata, handles)

update_fig(handles);

% --- Executes on selection change in popupmenu_inv.
function popupmenu_inv_Callback(hObject, eventdata, handles)



function update_popupmenu_inv(handles)
h = getappdata(handles.fig_bh_initial, 'h');
texte = {};
if isfield(h.model3d,'inv_res')
	for n=1:length(h.model3d.inv_res)
		texte{n} = [char( h.model3d.inv_res(n).name ), ', ',char( h.model3d.inv_res(n).tomo.date)]; 
	end
end
if ~isempty( texte )
	set(handles.popupmenu_inv,'String',texte,'Value',1) 
else
	set(handles.popupmenu_inv,'String','--','Value',1)  
end


function popupmenu_inv_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function fig_bh_initial_CloseRequestFcn(hObject, eventdata, handles)
%delete(hObject);
pushbutton_quit_Callback(hObject, eventdata, handles);


function popupmenu_y_Callback(hObject, eventdata, handles)
update_fig(handles);

function popupmenu_y_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
