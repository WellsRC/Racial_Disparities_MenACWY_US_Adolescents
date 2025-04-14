clear;
clc;
close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Color Scheme
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C_Vac=[1 1 1;
hex2rgb('#374e55');];


C_Vac_2D=[1 1 1;
hex2rgb('#79af97');];

C_Drop=[1 1 1;
hex2rgb('#b24745');];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Load Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('NIS_Teen_Data_Sample.mat','Dropout_Mother_Education','Vaccinated_Mother_Education','Two_Dose_Mother_Education','U_Mother_Education','Yr');
U_Name={'No College Education','Some College Education'}; %U_Mother_Education;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Summarize Dropout Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Dropout=squeeze(median(Dropout_Mother_Education,1));
Marker_Type_Dropout=cell(size(Dropout));
for uu=2:length(U_Mother_Education)
    for yy=1:length(Yr)
        dx=Dropout_Mother_Education(:,uu,yy)-Dropout_Mother_Education(:,1,yy);
        if(prctile(dx,5)>0)
            Marker_Type_Dropout{uu,yy}=char(167);
        elseif(prctile(dx,95)<0)
            Marker_Type_Dropout{uu,yy}=char(42);
        end
    end
end
lb_drop=Dropout-squeeze(prctile(Dropout_Mother_Education,25));
ub_drop=squeeze(prctile(Dropout_Mother_Education,75))-Dropout;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Summarize At least one dose Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Vaccinated=squeeze(median(Vaccinated_Mother_Education,1));
Marker_Type_Vaccinated=cell(size(Vaccinated));
for uu=2:length(U_Mother_Education)
    for yy=1:length(Yr)
        dx=Vaccinated_Mother_Education(:,uu,yy)-Vaccinated_Mother_Education(:,1,yy);
        if(prctile(dx,5)>0)
            Marker_Type_Vaccinated{uu,yy}=char(167);
        elseif(prctile(dx,95)<0)
            Marker_Type_Vaccinated{uu,yy}=char(42);
        end
    end
end
lb_vac=Vaccinated-squeeze(prctile(Vaccinated_Mother_Education,25));
ub_vac=squeeze(prctile(Vaccinated_Mother_Education,75))-Vaccinated;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Summarize At least two doses Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ED_Vaccinated_2D=squeeze(median(Two_Dose_Mother_Education,1));

lb_ED_vac_2D=ED_Vaccinated_2D-squeeze(prctile(Two_Dose_Mother_Education,25));
ub_ED_vac_2D=squeeze(prctile(Two_Dose_Mother_Education,75))-ED_Vaccinated_2D;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Adjust naming
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% For the error bars in the bar plot
dx=[-0.125 0.125];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate the plot for Mother's Education
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


C_plot_V=interp1([0 1],C_Vac,linspace(0,1,3));
C_plot_D=interp1([0 1],C_Drop,linspace(0,1,3));

figure('units','normalized','outerposition',[0 0.05 0.6 0.7]);

% At Least one dose bar plot
subplot('Position',[0.1 0.595 0.395 0.39]) 
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
text(-0.225,1.15,'A','Units','normalized','HorizontalAlignment','center','VerticalAlignment','middle','Fontsize',28);

subplot('Position',[0.1 0.105 0.395 0.39]) 
b=bar([Yr],100.*Dropout,'LineWidth',1.5);
for ii=1:length(b)
    b(ii).FaceColor=C_plot_D(ii,:);
    b(ii).EdgeColor=C_Drop(end,:);
end
hold on

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


ylim([0 60]);
ytickformat('percentage');
text(-0.225,1.15,'C','Units','normalized','HorizontalAlignment','center','VerticalAlignment','middle','Fontsize',28);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Load Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('NIS_Teen_Data_Sample.mat','Dropout_Income_Poverty_Ratio','Vaccinated_Income_Poverty_Ratio','Two_Dose_Income_Poverty_Ratio','U_Income_Poverty_Ratio','Yr');
U_Name=U_Income_Poverty_Ratio;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Summarize Dropout Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Dropout=squeeze(median(Dropout_Income_Poverty_Ratio,1));
Marker_Type_Dropout=cell(size(Dropout));
for uu=2:length(U_Income_Poverty_Ratio)
    for yy=1:length(Yr)
        dx=Dropout_Income_Poverty_Ratio(:,uu,yy)-Dropout_Income_Poverty_Ratio(:,1,yy);
        if(prctile(dx,5)>0)
            Marker_Type_Dropout{uu,yy}=char(167);
        elseif(prctile(dx,95)<0)
            Marker_Type_Dropout{uu,yy}=char(42);
        end
    end
end
lb_drop=Dropout-squeeze(prctile(Dropout_Income_Poverty_Ratio,25));
ub_drop=squeeze(prctile(Dropout_Income_Poverty_Ratio,75))-Dropout;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Summarize At least one dose Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Vaccinated=squeeze(median(Vaccinated_Income_Poverty_Ratio,1));
Marker_Type_Vaccinated=cell(size(Vaccinated));
for uu=2:length(U_Income_Poverty_Ratio)
    for yy=1:length(Yr)
        dx=Vaccinated_Income_Poverty_Ratio(:,uu,yy)-Vaccinated_Income_Poverty_Ratio(:,1,yy);
        if(prctile(dx,5)>0)
            Marker_Type_Vaccinated{uu,yy}=char(167);
        elseif(prctile(dx,95)<0)
            Marker_Type_Vaccinated{uu,yy}=char(42);
        end
    end
