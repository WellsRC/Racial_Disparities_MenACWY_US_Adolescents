function  [Table_Vaccination, Table_Vaccination_2D, Table_Dropout]=Figure_Tables_Variables(Var)
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


if(strcmp(Var,'Race'))
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
    pval_Dropout=NaN.*zeros(size(Dropout));
    d_dropout=NaN.*zeros(size(Dropout));
    for uu=2:length(U_Race)
        for yy=1:length(Yr)
            if(median(Dropout_Race(:,1,yy))>median(Dropout_Race(:,uu,yy)))
                pval_Dropout(uu,yy)=ranksum(Dropout_Race(:,uu,yy),Dropout_Race(:,1,yy),"tail",'left');
            else
                pval_Dropout(uu,yy)=ranksum(Dropout_Race(:,uu,yy),Dropout_Race(:,1,yy),"tail",'right');
            end
            Effect = meanEffectSize(Dropout_Race(:,uu,yy),Dropout_Race(:,1,yy),Effect="cliff");
            d_dropout(uu,yy)=Effect.Effect;
        end
    end
    lb_drop=Dropout-squeeze(prctile(Dropout_Race,25));
    ub_drop=squeeze(prctile(Dropout_Race,75))-Dropout;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    % Summarize Dropout Data 2016 vs 2022
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Dropout_2016_vs_2022=squeeze(median(Dropout_Race,1));
    Dropout_2016_vs_2022=Dropout_2016_vs_2022(:,[1 length(Yr)]);
    Reduction_Dropout=(Dropout_2016_vs_2022(:,1)-Dropout_2016_vs_2022(:,2))./Dropout_2016_vs_2022(:,1);
    R=U_Race';
   table(R,Dropout_2016_vs_2022,Reduction_Dropout)

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    % Summarize At least one dose Data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Vaccinated=squeeze(median(Vaccinated_Race,1));
    pval_Vaccinated=NaN.*zeros(size(Vaccinated));
    d_Vaccinated=NaN.*zeros(size(Dropout));
    for uu=2:length(U_Race)
        for yy=1:length(Yr)
            if(median(Vaccinated_Race(:,1,yy))>median(Vaccinated_Race(:,uu,yy)))
                pval_Vaccinated(uu,yy)=ranksum(Vaccinated_Race(:,uu,yy),Vaccinated_Race(:,1,yy),"tail",'left');
            else
                pval_Vaccinated(uu,yy)=ranksum(Vaccinated_Race(:,uu,yy),Vaccinated_Race(:,1,yy),"tail",'right');
            end
            Effect = meanEffectSize(Vaccinated_Race(:,uu,yy),Vaccinated_Race(:,1,yy),Effect="cliff");
            d_Vaccinated(uu,yy)=Effect.Effect;
        end
    end
    lb_vac=Vaccinated-squeeze(prctile(Vaccinated_Race,25));
    ub_vac=squeeze(prctile(Vaccinated_Race,75))-Vaccinated;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    % Summarize At least two doses Data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Vaccinated_2D=squeeze(median(Two_Dose_Race,1));
    pval_Two_Dose=NaN.*zeros(size(Vaccinated_2D));
    d_Two_Dose=NaN.*zeros(size(Dropout));
    for uu=2:length(U_Race)
        for yy=1:length(Yr)
            if(median(Two_Dose_Race(:,1,yy))>median(Two_Dose_Race(:,uu,yy)))
                pval_Two_Dose(uu,yy)=ranksum(Two_Dose_Race(:,uu,yy),Two_Dose_Race(:,1,yy),"tail",'left');
            else
                pval_Two_Dose(uu,yy)=ranksum(Two_Dose_Race(:,uu,yy),Two_Dose_Race(:,1,yy),"tail",'right');
            end
            Effect = meanEffectSize(Two_Dose_Race(:,uu,yy),Two_Dose_Race(:,1,yy),Effect="cliff");
            d_Two_Dose(uu,yy)=Effect.Effect;
        end
    end
    lb_vac_2D=Vaccinated_2D-squeeze(prctile(Two_Dose_Race,25));
    ub_vac_2D=squeeze(prctile(Two_Dose_Race,75))-Vaccinated_2D;

    
    
    U_Name={'White','Hispanic','Other/Multiple Races','African American'};

    dx=[-0.27 -0.09 0.09 0.27];
