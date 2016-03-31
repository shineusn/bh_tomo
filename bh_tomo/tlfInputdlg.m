function d = tlfInputdlg(ntrace)


width = 445;
height = 250;
% get screen size
su = get(groot,'Units');
set(groot,'Units','points')
scnsize = get(groot,'ScreenSize');
pos = [scnsize(3)/2-width/2 scnsize(4)/2-height/2 width height];
set(groot,'Units',su)       % Restore default root screen units


f = figure('Visible','off',...
    'Units','points',...
    'Position',pos,...
    'Tag','positionInputdlg',...
    'Name','Antenna Position',...
    'NumberTitle','off',...
    'Resize','off',...
    'ToolBar','none',...,
    'MenuBar','None',...
    'CloseRequestFcn',@closeWindow);

fs = 11;
if ispc
    fs = 9;
end

uicontrol('Style','pushbutton',...
    'String','Cancel',...
    'Units','points',...
    'Position',[15 15 200 22],...
    'Callback',@cancel,...
    'FontSize',fs,...
    'Parent',f);
uicontrol('Style','pushbutton',...
    'String','Done',...
    'Units','points',...
    'Position',[230 15 200 22],...
    'Callback',@done,...
    'FontSize',fs,...
    'Parent',f);

hp1 = uipanel(f,'Title','Fixed Antenna',...
    'Units','points',...
    'Position',[15 45 200 175],...
    'FontSize',fs);

uicontrol('Style','text',...
    'String','Position',...
    'Units','points',...
    'HorizontalAlignment','right',...
    'Position',[15 120 100 22],...
    'FontSize',fs,...
    'Parent',hp1);
hfixedPos = uicontrol('Style','edit',...
    'String','',...
    'Units','points',...
    'Position',[120 120 60 22],...
    'FontSize',fs,...
    'TooltipString','Enter distance along borehole',...
    'Parent',hp1);
    
hfixedType = uicontrol('Style','popupmenu',...
    'String',{'Transmitter','Receiver'},...
    'Units','points',...
    'Position',[25 60 150 22],...
    'FontSize',fs,...
    'Parent',hp1);
    

hp2 = uipanel(f,'Title','Moving Antenna',...
    'Units','points',...
    'Position',[230 45 200 175],...
    'FontSize',fs);

uicontrol('Style','text',...
    'String','Start Position',...
    'Units','points',...
    'HorizontalAlignment','right',...
    'Position',[15 120 100 22],...
    'FontSize',fs,...
    'Parent',hp2);
hmovingPos = uicontrol('Style','edit',...
    'String','',...
    'Units','points',...
    'Position',[120 120 60 22],...
    'FontSize',fs,...
    'TooltipString','Enter distance along borehole',...
    'Parent',hp2);

uicontrol('Style','text',...
    'String','Increment',...
    'Units','points',...
    'HorizontalAlignment','right',...
    'Position',[15 85 100 22],...
    'FontSize',fs,...
    'Parent',hp2);
hinc = uicontrol('Style','edit',...
    'String','',...
    'Units','points',...
    'Position',[120 85 60 22],...
    'FontSize',fs,...
    'TooltipString','Distance Between measurements',...
    'Parent',hp2);

hupdown = uicontrol('Style','popupmenu',...
    'String',{'Downward','Upward'},...
    'Units','points',...
    'Position',[25 40 150 22],...
    'FontSize',fs,...
    'Parent',hp2);

uiwait(f)

    function closeWindow(varargin)
        delete(f)
    end
    function cancel(varargin)
        d = [];
        uiresume(f);
        closeWindow()
    end

    function done(varargin)
        
        if isempty(hfixedPos.String) || isempty(hmovingPos.String) || ...
                isempty(hinc.String)
            warndlg('Enter numeric values')
            return
        end
        
        if hupdown.Value == 1
            sign=1;  % positive downward
        else
            sign=-1;
        end
                
        zFixed = str2double(hfixedPos.String)+zeros(1,ntrace);
        dz=str2double(hinc.String);
        zMobile = str2double(hmovingPos.String)+sign*dz*(0:(ntrace-1));

        if any(isnan(zFixed)) || any(isnan(zMobile))
            warndlg('Enter numeric values')
            return
        end
        
        if hfixedType.Value==1
            d.Tx_z = zFixed;
            d.Rx_z = zMobile;
        else
            d.Tx_z = zMobile;
            d.Rx_z = zFixed;
        end
        
        uiresume(f);
        closeWindow()
    end

end