end
lb_vac=Vaccinated-squeeze(prctile(Vaccinated_Income_Poverty_Ratio,25));
ub_vac=squeeze(prctile(Vaccinated_Income_Poverty_Ratio,75))-Vaccinated;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Summarize At least two doses Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Vaccinated_2D=squeeze(median(Two_Dose_Income_Poverty_Ratio,1));
Marker_Type_Vaccinated=cell(size(Vaccinated_2D));
for uu=2:length(U_Income_Poverty_Ratio)
    for yy=1:length(Yr)
        dx=Two_Dose_Income_Poverty_Ratio(:,uu,yy)-Two_Dose_Income_Poverty_Ratio(:,1,yy);
        if(prctile(dx,5)>0)
            Marker_Type_Vaccinated{uu,yy}=char(167);
        elseif(prctile(dx,95)<0)
            Marker_Type_Vaccinated{uu,yy}=char(42);
        end
    end
end
lb_vac_2D=Vaccinated_2D-squeeze(prctile(Two_Dose_Income_Poverty_Ratio,25));
ub_vac_2D=squeeze(prctile(Two_Dose_Income_Poverty_Ratio,75))-Vaccinated_2D;

% For the error bars in the bar plot
dx=[-0.225 0 0.225];

U_Name={'PIR \leq 1', '1< PIR \leq 2', 'PIR>2'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate the plot for PIR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

C_plot_V=interp1([0 1],C_Vac,linspace(0,1,4));
C_plot_D=interp1([0 1],C_Drop,linspace(0,1,4));

% At Least one dose bar plot
subplot('Position',[0.1+0.5 0.595 0.395 0.39]) 
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
text(-0.225,1.15,'B','Units','normalized','HorizontalAlignment','center','VerticalAlignment','middle','Fontsize',28);

subplot('Position',[0.1+0.5 0.105 0.395 0.39]) 
b=bar([Yr],100.*Dropout,'LineWidth',1.5);
for ii=1:length(b)
    b(ii).FaceColor=C_plot_D(ii,:);
    b(ii).EdgeColor=C_Drop(end,:);
end
hold on


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


ylim([0 60]);
ytickformat('percentage');
text(-0.225,1.15,'D','Units','normalized','HorizontalAlignment','center','VerticalAlignment','middle','Fontsize',28);

exportgraphics(gcf, ['Figure_3.pdf']);
print(gcf, ['Figure_3.jpg'],'-djpeg','-r300');

figure('units','normalized','outerposition',[0.2 0.05 0.5 0.7]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Education
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

U_Mother_Education={'No College Education','Some College Education'}; %U_Mother_Education;
% For the error bars in the bar plot
dx=[-0.125 0.125];

C_plot_V_2D=interp1([0 1],C_Vac_2D,linspace(0,1,3));

% At Least two dose bar plot
subplot('Position',[0.125 0.595 0.87 0.39]) 
b=bar([Yr],100.*ED_Vaccinated_2D,'LineWidth',1.5);
for ii=1:length(b)
    b(ii).FaceColor=C_plot_V_2D(ii,:);
    b(ii).EdgeColor=C_Vac_2D(end,:);
end
hold on
% At Least two dose error bars
for ii=1:length(U_Mother_Education)
    errorbar(dx(ii)+[Yr],100.*ED_Vaccinated_2D(ii,:),100.*lb_ED_vac_2D(ii,:),100.*ub_ED_vac_2D(ii,:),'CapSize',0,'LineStyle','none','Color',C_Vac_2D(end,:),'LineWidth',2);
end

set(gca,'LineWidth',2,'tickdir','out','Fontsize',14,'XTick',[Yr],'YTick',[0:20:100],'Yminortick','on');
xlabel('Year of survey','FontSize',16)
ylabel({'At least two doses','of vaccine'},'FontSize',16)
legend(U_Mother_Education,'Fontsize',12,'NumColumns',6,'Location','northoutside');
legend boxoff;
box off;
ylim([0 100]);
xlim([2015.5 2022.5]);
ytickformat('percentage');
text(-0.125,1.15,'A','Units','normalized','HorizontalAlignment','center','VerticalAlignment','middle','Fontsize',28);

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PIR
%%%%%%%%%%%%%%%%%%%%%%%%%%5

C_plot_V_2D=interp1([0 1],C_Vac_2D,linspace(0,1,4));
% For the error bars in the bar plot
dx=[-0.225 0 0.225];
% At Least two dose bar plot
subplot('Position',[0.125 0.105 0.87 0.39]) 
b=bar([Yr],100.*Vaccinated_2D,'LineWidth',1.5);
for ii=1:length(b)
    b(ii).FaceColor=C_plot_V_2D(ii,:);
    b(ii).EdgeColor=C_Vac_2D(end,:);
end
hold on
% At Least two dose error bars
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

print(gcf, ['Figure_Two_Doses_Education_PIR.jpg'],'-djpeg','-r300');