elseif(strcmp(Var,'Region'))
    load('NIS_Teen_Data_Sample.mat','Dropout_Region','Vaccinated_Region','U_Region','Two_Dose_Region','Yr');


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    % Summarize Dropout Data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Dropout=squeeze(median(Dropout_Region,1));
    pval_Dropout=NaN.*zeros(size(Dropout));
    d_dropout=NaN.*zeros(size(Dropout));
    for uu=2:length(U_Region)
        for yy=1:length(Yr)
            if(median(Dropout_Region(:,1,yy))>median(Dropout_Region(:,uu,yy)))
                pval_Dropout(uu,yy)=ranksum(Dropout_Region(:,uu,yy),Dropout_Region(:,1,yy),"tail",'left');
            else
                pval_Dropout(uu,yy)=ranksum(Dropout_Region(:,uu,yy),Dropout_Region(:,1,yy),"tail",'right');
            end
            Effect = meanEffectSize(Dropout_Region(:,uu,yy),Dropout_Region(:,1,yy),Effect="cliff");
            d_dropout(uu,yy)=Effect.Effect;
        end
    end
    lb_drop=Dropout-squeeze(prctile(Dropout_Region,25));
    ub_drop=squeeze(prctile(Dropout_Region,75))-Dropout;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    % Summarize At least one dose Data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Vaccinated=squeeze(median(Vaccinated_Region,1));
    pval_Vaccinated=NaN.*zeros(size(Vaccinated));
    d_Vaccinated=NaN.*zeros(size(Vaccinated));
    for uu=2:length(U_Region)
        for yy=1:length(Yr)
            if(median(Vaccinated_Region(:,1,yy))>median(Vaccinated_Region(:,uu,yy)))
                pval_Vaccinated(uu,yy)=ranksum(Vaccinated_Region(:,uu,yy),Vaccinated_Region(:,1,yy),"tail",'left');
            else
                pval_Vaccinated(uu,yy)=ranksum(Vaccinated_Region(:,uu,yy),Vaccinated_Region(:,1,yy),"tail",'right');
            end
            Effect = meanEffectSize(Vaccinated_Region(:,uu,yy),Vaccinated_Region(:,1,yy),Effect="cliff");
            d_Vaccinated(uu,yy)=Effect.Effect;
        end
    end
    lb_vac=Vaccinated-squeeze(prctile(Vaccinated_Region,25));
    ub_vac=squeeze(prctile(Vaccinated_Region,75))-Vaccinated;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    % Summarize At least two doses Data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Vaccinated_2D=squeeze(median(Two_Dose_Region,1));
    pval_Two_Dose=NaN.*zeros(size(Vaccinated_2D));
    d_Two_Dose=NaN.*zeros(size(Vaccinated_2D));
    for uu=2:length(U_Region)
        for yy=1:length(Yr)
            if(median(Two_Dose_Region(:,1,yy))>median(Two_Dose_Region(:,uu,yy)))
                pval_Two_Dose(uu,yy)=ranksum(Two_Dose_Region(:,uu,yy),Two_Dose_Region(:,1,yy),"tail",'left');
            else
                pval_Two_Dose(uu,yy)=ranksum(Two_Dose_Region(:,uu,yy),Two_Dose_Region(:,1,yy),"tail",'right');
            end
            Effect = meanEffectSize(Two_Dose_Region(:,uu,yy),Two_Dose_Region(:,1,yy),Effect="cliff");
            d_Two_Dose(uu,yy)=Effect.Effect;
        end
    end
    lb_vac_2D=Vaccinated_2D-squeeze(prctile(Two_Dose_Region,25));
    ub_vac_2D=squeeze(prctile(Two_Dose_Region,75))-Vaccinated_2D;
    
    U_Name={'Region I','Region II','Region III','Region IV','Region V','Region VI','Region VII','Region VIII','Region IX','Region X'};
    
    dx=[-0.36:0.08:-0.04 0.04:0.08:0.36];
