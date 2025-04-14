clear;
clc;
close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Colours for plotting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

C_Vac=[hex2rgb('#238b45');
hex2rgb('#00441b');];
x_vac=linspace(0,1,size(C_Vac,1)-1);


C_Vac_2D=[hex2rgb('#2171b5');
hex2rgb('#08306b');];
x_vac_2D=linspace(0,1,size(C_Vac_2D,1)-1);

C_Drop=[hex2rgb('#cb181d');
hex2rgb('#67000d');];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Load Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('NIS_Teen_Data_Sample.mat','Dropout_Race_Income_Poverty_Ratio','Two_Dose_Race_Income_Poverty_Ratio','U_Race','Yr');
reorder_array=[4 1 3 2];
U_Race=U_Race(reorder_array);
Dropout_Race_Income_Poverty_Ratio=Dropout_Race_Income_Poverty_Ratio(:,reorder_array,:,:);
Two_Dose_Race_Income_Poverty_Ratio=Two_Dose_Race_Income_Poverty_Ratio(:,reorder_array,:,:);

Race={'NH White','Hispanic','NH Other + multiple races','NH African American'}';
PIRv={'PIR \leq 1', '1< PIR \leq 2', 'PIR>2'}';
Model={'No pivot';'Pivot 2017';'Pivot 2018';'Pivot 2019';'Pivot 2020';'Pivot 2021';'Pivot 2022'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Vaccination at least one dose
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55


yyax=[0.74 0.41 0.075];
figure('units','normalized','outerposition',[0.2 0.05 0.6 1]);

for pir=1:3
    AIC_logit=zeros(length(Model),length(Race));
    Data_Race=squeeze(Two_Dose_Race_Income_Poverty_Ratio(:,:,pir,:));
    Data2_Race=squeeze(Dropout_Race_Income_Poverty_Ratio(:,:,pir,:));
    
    T=Yr-2016;
    for tt=0:6
        X=repmat(T,size(Data_Race,1),1);
        X=X(:);
        if(tt>=1)
            T2=[zeros(1,tt) [1:length(Yr)-tt]];
            T2=repmat(T2,size(Data_Race,1),1);
            X=[X T2(:)];
        end
        for rr=1:4
            Y=squeeze(Data_Race(:,rr,:));
            
            Y(Y==1)=1-10^(-4);
            Y(Y==0)=10^(-4);
            mdl_logit=fitglm(X,Y(:),'link','logit');
            AIC_logit(tt+1,rr)=mdl_logit.ModelCriterion.AIC;
            
            Y=squeeze(Data2_Race(:,rr,:));

            Y(Y==1)=1-10^(-4);
            Y(Y==0)=10^(-4);
            mdl_logit=fitglm(X,Y(:),'link','logit');
            AIC_logit(tt+1,rr)=AIC_logit(tt+1,rr)+mdl_logit.ModelCriterion.AIC;
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    % Drop-out
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    
    Data_Race=squeeze(Dropout_Race_Income_Poverty_Ratio(:,:,pir,:));
    
    T=Yr-2016;
    
    
    Pivot_Year=cell(4,1);
    Coefficient=cell(4,2);
    prob_tred_change=cell(4,2);
    Trend_Plot=zeros(4,length(Yr));
    PIR=cell(4,1);
    for rr=1:4
        PIR{rr}=PIRv{pir};
        dAIC=AIC_logit(:,rr)-min(AIC_logit(:,rr));
        tt=find(dAIC==0)-1;
        
        X=repmat(T,size(Data_Race,1),1);
        X=X(:);
        if(tt>=1)
            T2=[zeros(1,tt) [1:length(Yr)-tt]];
            T2=repmat(T2,size(Data_Race,1),1);
            X=[X T2(:)];
        end
    
        Y=squeeze(Data_Race(:,rr,:));
        Y(Y==1)=1-10^(-4);
        Y(Y==0)=10^(-4);
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
    if(pir==1)
        Table_Dropout=table(PIR,Race,Pivot_Year,Coefficient,prob_tred_change);
    else
        Table_Dropout=[Table_Dropout; table(PIR,Race,Pivot_Year,Coefficient,prob_tred_change)];
    end
    
    for rr=1:4
        subplot('Position',[0.085+0.2375.*(rr-1) yyax(pir) 0.195 0.23]) 
        temp_data=Data_Race(:,rr,:);
        T=repmat(Yr,size(Data_Race,1),1);
        scatter(T(:),100.*temp_data(:),5,C_Drop(2,:),'filled'); hold on;
        plot(Yr,100.*Trend_Plot(rr,:),'s-','LineWidth',2,'Color',C_Drop(1,:));
        
        set(gca,'LineWidth',2,'tickdir','out','Fontsize',12,'XTick',[Yr],'YTick',[0:10:100],'Yminortick','on');
        xlabel('Year of survey','FontSize',14)
        
        set(gca,'LineWidth',2,'tickdir','out','Fontsize',12,'XTick',[Yr],'YTick',[0:10:100],'Yminortick','on','YTickLabel',[]);
        
        ylim([0 100])
        xlim([2015.5 2022.5])
        ytickformat('percentage');
        if(rr==1)
            ylabel({'Drop-out rate'},'FontSize',14)
        end
        title(Race{rr},'Fontsize',12);
        box off;
        if(rr==1)
            text(-0.375,0.99,char(64+rr+3.*(pir-1)),'FontSize',24,'Units','normalized','VerticalAlignment','Bottom','HorizontalAlignment','center')
        else
            text(-0.16,0.99,char(64+rr+3.*(pir-1)),'FontSize',24,'Units','normalized','VerticalAlignment','Bottom','HorizontalAlignment','center')
        end
    end
end
exportgraphics(gcf, ['Figure_Trend_Race_PIR.pdf']);
print(gcf, ['Figure_Trend_Racee_PIR.jpg'],'-djpeg','-r300');
