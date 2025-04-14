clear;
clc;
close all;
% HHS Region plots
load('NIS_Teen_Data_Sample.mat','Vaccinated_Region','Two_Dose_Region','Dropout_Region','Yr');
load('State_Regional_Number.mat');

Vaccinated_Region=median(squeeze(Vaccinated_Region(:,:,Yr==2022)),1);
Two_Dose_Region=median(squeeze(Two_Dose_Region(:,:,Yr==2022)),1);
Dropout_Region=median(squeeze(Dropout_Region(:,:,Yr==2022)),1);
load('HHS_Region_Polygons.mat',"poly_region")
XL={'I','II','III','IV','V','VI','VII','VIII','IX','X'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% At least one dose
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f1=figure('units','normalized','outerposition',[0 0.3 1 0.6]);
 ax1=usamap("all");
for jj=1:3
    ax1(jj).Position=[-1,1,0.4,0.4];
    setm(ax1(jj),"Frame","off","Grid","off","ParallelLabel","off","MeridianLabel","off")
end

ax3=usamap("all");
for jj=1:3
    ax3(jj).Position=[-1,-1,0.4,0.4];
    setm(ax3(jj),"Frame","off","Grid","off","ParallelLabel","off","MeridianLabel","off")
end

states = shaperead('usastatelo', 'UseGeoCoords', true);
NS=length(states);



% Color bar
cb1=subplot('Position',[0.4,0.1,0.02,0.89]);
Title_Name={'Coverage of at least one',' dose of vaccine'};

C=[hex2rgb('#ffffff');
    hex2rgb('#f7fcf5');
   hex2rgb('#e5f5e0');
    hex2rgb('#c7e9c0');
    hex2rgb('#a1d99b');
    hex2rgb('#74c476');
    hex2rgb('#41ab5d');
    hex2rgb('#238b45');
    hex2rgb('#006d2c');
    hex2rgb('#00441b');];
plot_measure=Vaccinated_Region;


v_temp=zeros(NS,1);
for ss=1:size(Regional_Number,1)
    tf=strcmpi({states.Name},Regional_Number{ss,1});
    num_reg=Regional_Number{ss,2};
    v_temp(tf)=plot_measure(num_reg);
end
xq=linspace(floor(min(v_temp.*100)),ceil(max(v_temp.*100)),10);
C_Plot=zeros(length(states),3);
for ss=1:NS
   C_Plot(ss,:)=interp1(xq,C,100.*v_temp(ss)); 
end
xp=linspace(0,1,1001);
for ii=1:1000
    patch([0 0 1 1],[xp(ii) xp(ii+1) xp(ii+1) xp(ii)],interp1(xq,C,floor(min(v_temp.*100))+(ceil(max(v_temp.*100))-floor(min(v_temp.*100))).*xp(ii+1)),'LineStyle','none'); hold on        
end
xt=linspace(0,1,10);
for ii=1:10
    text(1.5,xt(ii),[num2str(round(xq(ii))) '%'],"FontSize",16);
end
text(7.4,0.5,Title_Name,'HorizontalAlignment','center','Fontsize',18,'Rotation',270);
axis off;  

patch([0 0 1 1],[0 1 1 0],'k','FaceAlpha',0,'LineWidth',1.5)


states = readgeotable("usastatelo.shp");
rowConus = states.Name ~= "Hawaii" & states.Name ~= "Alaska";
rowAlaska = states.Name == "Alaska";
rowHawaii = states.Name == "Hawaii";

CM=makesymbolspec('Polygon',{'INDEX',[1 NS-2],'FaceColor',C_Plot(rowConus,:)});
geoshow(ax1(1),states(rowConus,:),'SymbolSpec',CM,'LineStyle','none'); 
CM=makesymbolspec('Polygon',{'INDEX',[1],'FaceColor',C_Plot(rowAlaska,:)});
geoshow(ax1(2),states(rowAlaska,:),'SymbolSpec',CM,'LineWidth',2,'EdgeColor',[0.35 0.35 0.35])
CM=makesymbolspec('Polygon',{'INDEX',[1],'FaceColor',C_Plot(rowHawaii,:)});
geoshow(ax1(3),states(rowHawaii,:),'SymbolSpec',CM,'LineWidth',2,'EdgeColor',[0.35 0.35 0.35])

for rn=1:10
    geoshow(ax1(1),poly_region{rn},'LineWidth',2,'Color',[0.35 0.35 0.35]);
end


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Dropout
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

states = shaperead('usastatelo', 'UseGeoCoords', true);
NS=length(states);


% Color bar
subplot('Position',[0.9,0.1,0.02,0.89]);
Title_Name={'Drop-out rate'};

C=[hex2rgb('#ffffff');
    hex2rgb('#fff7ec');
hex2rgb('#fee8c8');
hex2rgb('#fdd49e');
hex2rgb('#fdbb84');
hex2rgb('#fc8d59');
hex2rgb('#ef6548');
hex2rgb('#d7301f');
hex2rgb('#b30000');
hex2rgb('#7f0000');];
plot_measure=Dropout_Region;


v_temp=zeros(NS,1);
for ss=1:size(Regional_Number,1)
    tf=strcmpi({states.Name},Regional_Number{ss,1});
    num_reg=Regional_Number{ss,2};
    v_temp(tf)=plot_measure(num_reg);
end
xq=linspace(floor(min(v_temp.*100)),ceil(max(v_temp.*100)),10);
C_Plot=zeros(length(states),3);
for ss=1:NS
   C_Plot(ss,:)=interp1(xq,C,100.*v_temp(ss)); 
end
xp=linspace(0,1,1001);
for ii=1:1000
    patch([0 0 1 1],[xp(ii) xp(ii+1) xp(ii+1) xp(ii)],interp1(xq,C,floor(min(v_temp.*100))+(ceil(max(v_temp.*100))-floor(min(v_temp.*100))).*xp(ii+1)),'LineStyle','none'); hold on        
end
xt=linspace(0,1,10);
for ii=1:10
    text(1.5,xt(ii),[num2str(round(xq(ii))) '%'],"FontSize",16);
end
text(7.4,0.5,Title_Name,'HorizontalAlignment','center','Fontsize',18,'Rotation',270);
axis off;  

patch([0 0 1 1],[0 1 1 0],'k','FaceAlpha',0,'LineWidth',1.5)

states = readgeotable("usastatelo.shp");
rowConus = states.Name ~= "Hawaii" & states.Name ~= "Alaska";
rowAlaska = states.Name == "Alaska";
rowHawaii = states.Name == "Hawaii";

CM=makesymbolspec('Polygon',{'INDEX',[1 NS-2],'FaceColor',C_Plot(rowConus,:)});
geoshow(ax3(1),states(rowConus,:),'SymbolSpec',CM,'LineStyle','none'); 
CM=makesymbolspec('Polygon',{'INDEX',[1],'FaceColor',C_Plot(rowAlaska,:)});
geoshow(ax3(2),states(rowAlaska,:),'SymbolSpec',CM,'LineWidth',2,'EdgeColor',[0.35 0.35 0.35])
CM=makesymbolspec('Polygon',{'INDEX',[1],'FaceColor',C_Plot(rowHawaii,:)});
geoshow(ax3(3),states(rowHawaii,:),'SymbolSpec',CM,'LineWidth',2,'EdgeColor',[0.35 0.35 0.35])

for rn=1:10
    geoshow(ax3(1),poly_region{rn},'LineWidth',2,'Color',[0.35 0.35 0.35]);
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% % HHS Region Lables
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% 
pos=[2216605.0762248 5002267.49592642	0
1947778.774909931   4885019.843650832   0
1747622.06962426 4323250.6919856 0
1276398.16966137	3589911.21759527	0
1146386.80282462	4370675.12645991	0
153290.340427453	3429240.57965952	0
289344.765762096	4219691.90177510	0
-413062.445578170	4887349.25639782	0
-1249803.80119574	3810007.63306054	0
-1467789.95398418	4866120.160837961	0];

bt1=zeros(10,3);
bt1([1 2 3 5 7],:)=1+bt1([1 2 3 5 7],:);
bt3=zeros(10,3);
bt3([4 8 9 10],:)=1+bt3([4 8 9 10],:);

for rn=1:10
    text(ax3(1),pos(rn,1),pos(rn,2),['Region ' num2str(rn)],'HorizontalAlignment','center','VerticalAlignment','middle','Color',bt3(rn,:),'Fontsize',14,'FontWeight','bold');
    text(ax1(1),pos(rn,1),pos(rn,2),['Region ' num2str(rn)],'HorizontalAlignment','center','VerticalAlignment','middle','Color',bt1(rn,:),'Fontsize',14,'FontWeight','bold');
end

text(ax3(2),0.5,0.6,'Region 10','HorizontalAlignment','center','VerticalAlignment','middle','Color',bt3(10,:),'Fontsize',14,'FontWeight','bold','Units','Normalized');
text(ax1(2),0.5,0.6,'Region 10','HorizontalAlignment','center','VerticalAlignment','middle','Color',bt1(10,:),'Fontsize',14,'FontWeight','bold','Units','Normalized');

text(ax3(3),0.5,0.25,'Region 9','HorizontalAlignment','center','VerticalAlignment','middle','Color',bt3(9,:),'Fontsize',14,'FontWeight','bold','Units','Normalized');
text(ax1(3),0.5,0.25,'Region 9','HorizontalAlignment','center','VerticalAlignment','middle','Color',bt1(9,:),'Fontsize',14,'FontWeight','bold','Units','Normalized');


ax1(1).Position=[-0.27,0.05,1,1];
ax1(2).Position=[-0.225,-0.1,0.6,0.6];
ax1(3).Position=[0.1,-0.025,0.4,0.4];


ax3(1).Position=[-0.02,0.33-0.6850,1,1];
ax3(2).Position=[-0.055,0.58-0.6850,0.35,0.35];
ax3(3).Position=[0.25,0.645-0.6850,0.175,0.175];

aa=text(-38.69,3.47,'A','FontSize',30,'VerticalAlignment','middle','HorizontalAlignment','center','Units','normalized');
cc=text(-38.69,1,'C','FontSize',30,'VerticalAlignment','middle','HorizontalAlignment','center','Units','normalized');


exportgraphics(gcf, ['Figure_2.pdf']);



f1=figure('units','normalized','outerposition',[0 0.05 0.35 0.4]);
ax2=usamap("all");
for jj=1:3
    ax2(jj).Position=[-1,0,0.4,0.4];
    setm(ax2(jj),"Frame","off","Grid","off","ParallelLabel","off","MeridianLabel","off")
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Two doses
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


states = shaperead('usastatelo', 'UseGeoCoords', true);
NS=length(states);



% Color bar
subplot('Position',[0.815,0.36,0.02,0.28]);
Title_Name={'Coverage of at least two',' doses of vaccine'};

C=[hex2rgb('#ffffff');
   hex2rgb('#f7fbff');
hex2rgb('#deebf7');
hex2rgb('#c6dbef');
hex2rgb('#9ecae1');
hex2rgb('#6baed6');
hex2rgb('#4292c6');
hex2rgb('#2171b5');
hex2rgb('#08519c');
hex2rgb('#08306b');];
plot_measure=Two_Dose_Region;


v_temp=zeros(NS,1);
for ss=1:size(Regional_Number,1)
    tf=strcmpi({states.Name},Regional_Number{ss,1});
    num_reg=Regional_Number{ss,2};
    v_temp(tf)=plot_measure(num_reg);
end
xq=linspace(floor(min(v_temp.*100)),ceil(max(v_temp.*100)),10);
C_Plot=zeros(length(states),3);
for ss=1:NS
   C_Plot(ss,:)=interp1(xq,C,100.*v_temp(ss)); 
end
xp=linspace(0,1,1001);
for ii=1:1000
    patch([0 0 1 1],[xp(ii) xp(ii+1) xp(ii+1) xp(ii)],interp1(xq,C,floor(min(v_temp.*100))+(ceil(max(v_temp.*100))-floor(min(v_temp.*100))).*xp(ii+1)),'LineStyle','none'); hold on        
end
xt=linspace(0,1,10);
for ii=1:10
    text(1.5,xt(ii),[num2str(round(xq(ii))) '%'],"FontSize",16);
end
text(7.4,0.5,Title_Name,'HorizontalAlignment','center','Fontsize',18,'Rotation',270);
axis off;  

patch([0 0 1 1],[0 1 1 0],'k','FaceAlpha',0,'LineWidth',1.5)

states = readgeotable("usastatelo.shp");
rowConus = states.Name ~= "Hawaii" & states.Name ~= "Alaska";
rowAlaska = states.Name == "Alaska";
rowHawaii = states.Name == "Hawaii";

CM=makesymbolspec('Polygon',{'INDEX',[1 NS-2],'FaceColor',C_Plot(rowConus,:)});
geoshow(ax2(1),states(rowConus,:),'SymbolSpec',CM,'LineStyle','none'); 
CM=makesymbolspec('Polygon',{'INDEX',[1],'FaceColor',C_Plot(rowAlaska,:)});
geoshow(ax2(2),states(rowAlaska,:),'SymbolSpec',CM,'LineWidth',2,'EdgeColor',[0.35 0.35 0.35])
CM=makesymbolspec('Polygon',{'INDEX',[1],'FaceColor',C_Plot(rowHawaii,:)});
geoshow(ax2(3),states(rowHawaii,:),'SymbolSpec',CM,'LineWidth',2,'EdgeColor',[0.35 0.35 0.35])

for rn=1:10
    geoshow(ax2(1),poly_region{rn},'LineWidth',2,'Color',[0.35 0.35 0.35]);
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% % HHS Region Lables
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% 
pos=[2216605.0762248 5002267.49592642	0
1947778.774909931   4885019.843650832   0
1747622.06962426 4323250.6919856 0
1276398.16966137	3589911.21759527	0
1146386.80282462	4370675.12645991	0
153290.340427453	3429240.57965952	0
289344.765762096	4219691.90177510	0
-413062.445578170	4887349.25639782	0
-1249803.80119574	3810007.63306054	0
-1467789.95398418	4866120.160837961	0];

bt1=zeros(10,3);
bt1([1 2 3 5 7],:)=1+bt1([1 2 3 5 7],:);
bt2=zeros(10,3);
bt2([1 2],:)=1+bt2([1 2],:);
bt3=zeros(10,3);
bt3([4 8 9 10],:)=1+bt3([4 8 9 10],:);

for rn=1:10
    text(ax3(1),pos(rn,1),pos(rn,2),['Region ' num2str(rn)],'HorizontalAlignment','center','VerticalAlignment','middle','Color',bt3(rn,:),'Fontsize',14,'FontWeight','bold');
    text(ax2(1),pos(rn,1),pos(rn,2),['Region ' num2str(rn)],'HorizontalAlignment','center','VerticalAlignment','middle','Color',bt2(rn,:),'Fontsize',14,'FontWeight','bold');
    text(ax1(1),pos(rn,1),pos(rn,2),['Region ' num2str(rn)],'HorizontalAlignment','center','VerticalAlignment','middle','Color',bt1(rn,:),'Fontsize',14,'FontWeight','bold');
end

text(ax3(2),0.5,0.6,'Region 10','HorizontalAlignment','center','VerticalAlignment','middle','Color',bt3(10,:),'Fontsize',14,'FontWeight','bold','Units','Normalized');
text(ax2(2),0.5,0.6,'Region 10','HorizontalAlignment','center','VerticalAlignment','middle','Color',bt2(10,:),'Fontsize',14,'FontWeight','bold','Units','Normalized');
text(ax1(2),0.5,0.6,'Region 10','HorizontalAlignment','center','VerticalAlignment','middle','Color',bt1(10,:),'Fontsize',14,'FontWeight','bold','Units','Normalized');

text(ax3(3),0.5,0.25,'Region 9','HorizontalAlignment','center','VerticalAlignment','middle','Color',bt3(9,:),'Fontsize',14,'FontWeight','bold','Units','Normalized');
text(ax2(3),0.5,0.25,'Region 9','HorizontalAlignment','center','VerticalAlignment','middle','Color',bt2(9,:),'Fontsize',14,'FontWeight','bold','Units','Normalized');
text(ax1(3),0.5,0.25,'Region 9','HorizontalAlignment','center','VerticalAlignment','middle','Color',bt1(9,:),'Fontsize',14,'FontWeight','bold','Units','Normalized');


ax1(1).Position=[-0.02,0.33,1,1];
ax1(2).Position=[-0.055,0.58,0.35,0.35];
ax1(3).Position=[0.25,0.645,0.175,0.175];

ax2(1).Position=[-0.02,0.33-0.3375,1,1];
ax2(2).Position=[-0.055,0.58-0.3375,0.35,0.35];
ax2(3).Position=[0.25,0.645-0.3375,0.175,0.175];

ax3(1).Position=[-0.02,0.33-0.6850,1,1];
ax3(2).Position=[-0.055,0.58-0.6850,0.35,0.35];
ax3(3).Position=[0.25,0.645-0.6850,0.175,0.175];
aa=text(-38.69,3.47,'A','FontSize',30,'VerticalAlignment','middle','HorizontalAlignment','center','Units','normalized');
bb=text(-38.69,2.235,'B','FontSize',30,'VerticalAlignment','middle','HorizontalAlignment','center','Units','normalized');
cc=text(-38.69,1,'C','FontSize',30,'VerticalAlignment','middle','HorizontalAlignment','center','Units','normalized');