elseif(strcmp(Var,'Mother_Education'))
    load('NIS_Teen_Data_Sample.mat','Dropout_Mother_Education','Vaccinated_Mother_Education','U_Mother_Education','Two_Dose_Mother_Education','Yr');
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    % Summarize Dropout Data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Dropout=squeeze(median(Dropout_Mother_Education,1));
    pval_Dropout=NaN.*zeros(size(Dropout));
    d_dropout=NaN.*zeros(size(Dropout));
    for uu=2:length(U_Mother_Education)
        for yy=1:length(Yr)
            if(median(Dropout_Mother_Education(:,1,yy))>median(Dropout_Mother_Education(:,uu,yy)))
                pval_Dropout(uu,yy)=ranksum(Dropout_Mother_Education(:,uu,yy),Dropout_Mother_Education(:,1,yy),"tail",'left');
            else
                pval_Dropout(uu,yy)=ranksum(Dropout_Mother_Education(:,uu,yy),Dropout_Mother_Education(:,1,yy),"tail",'right');
            end
            Effect = meanEffectSize(Dropout_Mother_Education(:,uu,yy),Dropout_Mother_Education(:,1,yy),Effect="cliff");
            d_dropout(uu,yy)=Effect.Effect;
        end
    end
    lb_drop=Dropout-squeeze(prctile(Dropout_Mother_Education,25));
    ub_drop=squeeze(prctile(Dropout_Mother_Education,75))-Dropout;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    % Summarize At least one dose Data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Vaccinated=squeeze(median(Vaccinated_Mother_Education,1));
    pval_Vaccinated=NaN.*zeros(size(Vaccinated));
    d_Vaccinated=NaN.*zeros(size(Vaccinated));
    for uu=2:length(U_Mother_Education)
        for yy=1:length(Yr)
            if(median(Vaccinated_Mother_Education(:,1,yy))>median(Vaccinated_Mother_Education(:,uu,yy)))
                pval_Vaccinated(uu,yy)=ranksum(Vaccinated_Mother_Education(:,uu,yy),Vaccinated_Mother_Education(:,1,yy),"tail",'left');
            else
                pval_Vaccinated(uu,yy)=ranksum(Vaccinated_Mother_Education(:,uu,yy),Vaccinated_Mother_Education(:,1,yy),"tail",'right');
            end
            Effect = meanEffectSize(Vaccinated_Mother_Education(:,uu,yy),Vaccinated_Mother_Education(:,1,yy),Effect="cliff");
            d_Vaccinated(uu,yy)=Effect.Effect;
        end
    end
    lb_vac=Vaccinated-squeeze(prctile(Vaccinated_Mother_Education,25));
    ub_vac=squeeze(prctile(Vaccinated_Mother_Education,75))-Vaccinated;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    % Summarize At least two doses Data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Vaccinated_2D=squeeze(median(Two_Dose_Mother_Education,1));
    pval_Two_Dose=NaN.*zeros(size(Vaccinated_2D));
    d_Two_Dose=NaN.*zeros(size(Vaccinated_2D));
    for uu=2:length(U_Mother_Education)
        for yy=1:length(Yr)
            if(median(Two_Dose_Mother_Education(:,1,yy))>median(Two_Dose_Mother_Education(:,uu,yy)))
                pval_Two_Dose(uu,yy)=ranksum(Two_Dose_Mother_Education(:,uu,yy),Two_Dose_Mother_Education(:,1,yy),"tail",'left');
            else
                pval_Two_Dose(uu,yy)=ranksum(Two_Dose_Mother_Education(:,uu,yy),Two_Dose_Mother_Education(:,1,yy),"tail",'right');
            end
            Effect = meanEffectSize(Two_Dose_Mother_Education(:,uu,yy),Two_Dose_Mother_Education(:,1,yy),Effect="cliff");
            d_Two_Dose(uu,yy)=Effect.Effect;
        end
    end
    lb_vac_2D=Vaccinated_2D-squeeze(prctile(Two_Dose_Mother_Education,25));
    ub_vac_2D=squeeze(prctile(Two_Dose_Mother_Education,75))-Vaccinated_2D;
    
    U_Name=U_Mother_Education;
    dx=[-0.125 0.125];
