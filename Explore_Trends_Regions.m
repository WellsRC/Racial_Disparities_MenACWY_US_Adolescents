clear;
clc;
close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Colours for plotting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

C_Vac=[1 1 1;
hex2rgb('#374e55');];

C_Vac=interp1([0 1],C_Vac,linspace(0,1,3));
C_Vac=C_Vac(2:end,:);


C_Vac_2D=[1 1 1;
hex2rgb('#79af97');];
C_Vac_2D=interp1([0 1],C_Vac_2D,linspace(0,1,3));
C_Vac_2D=C_Vac_2D(2:end,:);

C_Drop=[1 1 1;
hex2rgb('#b24745');];
C_Drop=interp1([0 1],C_Drop,linspace(0,1,3));
C_Drop=C_Drop(2:end,:);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Load Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('NIS_Teen_Data_Sample.mat','Dropout_Region','Vaccinated_Region','Two_Dose_Region','Yr');

Region={'Region 1','Region 2','Region 3','Region 4','Region 5','Region 6','Region 7','Region 8','Region 9','Region 10'}';

Model={'No pivot';'Pivot 2017';'Pivot 2018';'Pivot 2019';'Pivot 2020';'Pivot 2021';'Pivot 2022'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Vaccination at least one dose
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
AIC_logit=zeros(length(Model),length(Region));
Data_Region=Vaccinated_Region;

T=Yr-2016;
for tt=0:6
    X=repmat(T,size(Data_Region,1),1);
    X=X(:);
    if(tt>=1)
        T2=[zeros(1,tt) [1:length(Yr)-tt]];
        T2=repmat(T2,size(Data_Region,1),1);
        X=[X T2(:)];
    end
    for rr=1:10
        Y=squeeze(Data_Region(:,rr,:));

        mdl_logit=fitglm(X,Y(:),'link','logit');
        AIC_logit(tt+1,rr)=mdl_logit.ModelCriterion.AIC;
    end
end
dAIC=[AIC_logit];

Pivot_Year=cell(10,1);
Coefficient=cell(10,2);
prob_tred_change=cell(10,1);

Trend_Plot=zeros(10,length(Yr));
for rr=1:10
    dAIC=AIC_logit(:,rr)-min(AIC_logit(:,rr));
    tt=find(dAIC==0)-1;
    
    X=repmat(T,size(Data_Region,1),1);
    X=X(:);
    if(tt>=1)
        T2=[zeros(1,tt) [1:length(Yr)-tt]];
        T2=repmat(T2,size(Data_Region,1),1);
        X=[X T2(:)];
    end

    Y=squeeze(Data_Region(:,rr,:));
    mdl_logit=fitglm(X,Y(:),'link','logit');
    
    ci_est=coefCI(mdl_logit,0.05);
    if(tt==0)
        Pivot_Year{rr}='None';
        prob_tred_change{rr}='N/A';
        Coefficient{rr,2}='N/A';
        Coefficient{rr,1}=[num2str(mdl_logit.Coefficients.Estimate(2),'%4.3f') '(' num2str(ci_est(2,1),'%4.3f') char(8211) num2str(ci_est(2,2),'%4.3f') ')'];
    else
        Pivot_Year{rr}=num2str(2016+tt);
        Coefficient{rr,1}=[num2str(mdl_logit.Coefficients.Estimate(2),'%4.3f') '(' num2str(ci_est(2,1),'%4.3f') char(8211) num2str(ci_est(2,2),'%4.3f') ')'];
        Coefficient{rr,2}=[num2str(mdl_logit.Coefficients.Estimate(3),'%4.3f') '(' num2str(ci_est(3,1),'%4.3f') char(8211) num2str(ci_est(3,2),'%4.3f') ')'];
        lb=norminv(0.0001,mdl_logit.Coefficients.Estimate(2),mdl_logit.Coefficients.SE(2))-0.01;
        ub=norminv(0.9999,mdl_logit.Coefficients.Estimate(2),mdl_logit.Coefficients.SE(2))+0.01;
        if(mdl_logit.Coefficients.Estimate(2)>0 && mdl_logit.Coefficients.Estimate(3)<0)
            prob_tred_change{rr}=num2str(integral(@(x)normpdf(x,mdl_logit.Coefficients.Estimate(2),mdl_logit.Coefficients.SE(2)).*(normcdf(-x,mdl_logit.Coefficients.Estimate(3),mdl_logit.Coefficients.SE(3))),lb,ub),'%4.3f');
        elseif(mdl_logit.Coefficients.Estimate(2)<0 && mdl_logit.Coefficients.Estimate(3)>0)
            prob_tred_change{rr}=num2str(integral(@(x)normpdf(x,mdl_logit.Coefficients.Estimate(2),mdl_logit.Coefficients.SE(2)).*(1-normcdf(-x,mdl_logit.Coefficients.Estimate(3),mdl_logit.Coefficients.SE(3))),lb,ub),'%4.3f');
        else
            prob_tred_change{rr}=0;
        end
        
    end
    if(tt>0)
        T2=[zeros(1,tt) [1:length(Yr)-tt]];
        X=[T(:) T2(:)];
    else
        X=T(:);
    end
    Trend_Plot(rr,:)=predict(mdl_logit,X);
end

Table_Vac=table(Region,Pivot_Year,Coefficient,prob_tred_change);

figure('units','normalized','outerposition',[0 0.05 0.45 1]);

for rr=10:-1:1
    subplot('Position',[0.0725 0.065+0.094.*(10-rr) 0.25 0.0725]) 
    temp_data=Data_Region(:,rr,:);
    T=repmat(Yr,size(Data_Region,1),1);
    scatter(T(:),100.*temp_data(:),5,C_Vac(2,:),'filled'); hold on;
    plot(Yr,100.*Trend_Plot(rr,:),'s-','LineWidth',2,'Color',C_Vac(1,:));
    
    if(rr==5)
        ylabel({'At least one dose of vaccine'},'FontSize',10)
    end
    ylim([60 100])
    xlim([2015.5 2022.5])
    ytickformat('percentage');
    if(rr==10)
        set(gca,'LineWidth',2,'tickdir','out','Fontsize',10,'XTick',[Yr],'YTick',[0:10:100],'Yminortick','on');
        xlabel('Year of survey','FontSize',10)
    else
        set(gca,'LineWidth',2,'tickdir','out','Fontsize',10,'XTick',[Yr],'YTick',[0:10:100],'Yminortick','on','XTickLabel',[]);
    end
    title(Region{rr},'Fontsize',10);
    box off;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Vaccination at least two doses
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
AIC_logit=zeros(length(Model),length(Region));
Data_Region=Two_Dose_Region;
Data2_Race=Dropout_Region;

T=Yr-2016;
for tt=0:6
    X=repmat(T,size(Data_Region,1),1);
    X=X(:);
    if(tt>=1)
        T2=[zeros(1,tt) [1:length(Yr)-tt]];
        T2=repmat(T2,size(Data_Region,1),1);
        X=[X T2(:)];
    end
    for rr=1:10
        Y=squeeze(Data_Region(:,rr,:));

        mdl_logit=fitglm(X,Y(:),'link','logit');
        AIC_logit(tt+1,rr)=mdl_logit.ModelCriterion.AIC;
        
        Y=squeeze(Data2_Race(:,rr,:));
        mdl_logit=fitglm(X,Y(:),'link','logit');
        AIC_logit(tt+1,rr)=AIC_logit(tt+1,rr)+mdl_logit.ModelCriterion.AIC;
    end
end
dAIC=[AIC_logit];

Pivot_Year=cell(10,1);
Coefficient=cell(10,2);

Trend_Plot=zeros(10,length(Yr));
for rr=1:10
    dAIC=AIC_logit(:,rr)-min(AIC_logit(:,rr));
    tt=find(dAIC==0)-1;
    
    X=repmat(T,size(Data_Region,1),1);
    X=X(:);
    if(tt>=1)
        T2=[zeros(1,tt) [1:length(Yr)-tt]];
        T2=repmat(T2,size(Data_Region,1),1);
        X=[X T2(:)];
    end

    Y=squeeze(Data_Region(:,rr,:));
    mdl_logit=fitglm(X,Y(:),'link','logit');
    
    ci_est=coefCI(mdl_logit,0.05);
    if(tt==0)
        Pivot_Year{rr}='None';
        prob_tred_change{rr}='N/A';
        Coefficient{rr,2}='N/A';
        Coefficient{rr,1}=[num2str(mdl_logit.Coefficients.Estimate(2),'%4.3f') '(' num2str(ci_est(2,1),'%4.3f') char(8211) num2str(ci_est(2,2),'%4.3f') ')'];
    else
        Pivot_Year{rr}=num2str(2016+tt);
        Coefficient{rr,1}=[num2str(mdl_logit.Coefficients.Estimate(2),'%4.3f') '(' num2str(ci_est(2,1),'%4.3f') char(8211) num2str(ci_est(2,2),'%4.3f') ')'];
        Coefficient{rr,2}=[num2str(mdl_logit.Coefficients.Estimate(3),'%4.3f') '(' num2str(ci_est(3,1),'%4.3f') char(8211) num2str(ci_est(3,2),'%4.3f') ')'];

        lb=norminv(0.0001,mdl_logit.Coefficients.Estimate(2),mdl_logit.Coefficients.SE(2))-0.01;
        ub=norminv(0.9999,mdl_logit.Coefficients.Estimate(2),mdl_logit.Coefficients.SE(2))+0.01;
        if(mdl_logit.Coefficients.Estimate(2)>0 && mdl_logit.Coefficients.Estimate(3)<0)
            prob_tred_change{rr}=num2str(integral(@(x)normpdf(x,mdl_logit.Coefficients.Estimate(2),mdl_logit.Coefficients.SE(2)).*(normcdf(-x,mdl_logit.Coefficients.Estimate(3),mdl_logit.Coefficients.SE(3))),lb,ub),'%4.3f');
        elseif(mdl_logit.Coefficients.Estimate(2)<0 && mdl_logit.Coefficients.Estimate(3)>0)
            prob_tred_change{rr}=num2str(integral(@(x)normpdf(x,mdl_logit.Coefficients.Estimate(2),mdl_logit.Coefficients.SE(2)).*(1-normcdf(-x,mdl_logit.Coefficients.Estimate(3),mdl_logit.Coefficients.SE(3))),lb,ub),'%4.3f');
        else
            prob_tred_change{rr}=0;
        end
    end
    if(tt>0)
        T2=[zeros(1,tt) [1:length(Yr)-tt]];
        X=[T(:) T2(:)];
    else
        X=T(:);
    end
    Trend_Plot(rr,:)=predict(mdl_logit,X);
end

Table_Vac_2D=table(Region,Pivot_Year,Coefficient,prob_tred_change);
for rr=10:-1:1
    subplot('Position',[0.4025 0.065+0.094.*(10-rr) 0.25 0.0725]) 
    temp_data=Data_Region(:,rr,:);
    T=repmat(Yr,size(Data_Region,1),1);
    scatter(T(:),100.*temp_data(:),5,C_Vac_2D(2,:),'filled'); hold on;
    plot(Yr,100.*Trend_Plot(rr,:),'s-','LineWidth',2,'Color',C_Vac_2D(1,:));
    
    if(rr==5)
        ylabel({'At least two doses of vaccine'},'FontSize',10)
    end
    ylim([0 80])
    xlim([2015.5 2022.5])
    ytickformat('percentage');
    if(rr==10)
        set(gca,'LineWidth',2,'tickdir','out','Fontsize',10,'XTick',[Yr],'YTick',[0:20:100],'Yminortick','on');
        xlabel('Year of survey','FontSize',10)
    else
        set(gca,'LineWidth',2,'tickdir','out','Fontsize',10,'XTick',[Yr],'YTick',[0:20:100],'Yminortick','on','XTickLabel',[]);
    end
    title(Region{rr},'Fontsize',10);
    box off;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Drop-out
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% AIC_logit=zeros(length(Model),length(Race));
Data_Region=Dropout_Region;

T=Yr-2016;

dAIC=[AIC_logit];

Pivot_Year=cell(10,1);
Coefficient=cell(10,2);

Trend_Plot=zeros(10,length(Yr));
for rr=1:10
    dAIC=AIC_logit(:,rr)-min(AIC_logit(:,rr));
    tt=find(dAIC==0)-1;
    
    X=repmat(T,size(Data_Region,1),1);
    X=X(:);
    if(tt>=1)
        T2=[zeros(1,tt) [1:length(Yr)-tt]];
        T2=repmat(T2,size(Data_Region,1),1);
        X=[X T2(:)];
    end

    Y=squeeze(Data_Region(:,rr,:));
    mdl_logit=fitglm(X,Y(:),'link','logit');
    
    ci_est=coefCI(mdl_logit,0.05);
    if(tt==0)
        Pivot_Year{rr}='None';
        prob_tred_change{rr}='N/A';
        Coefficient{rr,2}='N/A';
        Coefficient{rr,1}=[num2str(mdl_logit.Coefficients.Estimate(2),'%4.3f') '(' num2str(ci_est(2,1),'%4.3f') char(8211) num2str(ci_est(2,2),'%4.3f') ')'];
    else
        Pivot_Year{rr}=num2str(2016+tt);
        Coefficient{rr,1}=[num2str(mdl_logit.Coefficients.Estimate(2),'%4.3f') '(' num2str(ci_est(2,1),'%4.3f') char(8211) num2str(ci_est(2,2),'%4.3f') ')'];
        Coefficient{rr,2}=[num2str(mdl_logit.Coefficients.Estimate(3),'%4.3f') '(' num2str(ci_est(3,1),'%4.3f') char(8211) num2str(ci_est(3,2),'%4.3f') ')'];
        lb=norminv(0.0001,mdl_logit.Coefficients.Estimate(2),mdl_logit.Coefficients.SE(2))-0.01;
        ub=norminv(0.9999,mdl_logit.Coefficients.Estimate(2),mdl_logit.Coefficients.SE(2))+0.01;
        if(mdl_logit.Coefficients.Estimate(2)>0 && mdl_logit.Coefficients.Estimate(3)<0)
            prob_tred_change{rr}=num2str(integral(@(x)normpdf(x,mdl_logit.Coefficients.Estimate(2),mdl_logit.Coefficients.SE(2)).*(normcdf(-x,mdl_logit.Coefficients.Estimate(3),mdl_logit.Coefficients.SE(3))),lb,ub),'%4.3f');
        elseif(mdl_logit.Coefficients.Estimate(2)<0 && mdl_logit.Coefficients.Estimate(3)>0)
            prob_tred_change{rr}=num2str(integral(@(x)normpdf(x,mdl_logit.Coefficients.Estimate(2),mdl_logit.Coefficients.SE(2)).*(1-normcdf(-x,mdl_logit.Coefficients.Estimate(3),mdl_logit.Coefficients.SE(3))),lb,ub),'%4.3f');
        else
            prob_tred_change{rr}=0;
        end
    end
    if(tt>0)
        T2=[zeros(1,tt) [1:length(Yr)-tt]];
        X=[T(:) T2(:)];
    else
        X=T(:);
    end
    Trend_Plot(rr,:)=predict(mdl_logit,X);
end

Table_Dropout=table(Region,Pivot_Year,Coefficient,prob_tred_change);

for rr=10:-1:1
    subplot('Position',[0.7325 0.065+0.094.*(10-rr) 0.25 0.0725]) 
    temp_data=Data_Region(:,rr,:);
    T=repmat(Yr,size(Data_Region,1),1);
    scatter(T(:),100.*temp_data(:),5,C_Drop(2,:),'filled'); hold on;
    plot(Yr,100.*Trend_Plot(rr,:),'s-','LineWidth',2,'Color',C_Drop(1,:));
    
    if(rr==5)
        ylabel({'Drop-out rate'},'FontSize',10)
    end
    ylim([0 80])
    xlim([2015.5 2022.5])
    ytickformat('percentage');

    if(rr==10)
        set(gca,'LineWidth',2,'tickdir','out','Fontsize',10,'XTick',[Yr],'YTick',[0:20:100],'Yminortick','on');
        xlabel('Year of survey','FontSize',10)
    else
        set(gca,'LineWidth',2,'tickdir','out','Fontsize',10,'XTick',[Yr],'YTick',[0:20:100],'Yminortick','on','XTickLabel',[]);
    end
    title(Region{rr},'Fontsize',10);
    box off;
end


exportgraphics(gcf, ['Figure_Trend_Region.pdf']);
print(gcf, ['Figure_Trend_Region.jpg'],'-djpeg','-r300');
