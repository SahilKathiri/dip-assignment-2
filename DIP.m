function varargout = DIP(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DIP_OpeningFcn, ...
                   'gui_OutputFcn',  @DIP_OutputFcn, ...
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

function DIP_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

guidata(hObject, handles);



function varargout = DIP_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


function listbox1_Callback(hObject, eventdata, handles)

    global i;
    List = get(hObject, 'String');
    Val = get(hObject, 'Value');
    file = pwd;
    file = strcat(file,'\images\');
    name = List(Val);
    name = char(name);
    name = deblank(name);
    filename = strcat(file, name);
    i = imread(filename);

    axes(handles.axes1);
    imshow(i);

function listbox1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function pushbutton1_Callback(hObject, eventdata, handles)

global i;
global lo;
global a1;
global a2;

a = fft2(double(i));
a1 = fftshift(a);
a2= abs(ifft2(lo.*a1));
a2=mat2gray(a2);
axes(handles.axes3);
imshow(lo);
axes(handles.axes4);
imshow(a2);


function pushbutton2_Callback(hObject, eventdata, handles)
global hi;
global i;
global a3;
global a1;
a = fft2(double(i));
a1 = fftshift(a);
a3= abs(ifft2(hi.*a1));
a3=mat2gray(a3);
axes(handles.axes10);
imshow(hi);
axes(handles.axes11);
imshow(a3);

function pushbutton3_Callback(hObject, eventdata, handles)
global i;
global filtered_image;
global d0;global d1;global filter3;


f = double(i);
[nx ny] = size(f);
f = uint8(f);
fftI = fft2(f,2*nx-1,2*ny-1);
fftI = fftshift(fftI);

filter1 = ones(2*nx-1,2*ny-1);
filter2 = ones(2*nx-1,2*ny-1);
filter3 = ones(2*nx-1,2*ny-1);
for k = 1:2*nx-1
    for j =1:2*ny-1
        dist = ((k-(nx+1))^2 + (j-(ny+1))^2)^.5;
                filter1(k,j) = exp(-dist^2/(2*d1^2));
        filter2(k,j) = exp(-dist^2/(2*d0^2));
        filter3(k,j) = 1.0 - filter2(k,j);
        filter3(k,j) = filter1(k,j).*filter3(k,j);
    end
end
filtered_image = fftI + filter3.*fftI;

%Initialize the filter 
filtered_image = ifftshift(filtered_image);
filtered_image = ifft2(filtered_image,2*nx-1,2*ny-1);
filtered_image = real(filtered_image(1:nx,1:ny));
filtered_image = uint8(filtered_image);

axes(handles.axes5);
imshow(filter3);%Gives filter 
axes(handles.axes12);
imshow(filtered_image); %gives the outut of the image.


function pushbutton4_Callback(hObject, eventdata, handles)
global i;
global j;
global k;
global dct_val;
j = dct2(i);
j(abs(j) < dct_val) = 0;
k = abs(idct2(j));
k = mat2gray(k);
axes(handles.axes9);
imshow(k);




function edit1_Callback(hObject, eventdata, handles)

global input1; 
global lo;
global i;
input1 = get(handles.edit1, 'value');
if isnan(input1)
  errordlg('You must enter a numeric value','Invalid Input','modal')
  uicontrol(hObject)
  return
else
  display(input1);
  str_1 = 'Cut-off Freq = ';
  str_2 = num2str(input1);
  data1 = strcat(str_1, str_2);
  set(handles.text7,'String',data1);
  

  a = fft2(double(i));
  [m n] = size(a);
  x=0:n-1;
  y=0:m-1;
  [x y]= meshgrid(x,y);
  cx = 0.5*n;
  cy = 0.5*m;
  lo = exp(-((x-cx).^2+(y-cy).^2)./(2*input1).^2);
  axes(handles.axes3);
  imshow(lo);
end

function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)

global input2 ;
global i;
global hi;
input2 = get(handles.edit2, 'value');
if isnan(input2)
  errordlg('You must enter a numeric value','Invalid Input','modal')
  uicontrol(hObject)
  return
else
  display(input2);
  str_1 = 'Cut-off Freq = ';
  str_2 = num2str(input2);
  data1 = strcat(str_1, str_2);
  set(handles.text6,'String',data1);
  
  
  a = fft2(double(i));
  [m n] = size(a);
  x=0:n-1;
  y=0:m-1;
  [x y]= meshgrid(x,y);
  cx = 0.5*n;
  cy = 0.5*m;
  lo_ = exp(-((x-cx).^2+(y-cy).^2)./(2*input2).^2);
  hi = 1 - lo_;
  axes(handles.axes10);
  imshow(hi);
end

function edit2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)


global d0;
d0 = get(handles.edit3, 'value');
if isnan(d0)
  errordlg('You must enter a numeric value','Invalid Input','modal')
  uicontrol(hObject)
  return
else
  display(d0);
  str_1 = 'Low Freq = ';
  str_2 = num2str(d0);
  data1 = strcat(str_1, str_2);
  set(handles.text4,'String',data1);
end

function edit3_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)


global d1;
 d1 = get(handles.edit4, 'value');
if isnan(d1)
  errordlg('You must enter a numeric value','Invalid Input','modal')
  uicontrol(hObject)
  return
else
  display(d1);
  str_1 = 'High Freq = ';
  str_2 = num2str(d1);
  data1 = strcat(str_1, str_2);
  set(handles.text5,'String',data1);
end

function edit4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit5_Callback(hObject, eventdata, handles)


global dct_val;
 dct_val = str2double(get(hObject,'String'));
if isnan(dct_val)
  errordlg('You must enter a numeric value','Invalid Input','modal')
  uicontrol(hObject)
  return
else
display(dct_val);
end
  
function edit5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
