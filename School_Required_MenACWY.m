clear;
clc;
close all;
V=readtable("School_Req_Vac.xlsx");
load('HHS_Region_Polygons.mat',"poly_region")

f1=figure('units','normalized','outerposition',[0.2 0.2 0.5 0.5]);
 ax1=usamap("all");
for jj=1:3
    setm(ax1(jj),"Frame","off","Grid","off","ParallelLabel","off","MeridianLabel","off")
end

states = readgeotable("usastatelo.shp");
rowConus = states.Name ~= "Hawaii" & states.Name ~= "Alaska";
rowAlaska = states.Name == "Alaska";
rowHawaii = states.Name == "Hawaii";

NS=height(states);
C_Plot=ones(NS,3);

for ii=1:NS
    tf=strcmp(states.Name{ii},V.State);
    if(V.HS_Req(tf)==0)
        C_Plot(ii,:)=[0.65 0 0];
    elseif(V.HS_Req(tf)==1)
        C_Plot(ii,:)=hex2rgb('#fc9272');
    else
        C_Plot(ii,:)=hex2rgb('#7DA3A1');
    end
end


CM=makesymbolspec('Polygon',{'INDEX',[1 NS-2],'FaceColor',C_Plot(rowConus,:)});
geoshow(ax1(1),states(rowConus,:),'SymbolSpec',CM,'LineWidth',0.5,'LineStyle','--'); 
CM=makesymbolspec('Polygon',{'INDEX',[1],'FaceColor',C_Plot(rowAlaska,:)});
geoshow(ax1(2),states(rowAlaska,:),'SymbolSpec',CM,'LineWidth',3,'EdgeColor','k')
CM=makesymbolspec('Polygon',{'INDEX',[1],'FaceColor',C_Plot(rowHawaii,:)});
geoshow(ax1(3),states(rowHawaii,:),'SymbolSpec',CM,'LineWidth',3,'EdgeColor','k')


for rn=1:10
    geoshow(ax1(1),poly_region{rn},'LineWidth',3,'Color','k');
end



ax1(1).Position=[-0.0,-0.03,1.1,1.1];
ax1(2).Position=[-0.05,-0.1,0.6,0.6];
ax1(3).Position=[0.2,0.05,0.4,0.4];

t=text(ax1(1),-0.075,0.9,'Not required','FontSize',18,'Units','Normalized','Color',[0.65 0 0]);
t=text(ax1(1),-0.075,0.84,'One dose required','FontSize',18,'Units','Normalized','Color',hex2rgb('#fc9272'));
t=text(ax1(1),-0.075,0.78,'Two doses required','FontSize',18,'Units','Normalized','Color',hex2rgb('#7DA3A1'));

print(gcf, ['Figure_Vac_School.jpg'],'-djpeg','-r300');