clear;
clc;
close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Color Scheme
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C_Vac=[hex2rgb('#f7fcfd');
hex2rgb('#e5f5f9');
hex2rgb('#ccece6');
hex2rgb('#99d8c9');
hex2rgb('#66c2a4');
hex2rgb('#41ae76');
hex2rgb('#238b45');
hex2rgb('#006d2c');
hex2rgb('#00441b');];
x_vac=linspace(0,1,size(C_Vac,1)-1);


C_Vac_2D=[hex2rgb('#f7fbff');
hex2rgb('#deebf7');
hex2rgb('#c6dbef');
hex2rgb('#9ecae1');
hex2rgb('#6baed6');
hex2rgb('#4292c6');
hex2rgb('#2171b5');
hex2rgb('#08519c');
hex2rgb('#08306b');];
x_vac_2D=linspace(0,1,size(C_Vac_2D,1)-1);

C_Drop=[hex2rgb('#fff5f0');
hex2rgb('#fee0d2');
hex2rgb('#fcbba1');
hex2rgb('#fc9272');
hex2rgb('#fb6a4a');
hex2rgb('#ef3b2c');
hex2rgb('#cb181d');
hex2rgb('#a50f15');
hex2rgb('#67000d');];
x_drop=linspace(0,1,size(C_Drop,1)-1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Load Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('NIS_Teen_Data_Sample.mat','Dropout_Race','Vaccinated_Race','Two_Dose_Race','U_Race','Yr');
reorder_array=[4 1 3 2];
U_Race=U_Race(reorder_array);
Dropout_Race=Dropout_Race(:,reorder_array,:);
Vaccinated_Race=Vaccinated_Race(:,reorder_array,:);
Two_Dose_Race=Two_Dose_Race(:,reorder_array,:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Summarize Dropout Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Dropout=squeeze(median(Dropout_Race,1));
Marker_Type_Dropout=cell(size(Dropout));
for uu=2:length(U_Race)
    for yy=1:length(Yr)
        dx=Dropout_Race(:,uu,yy)-Dropout_Race(:,1,yy);
        if(prctile(dx,5)>0)
            Marker_Type_Dropout{uu,yy}=char(167);
        elseif(prctile(dx,95)<0)
            Marker_Type_Dropout{uu,yy}=char(42);
        end
    end
end
lb_drop=Dropout-squeeze(prctile(Dropout_Race,25));
ub_drop=squeeze(prctile(Dropout_Race,75))-Dropout;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Summarize At least one dose Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Vaccinated=squeeze(median(Vaccinated_Race,1));
Marker_Type_Vaccinated=cell(size(Vaccinated));
for uu=2:length(U_Race)
    for yy=1:length(Yr)
        dx=Vaccinated_Race(:,uu,yy)-Vaccinated_Race(:,1,yy);
        if(prctile(dx,5)>0)
            Marker_Type_Vaccinated{uu,yy}=char(167);
        elseif(prctile(dx,95)<0)
            Marker_Type_Vaccinated{uu,yy}=char(42);
        end
    end
end
lb_vac=Vaccinated-squeeze(prctile(Vaccinated_Race,25));
ub_vac=squeeze(prctile(Vaccinated_Race,75))-Vaccinated;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Summarize At least two doses Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Vaccinated_2D=squeeze(median(Two_Dose_Race,1));
Marker_Type_Vaccinated=cell(size(Vaccinated_2D));
for uu=2:length(U_Race)
    for yy=1:length(Yr)
        dx=Two_Dose_Race(:,uu,yy)-Two_Dose_Race(:,1,yy);
        if(prctile(dx,5)>0)
            Marker_Type_Vaccinated{uu,yy}=char(167);
        elseif(prctile(dx,95)<0)
            Marker_Type_Vaccinated{uu,yy}=char(42);
        end
    end
end
lb_vac_2D=Vaccinated_2D-squeeze(prctile(Two_Dose_Race,25));
ub_vac_2D=squeeze(prctile(Two_Dose_Race,75))-Vaccinated_2D;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Adjust naming
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

U_Name={'NH White','Hispanic','NH Other + multiple races','NH African American'};
% For the error bars in the bar plot
dx=[-0.27 -0.09 0.09 0.27];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate the plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


C_plot_V=interp1(x_vac,C_Vac(1:end-1,:),linspace(0,1,length(U_Name)));
C_plot_V_2D=interp1(x_vac_2D,C_Vac_2D(1:end-1,:),linspace(0,1,length(U_Name)));
C_plot_D=interp1(x_drop,C_Drop(1:end-1,:),linspace(0,1,length(U_Name)));

figure('units','normalized','outerposition',[0.2 0.05 0.5 1]);

% At Least one dose bar plot
subplot('Position',[0.125 0.74 0.87 0.26]) 
b=bar([Yr],100.*Vaccinated,'LineWidth',1.5);
for ii=1:length(b)
    b(ii).FaceColor=C_plot_V(ii,:);
    b(ii).EdgeColor=C_Vac(end,:);
end
hold on
% At Least one dose error bars
for ii=1:length(U_Name)
    errorbar(dx(ii)+[Yr],100.*Vaccinated(ii,:),100.*lb_vac(ii,:),100.*ub_vac(ii,:),'CapSize',0,'LineStyle','none','Color',C_Vac(end,:),'LineWidth',2);
end

set(gca,'LineWidth',2,'tickdir','out','Fontsize',14,'XTick',[Yr],'YTick',[0:20:100],'Yminortick','on');
xlabel('Year of survey','FontSize',16)
ylabel({'At least one dose','of vaccine'},'FontSize',16)
legend(U_Name,'Fontsize',12,'NumColumns',6,'Location','northoutside');
legend boxoff;
box off;
ylim([0 100]);
xlim([2015.5 2022.5]);
ytickformat('percentage');
text(-0.125,1.15,'A','Units','normalized','HorizontalAlignment','center','VerticalAlignment','middle','Fontsize',28);

% At Least one dose bar plot
subplot('Position',[0.125 0.405 0.87 0.26]) 
b=bar([Yr],100.*Vaccinated_2D,'LineWidth',1.5);
for ii=1:length(b)
    b(ii).FaceColor=C_plot_V_2D(ii,:);
    b(ii).EdgeColor=C_Vac_2D(end,:);
end
hold on
% At Least one dose error bars
for ii=1:length(U_Name)
    errorbar(dx(ii)+[Yr],100.*Vaccinated_2D(ii,:),100.*lb_vac_2D(ii,:),100.*ub_vac_2D(ii,:),'CapSize',0,'LineStyle','none','Color',C_Vac_2D(end,:),'LineWidth',2);
end

set(gca,'LineWidth',2,'tickdir','out','Fontsize',14,'XTick',[Yr],'YTick',[0:20:100],'Yminortick','on');
xlabel('Year of survey','FontSize',16)
ylabel({'At least two doses','of vaccine'},'FontSize',16)
legend(U_Name,'Fontsize',12,'NumColumns',6,'Location','northoutside');
legend boxoff;
box off;
ylim([0 100]);
xlim([2015.5 2022.5]);
ytickformat('percentage');
text(-0.125,1.15,'B','Units','normalized','HorizontalAlignment','center','VerticalAlignment','middle','Fontsize',28);


subplot('Position',[0.125 0.07 0.87 0.26]) 
b=bar([Yr],100.*Dropout,'LineWidth',1.5);
for ii=1:length(b)
    b(ii).FaceColor=C_plot_D(ii,:);
    b(ii).EdgeColor=C_Drop(end,:);
end
hold on


maxy=floor(max(100.*ub_drop(:)+100.*Dropout(:)));
maxy=maxy+(5-rem(maxy,5));

for ii=1:length(U_Name)
    errorbar(dx(ii)+[Yr],100.*Dropout(ii,:),100.*lb_drop(ii,:),100.*ub_drop(ii,:),'CapSize',0,'LineStyle','none','Color',C_Drop(end,:),'LineWidth',2);
end


set(gca,'LineWidth',2,'tickdir','out','Fontsize',14,'XTick',[Yr 2023],'YTick',[0:10:60],'Yminortick','on');
xlabel('Year of survey','FontSize',16)
ylabel({'Drop-out rate'},'FontSize',16)
xlim([2015.5 2022.5]);
legend(U_Name,'Fontsize',12,'NumColumns',6,'Location','northoutside');
legend boxoff;
box off;


ylim([0 maxy]);
ytickformat('percentage');
text(-0.125,1.15,'C','Units','normalized','HorizontalAlignment','center','VerticalAlignment','middle','Fontsize',28);


exportgraphics(gcf, ['Figure_1.pdf']);
print(gcf, ['Figure_1.jpg'],'-djpeg','-r300');