elseif(strcmp(Var,'Income_Poverty_Ratio'))
    load('NIS_Teen_Data_Sample.mat','Dropout_Income_Poverty_Ratio','Vaccinated_Income_Poverty_Ratio','Two_Dose_Income_Poverty_Ratio','Yr');

    U_Name={'Income poverty ratio: 0.5-1','Income poverty ratio: 1-2','Income poverty ratio: 2-3'};

    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    % Summarize Dropout Data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Dropout=squeeze(median(Dropout_Income_Poverty_Ratio,1));
    pval_Dropout=NaN.*zeros(size(Dropout));
    d_dropout=NaN.*zeros(size(Dropout));
    for uu=1:length(U_Name)-1
        for yy=1:length(Yr)
            if(median(Dropout_Income_Poverty_Ratio(:,3,yy))>median(Dropout_Income_Poverty_Ratio(:,uu,yy)))
                pval_Dropout(uu,yy)=ranksum(Dropout_Income_Poverty_Ratio(:,uu,yy),Dropout_Income_Poverty_Ratio(:,3,yy),"tail",'left');
            else
                pval_Dropout(uu,yy)=ranksum(Dropout_Income_Poverty_Ratio(:,uu,yy),Dropout_Income_Poverty_Ratio(:,3,yy),"tail",'right');
            end
            Effect = meanEffectSize(Dropout_Income_Poverty_Ratio(:,uu,yy),Dropout_Income_Poverty_Ratio(:,3,yy),Effect="cliff");
            d_dropout(uu,yy)=Effect.Effect;
        end
    end
    lb_drop=Dropout-squeeze(prctile(Dropout_Income_Poverty_Ratio,25));
    ub_drop=squeeze(prctile(Dropout_Income_Poverty_Ratio,75))-Dropout;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    % Summarize At least one dose Data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Vaccinated=squeeze(median(Vaccinated_Income_Poverty_Ratio,1));
    pval_Vaccinated=NaN.*zeros(size(Vaccinated));
    d_Vaccinated=NaN.*zeros(size(Dropout));
    for uu=1:length(U_Name)-1
        for yy=1:length(Yr)
            if(median(Vaccinated_Income_Poverty_Ratio(:,3,yy))>median(Vaccinated_Income_Poverty_Ratio(:,uu,yy)))
                pval_Vaccinated(uu,yy)=ranksum(Vaccinated_Income_Poverty_Ratio(:,uu,yy),Vaccinated_Income_Poverty_Ratio(:,3,yy),"tail",'left');
            else
                pval_Vaccinated(uu,yy)=ranksum(Vaccinated_Income_Poverty_Ratio(:,uu,yy),Vaccinated_Income_Poverty_Ratio(:,3,yy),"tail",'right');
            end
            Effect = meanEffectSize(Vaccinated_Income_Poverty_Ratio(:,uu,yy),Vaccinated_Income_Poverty_Ratio(:,3,yy),Effect="cliff");
            d_Vaccinated(uu,yy)=Effect.Effect;
        end
    end
    lb_vac=Vaccinated-squeeze(prctile(Vaccinated_Income_Poverty_Ratio,25));
    ub_vac=squeeze(prctile(Vaccinated_Income_Poverty_Ratio,75))-Vaccinated;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    % Summarize At least two doses Data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Vaccinated_2D=squeeze(median(Two_Dose_Income_Poverty_Ratio,1));
    pval_Two_Dose=NaN.*zeros(size(Vaccinated_2D));
    d_Two_Dose=NaN.*zeros(size(Dropout));
    for uu=1:length(U_Name)-1
        for yy=1:length(Yr)
            if(median(Two_Dose_Income_Poverty_Ratio(:,3,yy))>median(Two_Dose_Income_Poverty_Ratio(:,uu,yy)))
                pval_Two_Dose(uu,yy)=ranksum(Two_Dose_Income_Poverty_Ratio(:,uu,yy),Two_Dose_Income_Poverty_Ratio(:,3,yy),"tail",'left');
            else
                pval_Two_Dose(uu,yy)=ranksum(Two_Dose_Income_Poverty_Ratio(:,uu,yy),Two_Dose_Income_Poverty_Ratio(:,3,yy),"tail",'right');
            end
            Effect = meanEffectSize(Two_Dose_Income_Poverty_Ratio(:,uu,yy),Two_Dose_Income_Poverty_Ratio(:,3,yy),Effect="cliff");
            d_Two_Dose(uu,yy)=Effect.Effect;
        end
    end
    lb_vac_2D=Vaccinated_2D-squeeze(prctile(Two_Dose_Income_Poverty_Ratio,25));
    ub_vac_2D=squeeze(prctile(Two_Dose_Income_Poverty_Ratio,75))-Vaccinated_2D;
    dx=[-0.225 0 0.225];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate Tables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



