function [ALLEEG, EEG, CURRENTSET] = pop_SPA(ALLEEG, EEG, CURRENTSET)
h = figure('name', 'SPA','numbertitle', 'off','MenuBar', 'none',...
    'units','normalized','position',[0.4,0.1,0.3,0.8]);

data.epoch_twd = [-200,1000];
data.base_twd = [-200,0];

data.threshold = 30;
data.timewin = 2;
data.smooth = 2;

guidata(h,data);



pnl_EEG = uipanel(h,'Units','Normalized','Position',...
    [.05, .75 .9 .22]);

SPA_EEG_Label = uicontrol(h, 'Style', 'text', 'Units','Normalized', 'Position',...
    [.4 0.955 0.2 0.02],'String', 'SPA EEG','ForegroundColor','blue','FontWeight','bold');

ThresholdLabel = uicontrol(h, 'Style', 'text', 'Units','Normalized', 'Position',...
    [.1 0.9 0.15 0.03],'String', 'Threshold:','HorizontalAlignment','left');

ThresholdEdit = uicontrol(h,'style','Edit','Units','normalized','Position',...
    [.1 0.86 0.15 0.03],'string',num2str(data.threshold),'callback',@update_threshold);

TimewinLabel = uicontrol(h, 'Style', 'text', 'Units','Normalized', 'Position',...
    [.4 0.9 0.15 0.03],'String', 'Window size:','HorizontalAlignment','left');

TimewinEdit = uicontrol(h,'style','Edit','Units','normalized','Position',...
    [.4 0.86 0.15 0.03],'string',num2str(data.timewin),'callback',@update_timewin);

SmoothLabel = uicontrol(h, 'Style', 'text', 'Units','Normalized', 'Position',...
    [.7 0.9 0.15 0.03],'String', 'Smoothing:','HorizontalAlignment','left');

SmoothEdit = uicontrol(h,'style','Edit','Units','normalized','Position',...
    [.7 0.86 0.15 0.03],'string',num2str(data.smooth),'callback',@update_smooth);

SPA_EEG_Button = uicontrol(h, 'Style', 'pushbutton', 'Units','Normalized', 'Position',...
    [0.1 .78 0.8 0.05],'String', 'SPA EEG','Callback',...
    'EEG = SPA_EEG(EEG,guidata(gcf).threshold,guidata(gcf).timewin,guidata(gcf).smooth);msgbox(''SPA completed.'')');





pnl_ERP = uipanel(h,'Units','Normalized','Position',...
    [.05, .02 .9 .6]);

SPA_ERP_Label = uicontrol(h, 'Style', 'text', 'Units','Normalized', 'Position',...
    [.4 0.61 0.2 0.02],'String', 'SPA ERP','ForegroundColor','blue','FontWeight','bold');

ElecButton = uicontrol(h, 'Style', 'pushbutton', 'Units','Normalized', 'Position',...
    [0.1 .25 0.8 0.05],'String', 'Select Electrode to plot ERPs','Callback', @select_elec);
data.elec_label = {EEG.chanlocs.labels};
guidata(h,data);

MarkerButton = uicontrol(h, 'Style', 'pushbutton', 'Units','Normalized', 'Position',...
    [0.1 .55 0.8 0.05],'String', 'Select Marker(s)','Callback', @select_marker);
for j = 1:length(EEG.event) EEG.event(j).type = char(string(EEG.event(j).type));end
data.marker_label = unique({EEG.event.type});
guidata(h,data);

ERPButton = uicontrol(h, 'Style', 'pushbutton', 'Units','Normalized', 'Position',...
    [0.1 .15 0.8 0.05],'String', 'Plot ERPs','Callback','plotERP(EEG,guidata(gcf));');





EpochLabel = uicontrol(h, 'Style', 'text', 'Units','Normalized', 'Position',...
    [.15 0.45 0.4 0.03],'String', 'Epoch Time Window:');

EpochEdit = uicontrol(h,'style','Edit','Units','normalized','Position',...
    [.55 0.45 0.3 0.03],'string',num2str(data.epoch_twd),'callback',@update_epochtwd);

BaseLabel = uicontrol(h, 'Style', 'text', 'Units','Normalized', 'Position',...
    [.15 0.4 0.4 0.03],'String', 'Baseline Time Window:');

BaseEdit = uicontrol(h,'style','Edit','Units','normalized','Position',...
    [.55 0.4 0.3 0.03],'string',num2str(data.base_twd),'callback',@update_basetwd);

ThresholdLabel2 = uicontrol(h, 'Style', 'text', 'Units','Normalized', 'Position',...
    [.15 0.35 0.4 0.03],'String', 'Threshold:');

ThresholdEdit2 = uicontrol(h,'style','Edit','Units','normalized','Position',...
    [.55 0.35 0.3 0.03],'string',num2str(data.threshold),'callback',@update_threshold);


function select_elec(src,event,handle)
data = guidata(src);
[indx,tf] = listdlg('ListString',data.elec_label,'SelectionMode','single');
data.elec_indx = indx;
guidata(src,data);

function select_marker(src,event,handle)
data = guidata(src);
[indx,tf] = listdlg('ListString',data.marker_label);
data.marker_indx = indx;
guidata(src,data);

function update_epochtwd(src,event,handle)
data = guidata(src);
data.epoch_twd = str2num(get(src,'string'));
guidata(src,data)

function update_basetwd(src,event,handle)
data = guidata(src);
data.base_twd = str2num(get(src,'string'));
guidata(src,data)

function update_threshold(src,event,handle)
data = guidata(src);
data.threshold = str2num(get(src,'string'));
guidata(src,data)

function update_timewin(src,event,handle)
data = guidata(src);
data.timewin = str2num(get(src,'string'));
guidata(src,data)

function update_smooth(src,event,handle)
data = guidata(src);
data.smooth = str2num(get(src,'string'));
guidata(src,data)


