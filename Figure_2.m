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
f1=figure('units','normalized','outerposition',[0 0.3 0.8 0.6]);
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
cb1=subplot('Position',[0.445,0.03,0.005,0.945]);
Title_Name={'Coverage of at least one dose of vaccine'};

C=[1 1 1;
hex2rgb('#374e55');];
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
   C_Plot(ss,:)=interp1([floor(min(v_temp.*100)) ceil(max(v_temp.*100))],C,100.*v_temp(ss)); 
end
xp=linspace(0,1,1001);
for ii=1:1000
    patch([0 0 1 1],[xp(ii) xp(ii+1) xp(ii+1) xp(ii)],interp1([floor(min(v_temp.*100)) ceil(max(v_temp.*100))],C,floor(min(v_temp.*100))+(ceil(max(v_temp.*100))-floor(min(v_temp.*100))).*xp(ii+1)),'LineStyle','none'); hold on        
end
xt=linspace(0,1,10);
for ii=1:10
    text(1.5,xt(ii),[num2str(round(xq(ii))) '%'],"FontSize",16);
end
text(8.8,0.5,Title_Name,'HorizontalAlignment','center','Fontsize',18,'Rotation',270);
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
cb1=subplot('Position',[0.945,0.03,0.005,0.945]);
Title_Name={'Drop-out rate'};

C=[1 1 1;
hex2rgb('#b24745');];
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
   C_Plot(ss,:)=interp1([floor(min(v_temp.*100)) ceil(max(v_temp.*100))],C,100.*v_temp(ss)); 
end
xp=linspace(0,1,1001);
for ii=1:1000
    patch([0 0 1 1],[xp(ii) xp(ii+1) xp(ii+1) xp(ii)],interp1([floor(min(v_temp.*100)) ceil(max(v_temp.*100))],C,floor(min(v_temp.*100))+(ceil(max(v_temp.*100))-floor(min(v_temp.*100))).*xp(ii+1)),'LineStyle','none'); hold on        
end
xt=linspace(0,1,10);
for ii=1:10
    text(1.5,xt(ii),[num2str(round(xq(ii))) '%'],"FontSize",16);
end
text(8.8,0.5,Title_Name,'HorizontalAlignment','center','Fontsize',18,'Rotation',270);
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
pos=[2216605.0762248-200000 5002267.49592642+600000	0
1947778.774909931-400000   4885019.843650832+450000   0
1747622.06962426+500000 4323250.6919856-750000 0
1276398.16966137	3589911.21759527	0
1146386.80282462	4370675.12645991	0
153290.340427453	3429240.57965952	0
289344.765762096	4219691.90177510	0
-413062.445578170	4887349.25639782	0
-1249803.80119574	3810007.63306054	0
-1467789.95398418	4866120.160837961	0];

bt1=zeros(10,3);
bt1([5 7],:)=1+bt1([5 7],:);
bt3=zeros(10,3);
bt3([4 8 9 10],:)=1+bt3([4 8 9 10],:);

for rn=1:10
    text(ax3(1),pos(rn,1),pos(rn,2),['Region ' num2str(rn)],'HorizontalAlignment','center','VerticalAlignment','middle','Color',bt3(rn,:),'Fontsize',14,'FontWeight','bold');
    text(ax1(1),pos(rn,1),pos(rn,2),['Region ' num2str(rn)],'HorizontalAlignment','center','VerticalAlignment','middle','Color',bt1(rn,:),'Fontsize',14,'FontWeight','bold');
end

text(ax3(2),0.5,0.8,'Region 10','HorizontalAlignment','center','VerticalAlignment','middle','Color','k','Fontsize',14,'FontWeight','bold','Units','Normalized');
text(ax1(2),0.5,0.8,'Region 10','HorizontalAlignment','center','VerticalAlignment','middle','Color','k','Fontsize',14,'FontWeight','bold','Units','Normalized');

text(ax3(3),0.45,0.25,'Region 9','HorizontalAlignment','center','VerticalAlignment','middle','Color','k','Fontsize',14,'FontWeight','bold','Units','Normalized');
text(ax1(3),0.45,0.25,'Region 9','HorizontalAlignment','center','VerticalAlignment','middle','Color','k','Fontsize',14,'FontWeight','bold','Units','Normalized');


ax1(1).Position=[-0.27,0.05,1,1];
ax1(2).Position=[-0.225,-0.1,0.6,0.6];
ax1(3).Position=[0.1,-0.025,0.4,0.4];