Year_R=Yr(:);
Pop_Group=cell(length(Yr),length(U_Name));
for yy=1:length(Yr)
    for uu=1:length(U_Name)
        Pop_Group{yy,uu}=[num2str(100.*Dropout(uu,yy),'%3.1f') '% (IQR:' num2str(100.*Dropout(uu,yy)-100.*lb_drop(uu,yy),'%3.1f') '%' char(8211) num2str(100.*Dropout(uu,yy)+100.*ub_drop(uu,yy),'%3.1f') '%; p = ' num2str(pval_Dropout(uu,yy),'%5.4f') '; d = ' num2str(d_dropout(uu,yy),'%3.2f') ')'];
    end
end
Table_Dropout=[table(Year_R) cell2table(Pop_Group)];
Table_Dropout.Properties.VariableNames=[{'Year'};U_Name(:)]';


Year_R=Yr(:);
Pop_Group=cell(length(Yr),length(U_Name));
for yy=1:length(Yr)
    for uu=1:length(U_Name)
        Pop_Group{yy,uu}=[num2str(100.*Vaccinated(uu,yy),'%3.1f') '% (IQR:' num2str(100.*Vaccinated(uu,yy)-100.*lb_vac(uu,yy),'%3.1f') '%' char(8211) num2str(100.*Vaccinated(uu,yy)+100.*ub_vac(uu,yy),'%3.1f') '%; p = ' num2str(pval_Vaccinated(uu,yy),'%5.4f')  '; d = ' num2str(d_Vaccinated(uu,yy),'%3.2f') ')'];
    end
end
Table_Vaccination=[table(Year_R) cell2table(Pop_Group)];
Table_Vaccination.Properties.VariableNames=[{'Year'};U_Name(:)]';

Year_R=Yr(:);
Pop_Group=cell(length(Yr),length(U_Name));
for yy=1:length(Yr)
    for uu=1:length(U_Name)
        Pop_Group{yy,uu}=[num2str(100.*Vaccinated_2D(uu,yy),'%3.1f') '% (IQR:' num2str(100.*Vaccinated_2D(uu,yy)-100.*lb_vac_2D(uu,yy),'%3.1f') '%' char(8211) num2str(100.*Vaccinated_2D(uu,yy)+100.*ub_vac_2D(uu,yy),'%3.1f') '%; p = ' num2str(pval_Two_Dose(uu,yy),'%5.4f')  '; d = ' num2str(d_Two_Dose(uu,yy),'%3.2f') ')'];
    end
end
Table_Vaccination_2D=[table(Year_R) cell2table(Pop_Group)];
Table_Vaccination_2D.Properties.VariableNames=[{'Year'};U_Name(:)]';
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


set(gca,'LineWidth',2,'tickdir','out','Fontsize',14,'XTick',[Yr],'YTick',[0:10:100],'Yminortick','on');
xlabel('Year of survey','FontSize',16)
ylabel({'Dropout from','vaccination program'},'FontSize',16)
xlim([2015.5 2022.5]);
legend(U_Name,'Fontsize',12,'NumColumns',6,'Location','northoutside');
legend boxoff;
box off;


ylim([0 maxy]);
ytickformat('percentage');
text(-0.125,1.15,'C','Units','normalized','HorizontalAlignment','center','VerticalAlignment','middle','Fontsize',28);

exportgraphics(gcf, ['At_least_one_dose_Dropout_' Var '.pdf']);
print(gcf, ['At_least_one_dose_Dropout_' Var '.jpg'],'-djpeg','-r300');
end
