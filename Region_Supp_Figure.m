clear;
clc;
close all;


load('NIS_Teen_Data_Sample.mat','Dropout_Region','Vaccinated_Region','U_Region','Two_Dose_Region','Yr');
C=[hex2rgb('#41ae76'); hex2rgb('#2171b5');hex2rgb('#cb181d');];
C_err=[hex2rgb('#00441b'); hex2rgb('#08306b');hex2rgb('#67000d');];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Summarize Dropout Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Dropout=squeeze(median(Dropout_Region,1));
pval_Dropout=NaN.*zeros(size(Dropout));
for uu=2:length(U_Region)
    for yy=1:length(Yr)
        dx=Dropout_Region(:,uu,yy)-Dropout_Region(:,1,yy);
        if(prctile(dx,5)>0)
            pval_Dropout(uu,yy)=sum(dx<0)./length(dx);
        elseif(prctile(dx,95)<0)
            pval_Dropout(uu,yy)=sum(dx>0)./length(dx);
        else
            pval_Dropout(uu,yy)=min(sum(dx>0)./length(dx),sum(dx<0)./length(dx));
        end
    end
end
lb_drop=Dropout-squeeze(prctile(Dropout_Region,25));
ub_drop=squeeze(prctile(Dropout_Region,75))-Dropout;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Summarize At least one dose Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Vaccinated=squeeze(median(Vaccinated_Region,1));
pval_Vaccinated=NaN.*zeros(size(Vaccinated));
for uu=2:length(U_Region)
    for yy=1:length(Yr)
        dx=Vaccinated_Region(:,uu,yy)-Vaccinated_Region(:,1,yy);
        if(prctile(dx,5)>0)
            pval_Vaccinated(uu,yy)=sum(dx<0)./length(dx);
        elseif(prctile(dx,95)<0)
            pval_Vaccinated(uu,yy)=sum(dx>0)./length(dx);
        else
            pval_Vaccinated(uu,yy)=min(sum(dx>0)./length(dx),sum(dx<0)./length(dx));
        end
    end
end
lb_vac=Vaccinated-squeeze(prctile(Vaccinated_Region,25));
ub_vac=squeeze(prctile(Vaccinated_Region,75))-Vaccinated;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Summarize At least two doses Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Vaccinated_2D=squeeze(median(Two_Dose_Region,1));
pval_Two_Dose=NaN.*zeros(size(Vaccinated_2D));
for uu=2:length(U_Region)
    for yy=1:length(Yr)
        dx=Two_Dose_Region(:,uu,yy)-Two_Dose_Region(:,1,yy);
        if(prctile(dx,5)>0)
            pval_Two_Dose(uu,yy)=sum(dx<0)./length(dx);
        elseif(prctile(dx,95)<0)
            pval_Two_Dose(uu,yy)=sum(dx>0)./length(dx);
        else
            pval_Two_Dose(uu,yy)=min(sum(dx>0)./length(dx),sum(dx<0)./length(dx));
        end
    end
end
lb_vac_2D=Vaccinated_2D-squeeze(prctile(Two_Dose_Region,25));
ub_vac_2D=squeeze(prctile(Two_Dose_Region,75))-Vaccinated_2D;

U_Name={'Region 1','Region 2','Region 3','Region 4','Region 5','Region 6','Region 7','Region 8','Region 9','Region 10'};


figure('units','normalized','outerposition',[0 0.05 0.6 1]);
dx=[-0.225 0 0.225];
for rr=1:length(U_Name)
    pp=subplot('Position',[0.055+0.5*rem(rr-1,2) 0.785-0.18.*floor((rr-1)/2) 0.44 0.165]); 

    Region_Data=[Vaccinated(rr,:);Vaccinated_2D(rr,:);Dropout(rr,:)];
    lb_Region_Data=[lb_vac(rr,:);lb_vac_2D(rr,:);lb_drop(rr,:)];
    ub_Region_Data=[ub_vac(rr,:);ub_vac_2D(rr,:);ub_drop(rr,:)];
    b=bar([Yr],100.*Region_Data,'LineWidth',1.5);
    for ii=1:length(b)
        b(ii).FaceColor=C(ii,:);
        b(ii).EdgeColor=C_err(ii,:);
    end
    hold on
    % At Least one dose error bars
    for ii=1:3
        errorbar(dx(ii)+[Yr],100.*Region_Data(ii,:),100.*lb_Region_Data(ii,:),100.*ub_Region_Data(ii,:),'CapSize',0,'LineStyle','none','Color',C_err(ii,:),'LineWidth',2);
    end
    if(rr>=9)
        set(gca,'LineWidth',2,'tickdir','out','Fontsize',14,'XTick',[Yr],'YTick',[0:20:100],'Yminortick','off');
        xlabel('Year of survey','FontSize',16)
    else
        set(gca,'LineWidth',2,'tickdir','out','Fontsize',14,'XTick',[Yr],'YTick',[0:20:100],'Yminortick','off','XTickLabel',[]);
    end
    if(rr==1)
        l=legend({'At least one dose coverage','At least two doses coverage','Drop-out rate'},'Fontsize',12,'NumColumns',6,'Location','northoutside');
        l.Position=[0.235915505812621,0.962156109511778,0.566021113905689,0.025329280014337];
        legend boxoff;
    end
    text(0.01,1,U_Name{rr},'VerticalAlignment','top','Units','normalized','FontSize',14)
    box off;
    ylim([0 110]);
    xlim([2015.5 2022.5]);
    ytickformat('percentage');
end


exportgraphics(gcf, ['Region_Supp_Fig.pdf']);
print(gcf, ['Region_Supp_Fig.jpg'],'-djpeg','-r300');