ax3(1).Position=[-0.27+0.5,0.05,1,1];
ax3(2).Position=[-0.225+0.5,-0.1,0.6,0.6];
ax3(3).Position=[0.1+0.5,-0.025,0.4,0.4];

annotation(f1,'arrow',[0.388461963732861 0.403167846085802],[0.957558558558559 0.834234234234234]);
annotation(f1,'arrow',[0.355760725342769 0.383071649712517],[0.892693693693694 0.78018018018018]);
annotation(f1,'arrow',[0.399878372401592 0.370991817779744],[0.492693693693694 0.688288288288289]);

annotation(f1,'arrow',[0.388461963732861 0.403167846085802]+0.5,[0.957558558558559 0.834234234234234]);
annotation(f1,'arrow',[0.355760725342769 0.383071649712517]+0.5,[0.892693693693694 0.78018018018018]);
annotation(f1,'arrow',[0.399878372401592 0.370991817779744]+0.5,[0.492693693693694 0.688288288288289]);

aa=text(-184.5,1,'A','FontSize',30,'VerticalAlignment','middle','HorizontalAlignment','center','Units','normalized');
cc=text(-86,1,'B','FontSize',30,'VerticalAlignment','middle','HorizontalAlignment','center','Units','normalized');


exportgraphics(gcf, ['Figure_2.pdf']);



f2=figure('units','normalized','outerposition',[0.2 0.3 0.4 0.6]);
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
cb1=subplot('Position',[0.88,0.03,0.01,0.945]);
Title_Name={'Coverage of at least two doses of vaccine'};

C=[1 1 1;
hex2rgb('#79af97');];
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
   C_Plot(ss,:)=interp1([floor(min(v_temp.*100)) ceil(max(v_temp.*100))],C,100.*v_temp(ss)); 
end
xp=linspace(0,1,1001);
for ii=1:1000
    patch([0 0 1 1],[xp(ii) xp(ii+1) xp(ii+1) xp(ii)],interp1([floor(min(v_temp.*100)) ceil(max(v_temp.*100))],C,floor(min(v_temp.*100))+(ceil(max(v_temp.*100))-floor(min(v_temp.*100))).*xp(ii+1)),'LineStyle','none'); hold on        
end
xt=linspace(0,1,10);
for ii=1:10
    text(1.5,xt(ii),[num2str(round(xq(ii))) '%'],"FontSize",16);
end
text(9.8,0.5,Title_Name,'HorizontalAlignment','center','Fontsize',18,'Rotation',270);
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
pos=[2216605.0762248-200000 5002267.49592642+600000	0
1947778.774909931-400000   4885019.843650832+450000   0
1747622.06962426+500000 4323250.6919856-750000 0
1276398.16966137	3589911.21759527	0
1146386.80282462	4370675.12645991	0
153290.340427453	3429240.57965952	0
289344.765762096	4219691.90177510	0
-413062.445578170	4887349.25639782	0
-1249803.80119574	3810007.63306054	0
-1467789.95398418	4866120.160837961	0];


for rn=1:10
    text(ax2(1),pos(rn,1),pos(rn,2),['Region ' num2str(rn)],'HorizontalAlignment','center','VerticalAlignment','middle','Color','k','Fontsize',14,'FontWeight','bold');
end


text(ax2(2),0.5,0.8,'Region 10','HorizontalAlignment','center','VerticalAlignment','middle','Color','k','Fontsize',14,'FontWeight','bold','Units','Normalized');
text(ax2(3),0.45,0.25,'Region 9','HorizontalAlignment','center','VerticalAlignment','middle','Color','k','Fontsize',14,'FontWeight','bold','Units','Normalized');

ax2(1).Position=[-0.1,0.0,1.15,1.15];
ax2(2).Position=[-0.1,-0.12,0.65,0.65];
ax2(3).Position=[0.5,-0.025,0.45,0.45];

annotation(f2,'arrow',[0.696808510638298 0.751329787234043],[0.872873873873874 0.776576576576577]);
annotation(f2,'arrow',[0.757978723404255 0.793882978723404],[0.937738738738739 0.81981981981982]);
annotation(f2,'arrow',[0.792553191489362 0.719414893617021],[0.523324324324324 0.69009009009009]);

exportgraphics(gcf, ['Figure_Region_Two_Dose.jpeg']);